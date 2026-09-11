<script setup>
import { computed, onMounted, reactive } from 'vue'
import { Column, DataTable, DatePicker, InputNumber, Select, Textarea } from 'primevue'
import {
  columnLookup,
  objectComplete,
  objectHeaders,
  objectReset,
  objectResetSet,
  objectSet,
} from '@/api/objectx'
import { dataFetchToCache, dataFromCache, dataSend } from '@/api/datax'
import FeedBack from '@/commons/FeedBack.vue'

defineProps({
  collected: {
    type: Array,
    default: () => [],
  },
})

const programs = dataFromCache('meta/programs')
const assetTypes = dataFromCache('meta/asset_types')
const eventStation = dataFromCache('role/20')

// Parent requisition (asset_requests). Submitted by submitForm.
const form = reactive({
  requestProgramId: null,
  eventDate: null,
  notes: null,
  eventStationId: null,
  items: null,
})

const ui = reactive({
  busy: null,
  error: null,
  success: null,
})

// Single line item (asset_request_items) plus the staged list it feeds.
const context = reactive({
  item: {
    requestedAssetTypeId: null,
    requestedQuantity: null,
  },
  items: [],
})

const stagedRows = computed(() =>
  context.items.map((item) => ({
    asset_type: columnLookup(assetTypes.value, 'id', item.requestedAssetTypeId, 'name') ?? '—',
    quantity: item.requestedQuantity,
  })),
)

const stagedColumns = computed(() => objectHeaders(stagedRows.value))

const addItem = () => {
  if (!objectComplete(context.item)) {
    objectSet(ui, 'error', 'Select an asset type and quantity.')
    return
  }

  const duplicate = context.items.find(
    (row) => row.requestedAssetTypeId === context.item.requestedAssetTypeId,
  )
  if (duplicate) {
    objectSet(ui, 'error', 'That asset type is already on the list.')
    return
  }

  context.items.push({ ...context.item })
  objectReset(context.item)
  objectSet(ui, 'error', null)
}

const removeItem = (index) => {
  context.items.splice(index, 1)
}

const toIsoDate = (value) => {
  if (!(value instanceof Date)) return value
  const pad = (n) => String(n).padStart(2, '0')
  return `${value.getFullYear()}-${pad(value.getMonth() + 1)}-${pad(value.getDate())}`
}

const submitForm = async () => {
  form.eventStationId = eventStation.value
  form.items = context.items.map((item) => ({ ...item }))

  if (!objectComplete(form, ['notes']) || !context.items.length) {
    objectResetSet(ui, 'error', 'Please complete all required fields and add at least one line item.')
    return
  }

  objectResetSet(ui, 'busy', true)

  const response = await dataSend('assets/request', {
    ...form,
    eventDate: toIsoDate(form.eventDate),
  })

  if (response.status === 200) {
    objectResetSet(ui, 'success', 'Requisition submitted successfully.')
    objectReset(form)
    context.items = []
    return
  }

  objectResetSet(ui, 'error', response.data)
}

onMounted(() => {
  dataFetchToCache('meta/programs')
  dataFetchToCache('meta/asset_types')
})
</script>

<template>
  <div class="flex min-h-0 flex-1 flex-col gap-3">
    <div class="flex items-center justify-between gap-3">
      <h2 class="text-base font-semibold text-[#384884]">New Requisition</h2>
    </div>

    <div class="flex min-h-0 flex-1 flex-col gap-4 overflow-y-auto pr-2 lg:flex-row lg:items-start">
      <section
        class="flex w-full flex-col gap-4 rounded-md border border-[#c5cce3] bg-white p-4 lg:w-2/5"
      >
        <h3 class="text-sm font-semibold tracking-wide text-[#384884] uppercase">
          Requisition Details
        </h3>

        <div class="flex flex-col gap-1.5">
          <label class="text-sm font-medium text-[#384884]">Program</label>
          <Select
            v-model="form.requestProgramId"
            :options="programs"
            option-label="program_name"
            option-value="id"
            placeholder="Select program"
            filter
            class="w-full"
          />
        </div>

        <div class="flex flex-col gap-1.5">
          <label class="text-sm font-medium text-[#384884]">Request Date</label>
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
          <Textarea
            v-model="form.notes"
            rows="3"
            auto-resize
            placeholder="Optional notes"
            class="w-full"
          />
        </div>
      </section>

      <section class="flex w-full flex-col gap-4 lg:flex-1">
        <div class="flex flex-col gap-4 rounded-md border border-[#c5cce3] bg-white p-4">
          <h3 class="text-sm font-semibold tracking-wide text-[#384884] uppercase">
            Add Line Item
          </h3>

          <div class="grid grid-cols-1 gap-4 sm:grid-cols-2">
            <div class="flex flex-col gap-1.5">
              <label class="text-sm font-medium text-[#384884]">Asset Type</label>
              <Select
                v-model="context.item.requestedAssetTypeId"
                :options="assetTypes"
                option-label="name"
                option-value="id"
                placeholder="Select asset type"
                filter
                class="w-full"
              />
            </div>

            <div class="flex flex-col gap-1.5">
              <label class="text-sm font-medium text-[#384884]">Quantity</label>
              <InputNumber
                v-model="context.item.requestedQuantity"
                :min="1"
                :step="1"
                placeholder="0"
                class="w-full"
              />
            </div>
          </div>

          <div class="flex justify-end">
            <button
              type="button"
              class="flex cursor-pointer items-center gap-2 rounded-sm border border-[#384884] bg-[#e8eefa] px-3 py-1.5 text-xs font-medium text-[#384884] transition hover:bg-[#384884] hover:text-white"
              @click="addItem"
            >
              <i class="pi pi-plus text-sm" />
              <span>Add Line Item</span>
            </button>
          </div>
        </div>

        <div class="flex flex-col gap-3 rounded-md border border-[#c5cce3] bg-white p-4">
          <div class="flex items-center justify-between gap-3">
            <h3 class="text-sm font-semibold tracking-wide text-[#384884] uppercase">
              Staged Items
            </h3>
            <span class="text-xs text-surface-500">{{ context.items.length }} added</span>
          </div>

          <div
            v-if="!context.items.length"
            class="flex items-center justify-center rounded-sm border border-dashed border-[#c5cce3] py-10 text-sm text-surface-400"
          >
            No line items added yet.
          </div>

          <DataTable v-else :value="stagedRows" size="small" striped-rows scrollable class="text-sm">
            <Column
              v-for="col in stagedColumns"
              :key="col.field"
              :field="col.field"
              :header="col.header"
            />
            <Column>
              <template #body="{ index }">
                <button
                  type="button"
                  class="cursor-pointer text-surface-400 transition hover:text-red-600"
                  aria-label="Remove line item"
                  @click="removeItem(index)"
                >
                  <i class="pi pi-times" />
                </button>
              </template>
            </Column>
          </DataTable>
        </div>

        <div class="flex justify-end">
          <button
            type="button"
            :disabled="ui.busy"
            class="flex cursor-pointer items-center gap-2 rounded-sm border border-[#384884] bg-[#e8eefa] px-3 py-1.5 text-xs font-medium text-[#384884] transition hover:bg-[#384884] hover:text-white disabled:cursor-not-allowed disabled:opacity-60 disabled:hover:bg-[#e8eefa] disabled:hover:text-[#384884]"
            @click="submitForm"
          >
            <i class="pi text-sm" :class="ui.busy ? 'pi-spinner pi-spin' : 'pi-check'" />
            <span>Save Requisition</span>
          </button>
        </div>
      </section>
    </div>

    <div class="flex h-14 shrink-0 items-center border-t border-[#c5cce3] px-3">
      <div class="w-full">
        <FeedBack :ui="ui" />
      </div>
    </div>
  </div>
</template>
