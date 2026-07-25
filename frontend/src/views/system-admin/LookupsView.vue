<script setup>
import { computed, onMounted, reactive, watch } from 'vue'
import { Column, DataTable, Dialog, InputNumber, InputText, Select } from 'primevue'
import { objectHeaders, objectSet } from '@/api/objectx'
import {
  dataClearCache,
  dataFetchToCache,
  dataFromCache,
  dataRefreshCache,
  dataSend,
} from '@/api/datax'

const ui = reactive({
  tableKey: null,
  dialog: false,
  editing: false,
  deleteOpen: false,
  busy: null,
  error: null,
})

const form = reactive({})
const pendingDelete = reactive({ row: null })

const catalog = computed(() => dataFromCache('system/lookups').value ?? [])
const selected = computed(() => catalog.value.find((item) => item.key === ui.tableKey) ?? null)

const rowsKey = computed(() => (ui.tableKey ? `system/lookups/${ui.tableKey}` : null))
const rows = computed(() => (rowsKey.value ? (dataFromCache(rowsKey.value).value ?? []) : []))
const columns = computed(() => objectHeaders(rows.value))

const lookupOptions = (field) => {
  if (!field?.lookup) return []
  // asset_brands need joined labels from the system list (meta rows are only ids).
  if (field.lookup === 'asset_brands') {
    return (dataFromCache('system/lookups/asset_brands').value ?? []).map((row) => ({
      ...row,
      label: `${row.asset_type} / ${row.brand}`,
    }))
  }
  return dataFromCache(`meta/${field.lookup}`).value ?? []
}

const clearForm = () => {
  for (const key of Object.keys(form)) delete form[key]
}

const openCreate = () => {
  clearForm()
  if (selected.value?.manualId) form.id = null
  for (const field of selected.value?.fields ?? []) {
    form[field.name] = null
  }
  objectSet(ui, 'editing', false)
  objectSet(ui, 'error', null)
  objectSet(ui, 'dialog', true)
}

const openEdit = (row) => {
  clearForm()
  form.id = row.id
  for (const field of selected.value?.fields ?? []) {
    form[field.name] = row[field.name] ?? null
  }
  objectSet(ui, 'editing', true)
  objectSet(ui, 'error', null)
  objectSet(ui, 'dialog', true)
}

const refreshRows = async () => {
  if (!rowsKey.value) return
  await dataRefreshCache(rowsKey.value)
  dataClearCache(`meta/${ui.tableKey}`)
}

const submitForm = async () => {
  const table = ui.tableKey
  const editing = ui.editing
  if (!table || !selected.value) return

  // Do not objectResetSet(ui) — that nulls tableKey and breaks the URL.
  objectSet(ui, 'busy', true)
  objectSet(ui, 'error', null)

  const payload = {}
  if (editing || selected.value.manualId) payload.id = form.id
  for (const field of selected.value.fields ?? []) {
    payload[field.name] = form[field.name]
  }

  const url = editing
    ? `system/lookups/${table}/update`
    : `system/lookups/${table}/create`

  const response = await dataSend(url, payload)
  if (response.status === 200) {
    objectSet(ui, 'dialog', false)
    await refreshRows()
  } else {
    objectSet(ui, 'error', typeof response.data === 'string' ? response.data : 'Save failed.')
  }
  objectSet(ui, 'busy', null)
}

// Prefer a readable field over bare id for confirm copy.
const rowLabel = (row) => {
  if (!row) return ''
  const fields = selected.value?.fields ?? []
  for (const key of [
    'name',
    'station_name',
    'program_name',
    'supplier_name',
    'label',
    'brand',
    'model',
    'asset_type',
    'asset_brand',
    'station_code',
    'program_code',
  ]) {
    if (row[key]) return String(row[key])
  }
  // Junction rows: compose from joined display columns or field values.
  if (row.asset_type && row.brand) return `${row.asset_type} / ${row.brand}`
  if (row.asset_brand && row.model) return `${row.asset_brand} / ${row.model}`
  for (const field of fields) {
    if (field.type === 'text' && row[field.name]) return String(row[field.name])
  }
  return `${selected.value?.label ?? 'item'} #${row.id}`
}

const askDelete = (row) => {
  pendingDelete.row = row
  objectSet(ui, 'error', null)
  objectSet(ui, 'deleteOpen', true)
}

const cancelDelete = () => {
  pendingDelete.row = null
  objectSet(ui, 'deleteOpen', false)
}

const confirmDelete = async () => {
  const table = ui.tableKey
  const row = pendingDelete.row
  if (!table || !row) return

  objectSet(ui, 'busy', true)
  objectSet(ui, 'error', null)
  const response = await dataSend(`system/lookups/${table}/delete`, { id: row.id })
  if (response.status === 200) {
    cancelDelete()
    await refreshRows()
  } else {
    objectSet(ui, 'error', typeof response.data === 'string' ? response.data : 'Delete failed.')
  }
  objectSet(ui, 'busy', null)
}

watch(
  () => ui.tableKey,
  (key) => {
    if (!key) return
    dataFetchToCache(`system/lookups/${key}`)
    const def = catalog.value.find((item) => item.key === key)
    for (const field of def?.fields ?? []) {
      if (!field.lookup) continue
      if (field.lookup === 'asset_brands') dataFetchToCache('system/lookups/asset_brands')
      else dataFetchToCache(`meta/${field.lookup}`)
    }
  },
)

watch(catalog, (items) => {
  if (!ui.tableKey && items?.length) {
    ui.tableKey = items[0].key
  }
})

onMounted(() => {
  dataFetchToCache('system/lookups')
})
</script>

<template>
  <div class="flex min-h-0 flex-1 flex-col gap-4 overflow-hidden lg:flex-row">
    <aside class="flex max-h-48 shrink-0 flex-col gap-1 overflow-auto border border-[#c5cce3] bg-[#f8fafd] p-2 lg:max-h-none lg:w-56">
      <button
        v-for="item in catalog"
        :key="item.key"
        type="button"
        class="cursor-pointer px-3 py-2 text-left text-sm font-medium transition"
        :class="
          ui.tableKey === item.key
            ? 'bg-[#384884] text-white'
            : 'text-slate-700 hover:bg-white hover:text-[#384884]'
        "
        @click="objectSet(ui, 'tableKey', item.key)"
      >
        {{ item.label }}
      </button>
    </aside>

    <section class="flex min-h-0 min-w-0 flex-1 flex-col gap-3 overflow-hidden">
      <div class="flex shrink-0 flex-wrap items-baseline justify-between gap-3">
        <div class="flex items-baseline gap-3">
          <h2 class="text-lg font-semibold text-[#384884]">{{ selected?.label ?? 'Lookups' }}</h2>
          <span class="text-sm text-slate-500">{{ rows.length }} rows</span>
        </div>
        <button
          v-if="selected"
          type="button"
          class="flex cursor-pointer items-center gap-2 border border-[#384884] bg-[#384884] px-3 py-1.5 text-xs font-semibold text-white transition hover:bg-[#5b6aa1]"
          @click="openCreate"
        >
          <i class="pi pi-plus text-sm" />
          <span>Add</span>
        </button>
      </div>

      <p v-if="ui.error" class="text-sm text-red-500">{{ ui.error }}</p>

      <div class="assem-table-shell min-h-0 flex-1">
        <DataTable
          :value="rows"
          data-key="id"
          size="small"
          striped-rows
          scrollable
          scroll-height="flex"
          paginator
          :rows="15"
          :rows-per-page-options="[15, 30, 50]"
          class="assem-table flex min-h-0 flex-1 flex-col text-sm"
        >
          <Column
            v-for="col in columns"
            :key="col.field"
            :field="col.field"
            :header="col.header"
            sortable
          />
          <Column header="" :exportable="false" style="width: 8rem">
            <template #body="{ data }">
              <div class="flex gap-1">
                <button
                  type="button"
                  class="cursor-pointer border border-[#c5cce3] px-2 py-1 text-xs text-[#384884] hover:bg-[#e8eefa]"
                  @click="openEdit(data)"
                >
                  Edit
                </button>
                <button
                  type="button"
                  class="cursor-pointer border border-[#c5cce3] px-2 py-1 text-xs text-red-600 hover:bg-red-50"
                  @click="askDelete(data)"
                >
                  Delete
                </button>
              </div>
            </template>
          </Column>
          <template #empty>
            <div class="p-4 text-sm text-slate-400">No rows in this lookup.</div>
          </template>
        </DataTable>
      </div>
    </section>

    <Dialog
      v-model:visible="ui.dialog"
      modal
      :header="(ui.editing ? 'Edit' : 'Add') + ' — ' + (selected?.label ?? '')"
      :style="{ width: 'min(92vw, 28rem)' }"
      :draggable="false"
    >
      <div class="flex flex-col gap-3">
        <div v-if="selected?.manualId && !ui.editing" class="flex flex-col gap-1.5">
          <label class="text-sm font-medium text-[#384884]">Id</label>
          <InputNumber v-model="form.id" :use-grouping="false" class="w-full" />
        </div>

        <div
          v-for="field in selected?.fields ?? []"
          :key="field.name"
          class="flex flex-col gap-1.5"
        >
          <label class="text-sm font-medium text-[#384884]">{{ field.label }}</label>
          <Select
            v-if="field.type === 'lookup'"
            v-model="form[field.name]"
            :options="lookupOptions(field)"
            :option-label="field.optionLabel"
            option-value="id"
            filter
            class="w-full"
          />
          <InputNumber
            v-else-if="field.type === 'number'"
            v-model="form[field.name]"
            :use-grouping="false"
            :max-fraction-digits="8"
            class="w-full"
          />
          <InputText
            v-else
            v-model="form[field.name]"
            class="w-full"
          />
        </div>

        <div class="flex justify-end gap-2 pt-2">
          <button
            type="button"
            class="cursor-pointer border border-[#c5cce3] px-3 py-2 text-xs font-semibold text-slate-600"
            @click="objectSet(ui, 'dialog', false)"
          >
            Cancel
          </button>
          <button
            type="button"
            :disabled="!!ui.busy"
            class="cursor-pointer border border-[#384884] bg-[#384884] px-3 py-2 text-xs font-semibold text-white disabled:opacity-40"
            @click="submitForm"
          >
            {{ ui.busy ? 'Saving…' : 'Save' }}
          </button>
        </div>
        <p v-if="ui.error" class="text-xs text-red-500">{{ ui.error }}</p>
      </div>
    </Dialog>

    <Dialog
      v-model:visible="ui.deleteOpen"
      modal
      header="Confirm delete"
      :style="{ width: 'min(92vw, 24rem)' }"
      :draggable="false"
      @hide="pendingDelete.row = null"
    >
      <div class="flex flex-col gap-4">
        <p class="text-sm text-slate-600">
          Delete
          <span class="font-semibold text-[#384884]">{{ rowLabel(pendingDelete.row) }}</span>
          from {{ selected?.label ?? 'lookups' }}?
          This cannot be undone.
        </p>
        <p v-if="ui.error" class="text-xs text-red-500">{{ ui.error }}</p>
        <div class="flex justify-end gap-2">
          <button
            type="button"
            class="cursor-pointer border border-[#c5cce3] px-3 py-2 text-xs font-semibold text-slate-600"
            @click="cancelDelete"
          >
            Cancel
          </button>
          <button
            type="button"
            :disabled="!!ui.busy"
            class="cursor-pointer border border-red-600 bg-red-600 px-3 py-2 text-xs font-semibold text-white disabled:opacity-40"
            @click="confirmDelete"
          >
            {{ ui.busy ? 'Deleting…' : 'Delete' }}
          </button>
        </div>
      </div>
    </Dialog>
  </div>
</template>
