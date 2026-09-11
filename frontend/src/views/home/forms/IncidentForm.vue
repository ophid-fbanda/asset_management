<script setup>
import { computed, onMounted, reactive } from 'vue'
import { Select, Textarea } from 'primevue'
import { objectComplete, objectReset, objectResetSet } from '@/api/objectx'
import { dataFetchToCache, dataFromCache, dataRefreshCache, dataUpload } from '@/api/datax'
import FeedBack from '@/commons/FeedBack.vue'

const props = defineProps({
  collected: { type: Array, default: () => [] },
})

const incidentTypes = dataFromCache('meta/incident_types')
const asset = computed(() => props.collected[0] ?? {})

const form = reactive({
  incidentTypeId: null,
  eventNotes: null,
  incidentAssetImage: null,
  incidentPoliceReport: null,
})

const ui = reactive({ busy: null, error: null, success: null })

const onImagePick = (event) => {
  form.incidentAssetImage = event.target.files?.[0] ?? null
}

const onReportPick = (event) => {
  form.incidentPoliceReport = event.target.files?.[0] ?? null
}

const submitForm = async () => {
  if (!objectComplete(form, ['eventNotes', 'incidentAssetImage', 'incidentPoliceReport'])) {
    objectResetSet(ui, 'error', 'Complete the form.')
    return
  }
  if (!asset.value.asset_id || !asset.value.station_id) {
    objectResetSet(ui, 'error', 'Asset station is missing. Refresh and try again.')
    return
  }

  objectResetSet(ui, 'busy', true)

  const payload = {
    incidentTypeId: form.incidentTypeId,
    eventNotes: form.eventNotes ?? '',
    registeredAssetId: asset.value.asset_id,
    eventStationId: asset.value.station_id,
  }
  if (form.incidentAssetImage) payload.incidentAssetImage = form.incidentAssetImage
  if (form.incidentPoliceReport) payload.incidentPoliceReport = form.incidentPoliceReport

  const response = await dataUpload('home/incident', payload)
  if (response.status === 200) {
    const stationId = asset.value.station_id
    objectReset(form)
    objectResetSet(ui, 'success', 'Incident reported successfully.')
    dataRefreshCache('home/incidents')
    dataRefreshCache('home/assets')
    if (stationId != null) {
      dataRefreshCache(`assets/incidents/${stationId}`)
      dataRefreshCache(`approvals/supervisory/pending/${stationId}`)
      dataRefreshCache(`approvals/management/pending/${stationId}`)
    }
  } else {
    objectResetSet(ui, 'error', response.data)
  }
}

onMounted(() => {
  dataFetchToCache('meta/incident_types')
})
</script>

<template>
  <div class="flex min-h-0 flex-1 flex-col gap-3">
    <h2 class="text-base font-semibold text-[#384884]">Report Incident</h2>

    <section class="flex w-full sm:w-1/2 flex-col gap-4 self-start rounded-md border border-[#c5cce3] bg-white p-4">
      <h3 class="text-sm font-semibold uppercase tracking-wide text-[#384884]">
        {{ asset.asset_type }} — {{ asset.brand }} {{ asset.model }}
        <span class="ml-2 text-xs font-normal text-surface-500">{{ asset.asset_number ?? asset.serial_number }}</span>
      </h3>

      <div class="flex flex-col gap-4">
        <div class="flex flex-col gap-1.5">
          <label class="text-sm font-medium text-[#384884]">Incident Type</label>
          <Select
            v-model="form.incidentTypeId"
            :options="incidentTypes"
            option-label="name"
            option-value="id"
            placeholder="Select type"
            filter
            class="w-full"
          />
        </div>

        <div class="flex flex-col gap-1.5">
          <label class="text-sm font-medium text-[#384884]">Notes</label>
          <Textarea v-model="form.eventNotes" rows="3" auto-resize placeholder="Optional notes" class="w-full" />
        </div>

        <div class="flex flex-col gap-1.5">
          <label class="text-sm font-medium text-[#384884]">Asset Image</label>
          <input
            type="file"
            accept=".pdf,.jpeg,.jpg,.png"
            class="block w-full text-sm text-surface-600 file:mr-3 file:border file:border-[#c5cce3] file:bg-[#e8eefa] file:px-3 file:py-1.5 file:text-xs file:font-medium file:text-[#384884]"
            @change="onImagePick"
          />
        </div>

        <div class="flex flex-col gap-1.5">
          <label class="text-sm font-medium text-[#384884]">Police Report</label>
          <input
            type="file"
            accept=".pdf,.jpeg,.jpg,.png"
            class="block w-full text-sm text-surface-600 file:mr-3 file:border file:border-[#c5cce3] file:bg-[#e8eefa] file:px-3 file:py-1.5 file:text-xs file:font-medium file:text-[#384884]"
            @change="onReportPick"
          />
        </div>
      </div>

      <div class="flex justify-end">
        <button
          type="button"
          :disabled="ui.busy"
          class="flex cursor-pointer items-center gap-2 rounded-sm border border-[#384884] bg-[#e8eefa] px-3 py-1.5 text-xs font-medium text-[#384884] transition hover:bg-[#384884] hover:text-white disabled:cursor-not-allowed disabled:opacity-60"
          @click="submitForm"
        >
          <i class="pi text-sm" :class="ui.busy ? 'pi-spinner pi-spin' : 'pi-check'" />
          <span>Submit Incident</span>
        </button>
      </div>
    </section>

    <div class="flex h-14 shrink-0 items-center border-t border-[#c5cce3] px-3">
      <FeedBack :ui="ui" />
    </div>
  </div>
</template>
