<script setup>
import { computed, reactive, watch, onMounted } from 'vue'
import { Button, Column, DataTable, Tag } from 'primevue'
import { arraySearch, objectHeaders, objectReset, objectSet } from '@/api/objectx'
import { exportToExcel } from '@/api/exportx'
import { dataFetchToCache, dataFromCache, dataSearchModel, dataClearSearch } from '@/api/datax'
import FormRouter from '@/commons/FormRouter.vue'

const station = dataFromCache('role/20')
const search  = dataSearchModel()

const dataKey     = computed(() => (station.value != null ? `assets/station/${station.value}` : null))
const dataRecords = computed(() => (dataKey.value ? dataFromCache(dataKey.value).value : null))
const dataRefresh = () => {
  if (!dataKey.value) return
  dataFetchToCache(dataKey.value)
}
const columns     = computed(() => objectHeaders(dataRecords.value ?? []))

const filteredRecords = computed(() => arraySearch(dataRecords.value ?? [], search.value))

const context = reactive({
  dialog: null,
  external: null,
  collector: [],
  options: [
    { id: 'transferForm',     name: 'Transfer',     table: 2 },
    { id: 'issuanceForm',     name: 'Issuance',     table: 2 },
    { id: 'verificationForm', name: 'Verification', table: 1 },
    { id: 'evaluationForm',   name: 'Evaluation',   table: 1 },
    { id: 'placementForm',    name: 'Placement',    table: 1 },
    { id: 'disposalForm',     name: 'Disposal',     table: 1 },
    { id: 'assetProfile',     name: 'View Asset',   table: 1 },
  ],
})

const selectionMode = computed(() => Math.max(0, ...context.options.map((o) => o.table ?? 0)))

const onRowClick = (event) => {
  if (selectionMode.value === 1) toggleCollect(event.data)
}


const collect = () => objectSet(context, 'dialog', true)

const toggleCollect = (row) => {
  const index = context.collector.findIndex((r) => r.asset_id === row.asset_id)
  if (index === -1) {
    context.collector.push(row)
    if (selectionMode.value === 1) collect()
  } else {
    context.collector.splice(index, 1)
  }
}

const closeRouter = () => {
  objectReset(context, ['options'])
  context.collector = []
}

const exportExcel = () => exportToExcel(filteredRecords.value, 'station-assets', 'Station Assets')

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
        <h2>Station Assets</h2>
        <span class="assem-table-meta">{{ filteredRecords.length }} records</span>
      </div>
      <div class="assem-table-actions">
        <button
          v-if="selectionMode === 2"
          type="button"
          :disabled="!context.collector.length"
          class="flex cursor-pointer items-center gap-2 rounded-sm border border-amber-500 bg-amber-500 px-3 py-1.5 text-xs font-semibold text-white shadow-sm transition hover:bg-amber-600 hover:border-amber-600 disabled:cursor-not-allowed disabled:opacity-40"
          @click="collect"
        >
          <i class="pi pi-check-square text-sm" />
          <span>Collect ({{ context.collector.length }})</span>
        </button>
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
      :row-class="() => (selectionMode === 1 ? 'cursor-pointer' : undefined)"
      @row-click="onRowClick"
      class="assem-table flex min-h-0 flex-1 flex-col text-sm"
    >
      <Column
        v-if="selectionMode === 2"
        :header-style='{ width: "2rem" }'
        :exportable="false"
      >
        <template #body="{ data }">
          <Button
            :icon="context.collector.some((r) => r.asset_id === data.asset_id) ? 'pi pi-check-square' : 'pi pi-stop'"
            severity="info"
            size="small"
            text
            @click="toggleCollect(data)"
          />
        </template>
      </Column>

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
      :external="context.external"
      :collected="context.collector"
      @close="closeRouter"
    />
  </div>
</template>
