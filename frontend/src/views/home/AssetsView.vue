<script setup>
import { computed, reactive, watch, onMounted } from 'vue'
import { Column, DataTable, Tag } from 'primevue'
import { arraySearch, objectHeaders, objectReset, objectSet } from '@/api/objectx'
import { exportToExcel } from '@/api/exportx'
import { dataRefreshCache, dataFromCache, dataSearchModel, dataClearSearch } from '@/api/datax'
import FormRouter from '@/commons/FormRouter.vue'

const search = dataSearchModel()

const dataKey = computed(() => 'home/assets')
const dataRecords = computed(() => dataFromCache(dataKey.value).value)
const dataRefresh = () => dataRefreshCache(dataKey.value)
const columns = computed(() => objectHeaders(dataRecords.value ?? []))
const filteredRecords = computed(() => arraySearch(dataRecords.value ?? [], search.value))

const context = reactive({
  dialog: null,
  collector: [],
  options: [
    { id: 'incidentForm', name: 'Report Incident', table: 1 },
    { id: 'assetProfile', name: 'View Asset', table: 1 },
  ],
})

const selectionMode = computed(() => Math.max(0, ...context.options.map((o) => o.table ?? 0)))

const onRowClick = (event) => {
  if (selectionMode.value) toggleCollect(event.data)
}

const collect = () => objectSet(context, 'dialog', true)

const toggleCollect = (row) => {
  const index = context.collector.findIndex((r) => r.asset_id === row.asset_id)
  if (index === -1) {
    context.collector = [row]
    collect()
  } else {
    context.collector.splice(index, 1)
  }
}

const closeRouter = () => {
  objectReset(context, ['options'])
  context.collector = []
}

const exportExcel = () => exportToExcel(filteredRecords.value, 'assets', 'Assets')

const conditionSeverity = (condition) => {
  if (!condition) return 'secondary'
  const c = condition.toLowerCase()
  if (c.includes('good') || c.includes('excellent') || c.includes('new')) return 'success'
  if (c.includes('fair') || c.includes('moderate')) return 'warn'
  if (c.includes('poor') || c.includes('bad') || c.includes('damage')) return 'danger'
  return 'secondary'
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
        <h2>Assets</h2>
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
      data-key="asset_id"
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
          <Tag
            v-if="col.field === 'condition'"
            :value="data.condition"
            :severity="conditionSeverity(data.condition)"
          />
          <span
            v-else-if="col.field === 'current_value'"
            class="font-semibold text-[#384884]"
          >{{ data.current_value }}</span>
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
