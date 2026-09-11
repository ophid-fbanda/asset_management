<script setup>
import { computed, onMounted, reactive } from 'vue'
import { DatePicker, Select, Textarea } from 'primevue'
import { objectComplete, objectReset, objectResetSet } from '@/api/objectx'
import { dataFetchToCache, dataFromCache, dataSend } from '@/api/datax'
import FeedBack from '@/commons/FeedBack.vue'

const props = defineProps({
  collected: { type: Array, default: () => [] },
})

const eventStation      = dataFromCache('role/20')
const verificationTypes = dataFromCache('meta/verification_types')
const conditionTypes    = dataFromCache('meta/condition_types')

const asset = computed(() => props.collected[0] ?? {})

const form = reactive({
  verificationTypeId:      null,
  verifiedConditionTypeId: null,
  eventDate:               null,
  eventNotes:              null,
})

const ui = reactive({ busy: null, error: null, success: null })

const toIsoDate = (value) => {
  if (!(value instanceof Date)) return value
  const pad = (n) => String(n).padStart(2, '0')
  return `${value.getFullYear()}-${pad(value.getMonth() + 1)}-${pad(value.getDate())}`
}

const submitForm = async () => {
  if (!objectComplete(form, ['eventNotes'])) {
    objectResetSet(ui, 'error', 'Complete the form.')
    return
  }
  objectResetSet(ui, 'busy', true)
  const response = await dataSend('assets/verification', {
    ...form,
    eventDate: toIsoDate(form.eventDate),
    registeredAssetId: asset.value.asset_id,
    eventStationId:    eventStation.value,
  })
  if (response.status === 200) {
    objectReset(form)
    objectResetSet(ui, 'success', 'Verification submitted successfully.')
  } else {
    objectResetSet(ui, 'error', response.data)
  }
}

onMounted(() => {
  dataFetchToCache('meta/verification_types')
  dataFetchToCache('meta/condition_types')
})
</script>

<template>
  <div class="flex min-h-0 flex-1 flex-col gap-3">
    <h2 class="text-base font-semibold text-[#384884]">Verify Asset</h2>

    <section class="flex w-full sm:w-1/2 flex-col gap-4 self-start rounded-md border border-[#c5cce3] bg-white p-4">
      <h3 class="text-sm font-semibold uppercase tracking-wide text-[#384884]">
        {{ asset.asset_type }} — {{ asset.brand }} {{ asset.model }}
        <span class="ml-2 text-xs font-normal text-surface-500">{{ asset.asset_number ?? asset.serial_number }}</span>
      </h3>


      <div class="grid grid-cols-1 gap-4 sm:grid-cols-2">
        <div class="flex flex-col gap-1.5">
          <label class="text-sm font-medium text-[#384884]">Verification Type</label>
          <Select
            v-model="form.verificationTypeId"
            :options="verificationTypes"
            option-label="name"
            option-value="id"
            placeholder="Select type"
            filter
            class="w-full"
          />
        </div>

        <div class="flex flex-col gap-1.5">
          <label class="text-sm font-medium text-[#384884]">Verified Condition</label>
          <Select
            v-model="form.verifiedConditionTypeId"
            :options="conditionTypes"
            option-label="name"
            option-value="id"
            placeholder="Select condition"
            filter
            class="w-full"
          />
        </div>
      </div>

      <div class="flex flex-col gap-1.5">
        <label class="text-sm font-medium text-[#384884]">Verification Date</label>
        <DatePicker
          v-model="form.eventDate"
          date-format="yy-mm-dd"
          show-icon
          placeholder="Select date"
          class="w-full"
        />
      </div>

      <div class="flex flex-col gap-1.5">
        <label class="text-sm font-medium text-[#384884]">Notes</label>
        <Textarea v-model="form.eventNotes" rows="3" auto-resize placeholder="Optional notes" class="w-full" />
      </div>

      <div class="flex justify-end">
        <button
          type="button"
          :disabled="ui.busy"
          class="flex cursor-pointer items-center gap-2 rounded-sm border border-[#384884] bg-[#e8eefa] px-3 py-1.5 text-xs font-medium text-[#384884] transition hover:bg-[#384884] hover:text-white disabled:cursor-not-allowed disabled:opacity-60"
          @click="submitForm"
        >
          <i class="pi text-sm" :class="ui.busy ? 'pi-spinner pi-spin' : 'pi-check'" />
          <span>Submit Verification</span>
        </button>
      </div>
    </section>

    <div class="flex h-14 shrink-0 items-center border-t border-[#c5cce3] px-3">
      <FeedBack :ui="ui" />
    </div>
  </div>
</template>
