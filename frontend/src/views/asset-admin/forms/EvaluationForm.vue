<script setup>
import { computed, onMounted, reactive } from 'vue'
import { InputNumber, Select, Textarea } from 'primevue'
import { objectComplete, objectReset, objectResetSet } from '@/api/objectx'
import { dataFetchToCache, dataFromCache, dataSend } from '@/api/datax'
import FeedBack from '@/commons/FeedBack.vue'

const props = defineProps({
  collected: { type: Array, default: () => [] },
})

const eventStation    = dataFromCache('role/20')
const evaluationTypes = dataFromCache('meta/evaluation_types')

const asset = computed(() => props.collected[0] ?? {})

const form = reactive({
  evaluationTypeId: null,
  evaluatedValue:   null,
  eventNotes:       null,
})

const ui = reactive({ busy: null, error: null, success: null })

const submitForm = async () => {
  if (!objectComplete(form, ['eventNotes'])) {
    objectResetSet(ui, 'error', 'Complete the form.')
    return
  }
  objectResetSet(ui, 'busy', true)
  const response = await dataSend('assets/evaluation', {
    ...form,
    registeredAssetId: asset.value.asset_id,
    eventStationId:    eventStation.value,
  })
  if (response.status === 200) {
    objectReset(form)
    objectResetSet(ui, 'success', 'Evaluation submitted successfully.')
  } else {
    objectResetSet(ui, 'error', response.data)
  }
}

onMounted(() => {
  dataFetchToCache('meta/evaluation_types')
})
</script>

<template>
  <div class="flex min-h-0 flex-1 flex-col gap-3">
    <h2 class="text-base font-semibold text-[#384884]">Evaluate Asset</h2>

    <section class="flex w-full sm:w-1/2 flex-col gap-4 self-start rounded-md border border-[#c5cce3] bg-white p-4">
      <h3 class="text-sm font-semibold uppercase tracking-wide text-[#384884]">
        {{ asset.asset_type }} — {{ asset.brand }} {{ asset.model }}
        <span class="ml-2 text-xs font-normal text-surface-500">{{ asset.asset_number ?? asset.serial_number }}</span>
      </h3>

      <div class="flex flex-col gap-4">
        <div class="flex gap-4">
          <div class="flex flex-1 flex-col gap-1.5">
            <label class="text-sm font-medium text-[#384884]">Evaluation Type</label>
            <Select
              v-model="form.evaluationTypeId"
              :options="evaluationTypes"
              option-label="name"
              option-value="id"
              placeholder="Select type"
              filter
              class="w-full"
            />
          </div>

          <div class="flex flex-1 flex-col gap-1.5">
            <label class="text-sm font-medium text-[#384884]">Evaluated Value</label>
            <InputNumber
              v-model="form.evaluatedValue"
              mode="decimal"
              :min-fraction-digits="2"
              :max-fraction-digits="2"
              :min="0.01"
              placeholder="0.00"
              class="w-full"
            />
          </div>
        </div>

        <div class="flex flex-col gap-1.5">
          <label class="text-sm font-medium text-[#384884]">Notes</label>
          <Textarea v-model="form.eventNotes" rows="2" auto-resize placeholder="Optional notes" class="w-full" />
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
          <span>Submit Evaluation</span>
        </button>
      </div>
    </section>

    <div class="flex h-14 shrink-0 items-center border-t border-[#c5cce3] px-3">
      <FeedBack :ui="ui" />
    </div>
  </div>
</template>
