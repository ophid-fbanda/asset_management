<script setup>
import { onMounted, reactive } from 'vue'
import { Select, Textarea } from 'primevue'
import { objectComplete, objectResetSet } from '@/api/objectx'
import { dataFetchToCache, dataFromCache, dataSend } from '@/api/datax'
import Feedback from '@/commons/Feedback.vue'

const props = defineProps({
  collected: { type: Array, default: () => [] },
})

const eventStation  = dataFromCache('role/20')
const staffProfiles = dataFromCache('meta/staff_profiles')

const form = reactive({
  receivingStaffId: null,
  notes: null,
})

const ui = reactive({ busy: null, error: null, success: null })

const submitForm = async () => {
  if (!objectComplete(form)) {
    objectResetSet(ui, 'error', 'Please complete all required fields.')
    return
  }
  objectResetSet(ui, 'busy', true)
  const payload = {
    ...form,
    eventStationId: eventStation.value,
    assetIds: props.collected.map((a) => a.asset_id),
  }
  const response = await dataSend('assets/issuance', payload)
  if (response.status === 200) {
    objectResetSet(ui, 'success', 'Issuance submitted successfully.')
  } else {
    objectResetSet(ui, 'error', response.data)
  }
}

onMounted(() => {
  dataFetchToCache('meta/staff_profiles')
})
</script>

<template>
  <div class="flex min-h-0 flex-1 flex-col gap-3">
    <h2 class="text-base font-semibold text-[#384884]">Issue Assets</h2>

    <div class="flex min-h-0 flex-1 flex-col gap-4 overflow-y-auto pr-2">

      <!-- Form fields -->
      <section class="flex w-full sm:w-1/2 flex-col gap-4 self-start rounded-md border border-[#c5cce3] bg-white p-4">
        <h3 class="text-sm font-semibold uppercase tracking-wide text-[#384884]">Issuance Details</h3>

        <div class="flex flex-col gap-4">
          <div class="flex flex-col gap-1.5">
            <label class="text-sm font-medium text-[#384884]">Recipient</label>
            <Select
              v-model="form.receivingStaffId"
              :options="staffProfiles"
              option-label="full_name"
              option-value="id"
              placeholder="Select staff member"
              filter
              class="w-full"
            />
          </div>

          <div class="flex flex-col gap-1.5">
            <label class="text-sm font-medium text-[#384884]">Notes</label>
            <Textarea v-model="form.notes" rows="2" auto-resize placeholder="Optional notes" class="w-full" />
          </div>
        </div>

        <div class="flex justify-end">
          <button
            type="button"
            :disabled="ui.busy"
            class="flex cursor-pointer items-center gap-2 rounded-sm border border-[#384884] bg-[#e8eefa] px-3 py-1.5 text-xs font-medium text-[#384884] transition hover:bg-[#384884] hover:text-white disabled:cursor-not-allowed disabled:opacity-60"
            @click="submitForm"
          >
            <i class="pi text-sm" :class="ui.busy ? 'pi-spinner pi-spin' : 'pi-send'" />
            <span>Submit Issuance</span>
          </button>
        </div>
      </section>

    </div>

    <div class="flex h-14 shrink-0 items-center border-t border-[#c5cce3] px-3">
      <Feedback :ui="ui" />
    </div>
  </div>
</template>
