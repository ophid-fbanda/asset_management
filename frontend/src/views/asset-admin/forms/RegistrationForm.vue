<script setup>
import { computed, onMounted, reactive } from 'vue'
import { Checkbox, Column, DataTable, DatePicker, InputNumber, InputText, Select, Textarea } from 'primevue'
import {
  arrayFilter,
  columnLookup,
  objectComplete,
  objectHeaders,
  objectReset,
  objectResetSet,
} from '@/api/objectx'
import { dataFetchToCache, dataFromCache, dataUnique, dataUpload } from '@/api/datax'
import Feedback from '@/commons/Feedback.vue'

defineProps({
  collected: {
    type: Array,
    default: () => [],
  },
})

// Meta lookups this form needs. Loaded on mount (load-once via the shared cache).
const meta = [
  'programs',
  'acquisition_types',
  'reference_types',
  'suppliers',
  'asset_types',
  'brand_types',
  'model_types',
  'condition_types',
  'asset_brands',
  'asset_models',
]

// Lookup option lists, each read straight from the shared cache.
// The asset model is chosen by narrowing: asset_type -> (asset_brands) -> (asset_models).
const programs = dataFromCache('meta/programs')
const acquisitionTypes = dataFromCache('meta/acquisition_types')
const referenceTypes = dataFromCache('meta/reference_types')
const suppliers = dataFromCache('meta/suppliers')
const assetTypes = dataFromCache('meta/asset_types')
const brandTypes = dataFromCache('meta/brand_types')
const assetBrands = dataFromCache('meta/asset_brands')
const modelTypes = dataFromCache('meta/model_types')
const assetModels = dataFromCache('meta/asset_models')
const conditionTypes = dataFromCache('meta/condition_types')

// Station the admin selected in the top bar, cached under the asset-admin role id.
const eventStation = dataFromCache('role/20')

// Parent registration (asset_registrations). Submitted by submitForm.
const form = reactive({
  programId: null,
  acquisitionTypeId: null,
  referenceAttachment: null,
  referenceTypeId: null,
  referenceDate: null,
  supplierName: null,
  notes: null,
  // Not shown in the UI; resolved elsewhere before submit.
  eventStationId: null,
  // Serialized JSON of the staged assets; filled in submitForm.
  assets: null,
})

// Page state.
const ui = reactive({
  busy: null,
  error: null,
})

// Single-asset entry (registered_assets) plus the staged list it feeds.
// assetTypeId and assetBrandId only narrow the model picker; assetModelId is what registers.
const context = reactive({
  asset: {
    assetTypeId: null,
    assetBrandId: null,
    assetModelId: null,
    serialNumber: null,
    noSerial: false,
    conditionTypeId: null,
    acquisitionValue: null,
  },
  assets: [],
})

// asset_brands narrowed to the chosen asset type, labelled from brand_types.
const brandOptions = computed(() =>
  arrayFilter(assetBrands.value, 'asset_type_id', [context.asset.assetTypeId]).map((brand) => ({
    id: brand.id,
    name: columnLookup(brandTypes.value, 'id', brand.brand_type_id, 'name'),
  })),
)

// asset_models narrowed to the chosen asset brand, labelled from model_types.
const modelOptions = computed(() =>
  arrayFilter(assetModels.value, 'asset_brand_id', [context.asset.assetBrandId]).map((model) => ({
    id: model.id,
    name: columnLookup(modelTypes.value, 'id', model.model_type_id, 'name'),
  })),
)

// Display-ready view of the staged assets (raw ids resolved to names) for the table.
const stagedRows = computed(() =>
  context.assets.map((asset) => {
    const brandTypeId = columnLookup(assetBrands.value, 'id', asset.assetBrandId, 'brand_type_id')
    const modelTypeId = columnLookup(assetModels.value, 'id', asset.assetModelId, 'model_type_id')
    return {
      asset_type: columnLookup(assetTypes.value, 'id', asset.assetTypeId, 'name') ?? '—',
      brand: columnLookup(brandTypes.value, 'id', brandTypeId, 'name') ?? '—',
      asset_model: columnLookup(modelTypes.value, 'id', modelTypeId, 'name') ?? '—',
      serial_number: asset.serialNumber ?? '—',
      condition: columnLookup(conditionTypes.value, 'id', asset.conditionTypeId, 'name') ?? '—',
      acquisition_value: asset.acquisitionValue ?? '—',
    }
  }),
)

const stagedColumns = computed(() => objectHeaders(stagedRows.value))

const onAssetTypeChange = () => {
  context.asset.assetBrandId = null
  context.asset.assetModelId = null
}

const onBrandChange = () => {
  context.asset.assetModelId = null
}

const addAsset = () => {
  const asset = { ...context.asset }
  if (asset.noSerial) asset.serialNumber = dataUnique('SGSN')
  context.assets.push(asset)
  objectReset(context.asset)
}

const removeAsset = (index) => {
  context.assets.splice(index, 1)
}

const onFileChange = (event) => {
  form.referenceAttachment = event.target.files?.[0] ?? null
}

// DatePicker binds a Date; the API expects yyyy-MM-dd.
const toIsoDate = (value) => {
  if (!(value instanceof Date)) return value
  const pad = (n) => String(n).padStart(2, '0')
  return `${value.getFullYear()}-${pad(value.getMonth() + 1)}-${pad(value.getDate())}`
}

const submitForm = async () => {
  form.eventStationId = eventStation.value
  form.assets = JSON.stringify(context.assets)

  if (!objectComplete(form)) {
    objectResetSet(ui, 'error', 'Please complete all required fields.')
    return
  }

  objectResetSet(ui, 'busy', true)

  const payload = { ...form, referenceDate: toIsoDate(form.referenceDate) }
  const response = await dataUpload('assets/registration', payload)

  if (response.status === 200) {
    objectResetSet(ui, 'success', 'Registration submitted successfully.')
    objectReset(form)
    context.assets = []
    return
  }

  objectResetSet(ui, 'error', response.data)
}

onMounted(() => {
  meta.forEach((table) => dataFetchToCache(`meta/${table}`))
})
</script>

<template>
  <div class="flex min-h-0 flex-1 flex-col gap-3">
    <div class="flex items-center justify-between gap-3">
      <h2 class="text-base font-semibold text-[#384884]">New Registration</h2>
    </div>

    <div class="flex min-h-0 flex-1 flex-col gap-4 overflow-y-auto pr-2 lg:flex-row lg:items-start">
      <!-- LEFT: parent registration information -->
      <section
        class="flex w-full flex-col gap-4 rounded-md border border-[#c5cce3] bg-white p-4 lg:w-2/5"
      >
        <h3 class="text-sm font-semibold tracking-wide text-[#384884] uppercase">
          Registration Details
        </h3>

        <div class="flex flex-col gap-1.5">
          <label class="text-sm font-medium text-[#384884]">Program</label>
          <Select
            v-model="form.programId"
                :options="programs"
            option-label="program_name"
            option-value="id"
            placeholder="Select program"
            filter
            class="w-full"
          />
        </div>

        <div class="flex flex-col gap-1.5">
          <label class="text-sm font-medium text-[#384884]">Acquisition Type</label>
          <Select
            v-model="form.acquisitionTypeId"
                :options="acquisitionTypes"
            option-label="name"
            option-value="id"
            placeholder="Select acquisition type"
            filter
            class="w-full"
          />
        </div>

        <div class="flex flex-col gap-1.5">
          <label class="text-sm font-medium text-[#384884]">Reference Type</label>
          <Select
            v-model="form.referenceTypeId"
                :options="referenceTypes"
            option-label="name"
            option-value="id"
            placeholder="Select reference type"
            filter
            class="w-full"
          />
        </div>

        <div class="flex flex-col gap-1.5">
          <label class="text-sm font-medium text-[#384884]">Reference Date</label>
          <DatePicker
            v-model="form.referenceDate"
            date-format="yy-mm-dd"
            show-icon
            placeholder="Select date"
            class="w-full"
          />
        </div>

        <div class="flex flex-col gap-1.5">
          <label class="text-sm font-medium text-[#384884]">Reference Attachment</label>
          <input
            type="file"
            class="block w-full cursor-pointer rounded-sm border border-[#c5cce3] bg-[#e8eefa] text-sm text-[#384884] file:mr-3 file:cursor-pointer file:border-0 file:bg-[#384884] file:px-3 file:py-2 file:text-white hover:file:bg-[#5b6aa1]"
            @change="onFileChange"
          />
        </div>

        <div class="flex flex-col gap-1.5">
          <label class="text-sm font-medium text-[#384884]">Supplier</label>
          <Select
            v-model="form.supplierName"
                :options="suppliers"
            option-label="supplier_name"
            option-value="supplier_name"
            editable
            filter
            placeholder="Select or type a supplier"
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

      <!-- RIGHT: single asset entry + staged list -->
      <section class="flex w-full flex-col gap-4 lg:flex-1">
        <div class="flex flex-col gap-4 rounded-md border border-[#c5cce3] bg-white p-4">
          <h3 class="text-sm font-semibold tracking-wide text-[#384884] uppercase">
            Add Asset
          </h3>

          <div class="grid grid-cols-1 gap-4 sm:grid-cols-2 lg:grid-cols-3">
            <div class="flex flex-col gap-1.5">
              <label class="text-sm font-medium text-[#384884]">Asset Type</label>
              <Select
                v-model="context.asset.assetTypeId"
                :options="assetTypes"
                option-label="name"
                option-value="id"
                placeholder="Select asset type"
                filter
                class="w-full"
                @change="onAssetTypeChange"
              />
            </div>

            <div class="flex flex-col gap-1.5">
              <label class="text-sm font-medium text-[#384884]">Brand</label>
              <Select
                v-model="context.asset.assetBrandId"
                :options="brandOptions"
                option-label="name"
                option-value="id"
                placeholder="Select brand"
                filter
                class="w-full"
                :disabled="!context.asset.assetTypeId"
                @change="onBrandChange"
              />
            </div>

            <div class="flex flex-col gap-1.5">
              <label class="text-sm font-medium text-[#384884]">Asset Model</label>
              <Select
                v-model="context.asset.assetModelId"
                :options="modelOptions"
                option-label="name"
                option-value="id"
                placeholder="Select model"
                filter
                class="w-full"
                :disabled="!context.asset.assetBrandId"
              />
            </div>

            <div class="flex flex-col gap-1.5">
              <label class="text-sm font-medium text-[#384884]">Condition</label>
              <Select
                v-model="context.asset.conditionTypeId"
                :options="conditionTypes"
                option-label="name"
                option-value="id"
                placeholder="Select condition"
                filter
                class="w-full"
              />
            </div>

            <div class="flex flex-col gap-1.5">
              <label class="text-sm font-medium text-[#384884]">Acquisition Value</label>
              <InputNumber
                v-model="context.asset.acquisitionValue"
                mode="currency"
                currency="USD"
                :min="0"
                placeholder="0.00"
                class="w-full"
              />
            </div>

            <div class="flex flex-col gap-1.5">
              <label class="text-sm font-medium text-[#384884]">Serial Number</label>
              <InputText
                v-model="context.asset.serialNumber"
                :placeholder="context.asset.noSerial ? 'Auto-generated (SGSN…)' : 'Enter serial number'"
                :disabled="context.asset.noSerial"
                class="w-full"
              />
            </div>
          </div>

          <div class="flex items-center justify-between gap-3">
            <label class="flex cursor-pointer items-center gap-2 text-sm font-medium text-[#384884]">
              <Checkbox v-model="context.asset.noSerial" binary />
              <span>No serial number</span>
            </label>

            <button
              type="button"
              class="flex cursor-pointer items-center gap-2 rounded-sm border border-[#384884] bg-[#e8eefa] px-3 py-1.5 text-xs font-medium text-[#384884] transition hover:bg-[#384884] hover:text-white"
              @click="addAsset"
            >
              <i class="pi pi-plus text-sm" />
              <span>Add Asset</span>
            </button>
          </div>
        </div>

        <div class="flex flex-col gap-3 rounded-md border border-[#c5cce3] bg-white p-4">
          <div class="flex items-center justify-between gap-3">
            <h3 class="text-sm font-semibold tracking-wide text-[#384884] uppercase">
              Staged Assets
            </h3>
            <span class="text-xs text-surface-500">{{ context.assets.length }} added</span>
          </div>

          <div
            v-if="!context.assets.length"
            class="flex items-center justify-center rounded-sm border border-dashed border-[#c5cce3] py-10 text-sm text-surface-400"
          >
            No assets added yet.
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
                  aria-label="Remove asset"
                  @click="removeAsset(index)"
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
            <span>Save Registration</span>
          </button>
        </div>
      </section>
    </div>

    <div class="flex h-14 shrink-0 items-center border-t border-[#c5cce3] px-3">
      <div class="w-full">
        <Feedback :ui="ui" />
      </div>
    </div>
  </div>
</template>
