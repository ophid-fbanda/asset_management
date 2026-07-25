<script setup>
import { computed, reactive, watch, onMounted } from 'vue'
import { Column, DataTable } from 'primevue'
import { arraySearch, objectHeaders, objectReset, objectSet } from '@/api/objectx'
import { exportToExcel } from '@/api/exportx'
import { dataFetchToCache, dataFromCache, dataSearchModel, dataClearSearch } from '@/api/datax'
import FormRouter from '@/commons/FormRouter.vue'
import StatusDot from '@/commons/StatusDot.vue'

// Station the admin selected in the top bar, cached under the asset-admin role id.
const station = dataFromCache('role/20')
const search = dataSearchModel()

// Union change log for that station (load-once per station).
const dataKey = computed(() => (station.value != null ? `assets/changes/${station.value}` : null))
const dataRecords = computed(() => (dataKey.value ? dataFromCache(dataKey.value).value : null))
const dataRefresh = () => {
  if (!dataKey.value) return
  dataFetchToCache(dataKey.value)
}
const columns = computed(() => objectHeaders(dataRecords.value ?? []))

// Rows narrowed by the shared top-bar search term (full-text across values).
const filteredRecords = computed(() => arraySearch(dataRecords.value ?? [], search.value))

const TEMPLATE_MAP = {
  Transfer:     'transferTemplate',
  Issuance:     'issuanceTemplate',
  Verification: 'verificationTemplate',
  Evaluation:   'evaluationTemplate',
  Disposal:     'disposalTemplate',
}

const context = reactive({
  dialog: null,
  collector: [],
  options: [
    { id: null, name: 'Document', table: 1 },
  ],
})

// View-only: single-click opens the document template when one exists.
const selectionMode = computed(() => Math.max(0, ...context.options.map((option) => option.table ?? 0)))

const onRowClick = (event) => {
  if (selectionMode.value) toggleCollect(event.data)
}


const collect = () => objectSet(context, 'dialog', true)

// Match on event_id — entity_id alone is not unique across the union.
const toggleCollect = (row) => {
  const index = context.collector.findIndex((r) => r.event_id === row.event_id)
  if (index === -1) {
    context.collector.push(row)
    context.options[0].id = TEMPLATE_MAP[row.event_type] ?? null
    context.options[0].name = row.event_type
    if (selectionMode.value === 1) collect()
  } else {
    context.collector.splice(index, 1)
  }
}

const closeRouter = () => {
  objectReset(context, ['options'])
  context.collector = []
  context.options[0].id = null
  context.options[0].name = 'Document'
}

const exportExcel = () => {
  exportToExcel(filteredRecords.value, 'changes', 'Changes')
}

watch(dataKey, dataRefresh, { immediate: true })

onMounted(() => {
  dataClearSearch()
})
</script>

<template>
  <div class="assem-table-shell">
    <div class="assem-table-toolbar">
      <div class="flex items-baseline gap-3">
        <h2>Changes</h2>
        <span class="assem-table-meta">{{ filteredRecords.length }} records</span>
      </div>
      <div class="assem-table-actions">
        <button
          type="button"
          class="flex cursor-pointer items-center gap-2 rounded-sm border border-[#384884] bg-[#e8eefa] px-3 py-1.5 text-xs font-medium text-[#384884] transition hover:bg-[#384884] hover:text-white"
          @click="exportExcel"
        >
          <i class="pi pi-file-excel text-sm" />
          <span>Export to Excel</span>
        </button>
      </div>
    </div>

    <DataTable
      :value="filteredRecords"
      data-key="event_id"
      size="small"
      striped-rows
      scrollable
      scroll-height="flex"
      paginator
      :rows="10"
      :rows-per-page-options="[10, 25, 50]"
      :row-class="() => (selectionMode ? 'cursor-pointer' : undefined)"
      @row-click="onRowClick"
      class="assem-table flex min-h-0 flex-1 flex-col text-sm"
    >
      <Column
        v-for="col in columns"
        :key="col.field"
        :field="col.field"
        :header="col.header"
        sortable
      >
        <template #body="{ data }">
          <StatusDot
            v-if="col.field === 'status'"
            :label="data.status"
            :tone="data.status_id"
          />
          <span v-else>{{ data[col.field] }}</span>
        </template>
      </Column>
    </DataTable>

    <FormRouter
      v-if="context.dialog"
      :options="context.options"
      :collected="context.collector"
      @close="closeRouter"
    />
  </div>
</template>
