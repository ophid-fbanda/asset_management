<script setup>
import { computed, onMounted, reactive, watch } from 'vue'
import { Column, DataTable } from 'primevue'
import { arraySearch, objectHeaders, objectSet } from '@/api/objectx'
import { exportToExcel } from '@/api/exportx'
import {
  dataFetchToCache,
  dataFromCache,
  dataRefreshCache,
  dataSearchModel,
  dataClearSearch,
} from '@/api/datax'

const ROLE_TYPE_ID = 60

const ui = reactive({
  auditKey: null,
})

const search = dataSearchModel()
const station = dataFromCache(`role/${ROLE_TYPE_ID}`)

const catalog = computed(() => dataFromCache('audit/catalog').value ?? [])
const selected = computed(() => catalog.value.find((item) => item.key === ui.auditKey) ?? null)

const rowsKey = computed(() => {
  if (!ui.auditKey || !station.value) return null
  return `audit/${ui.auditKey}/${station.value}`
})
const rows = computed(() => (rowsKey.value ? (dataFromCache(rowsKey.value).value ?? []) : []))
const columns = computed(() => objectHeaders(rows.value))
const filteredRows = computed(() => arraySearch(rows.value, search.value))
const rowKey = computed(() => (ui.auditKey === 'delays' ? 'event_id' : 'entity_id'))

const exportExcel = () => {
  if (!selected.value) return
  exportToExcel(filteredRows.value, `audit-${selected.value.key}`, selected.value.label)
}

const refreshRows = () => {
  if (!rowsKey.value) return
  dataRefreshCache(rowsKey.value)
}

watch(rowsKey, (key) => {
  if (!key) return
  dataFetchToCache(key)
}, { immediate: true })

watch(catalog, (items) => {
  if (!ui.auditKey && items?.length) {
    ui.auditKey = items[0].key
  }
})

onMounted(() => {
  dataClearSearch()
  dataFetchToCache('audit/catalog')
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
          ui.auditKey === item.key
            ? 'bg-[#384884] text-white'
            : 'text-slate-700 hover:bg-white hover:text-[#384884]'
        "
        @click="objectSet(ui, 'auditKey', item.key)"
      >
        {{ item.label }}
      </button>
    </aside>

    <section class="flex min-h-0 min-w-0 flex-1 flex-col gap-3 overflow-hidden">
      <div class="flex shrink-0 flex-wrap items-start justify-between gap-3">
        <div class="min-w-0 flex-1">
          <div class="flex flex-wrap items-baseline gap-3">
            <h2 class="text-lg font-semibold text-[#384884]">{{ selected?.label ?? 'Audits' }}</h2>
            <span class="text-sm text-slate-500">{{ filteredRows.length }} rows</span>
          </div>
          <p v-if="selected?.description" class="mt-1 text-sm text-slate-500">
            {{ selected.description }}
          </p>
        </div>
        <div class="flex shrink-0 flex-wrap gap-2">
          <button
            v-if="selected && station"
            type="button"
            class="flex cursor-pointer items-center gap-2 border border-[#c5cce3] bg-white px-3 py-1.5 text-xs font-semibold text-[#384884] transition hover:bg-[#e8eefa]"
            @click="refreshRows"
          >
            <i class="pi pi-refresh text-sm" />
            <span>Refresh</span>
          </button>
          <button
            v-if="selected"
            type="button"
            class="flex cursor-pointer items-center gap-2 border border-[#384884] bg-[#e8eefa] px-3 py-1.5 text-xs font-medium text-[#384884] transition hover:bg-[#384884] hover:text-white"
            @click="exportExcel"
          >
            <i class="pi pi-file-excel text-sm" />
            <span>Export to Excel</span>
          </button>
        </div>
      </div>

      <div class="assem-table-shell min-h-0 flex-1">
        <DataTable
          :value="filteredRows"
          :data-key="rowKey"
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
          <template #empty>
            <div class="p-4 text-sm text-slate-400">
              {{
                !station
                  ? 'Select a station to run audits.'
                  : selected
                    ? 'No findings for this audit.'
                    : 'Select an audit.'
              }}
            </div>
          </template>
        </DataTable>
      </div>
    </section>
  </div>
</template>
