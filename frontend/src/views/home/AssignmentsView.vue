<script setup>
import { computed, reactive, watch, onMounted } from 'vue'
import { Column, DataTable } from 'primevue'
import { arraySearch, objectHeaders, objectReset, objectSet } from '@/api/objectx'
import { exportToExcel } from '@/api/exportx'
import { dataRefreshCache, dataFromCache, dataSearchModel, dataClearSearch } from '@/api/datax'
import FormRouter from '@/commons/FormRouter.vue'
import StatusDot from '@/commons/StatusDot.vue'

const search = dataSearchModel()

const dataKey = computed(() => 'home/assignments')
const dataRecords = computed(() => dataFromCache(dataKey.value).value)
const dataRefresh = () => dataRefreshCache(dataKey.value)
const columns = computed(() => objectHeaders(dataRecords.value ?? [], ['latest_approval_type_id']))
const filteredRecords = computed(() => arraySearch(dataRecords.value ?? [], search.value))

const context = reactive({
  dialog: null,
  collector: [],
  options: [
    {
      id: 'issuanceTemplate',
      name: 'Confirm assignment',
      table: 1,
      target: 50,
      choices: [10, 11],
    },
  ],
})

const selectionMode = computed(() => Math.max(0, ...context.options.map((option) => option.table ?? 0)))

const onRowClick = (event) => {
  if (selectionMode.value) toggleCollect(event.data)
}

const collect = () => objectSet(context, 'dialog', true)

const toggleCollect = (row) => {
  const index = context.collector.findIndex((r) => r.event_id === row.event_id)
  if (index === -1) {
    context.collector = [row]
    if (selectionMode.value === 1) collect()
  } else {
    context.collector.splice(index, 1)
  }
}

const closeRouter = () => {
  objectReset(context, ['options'])
  context.collector = []
  dataRefresh()
  dataRefreshCache('home/assets')
  dataRefreshCache('home/dashboard?scope=mine')
}

const exportExcel = () => exportToExcel(filteredRecords.value, 'assignments', 'Assignments')

watch(dataKey, dataRefresh, { immediate: true })

onMounted(() => {
  dataClearSearch()
})
</script>

<template>
  <div class="assem-table-shell">
    <div class="assem-table-toolbar">
      <div class="flex items-baseline gap-3">
        <h2>Assignments</h2>
        <span class="assem-table-meta">{{ filteredRecords.length }} awaiting confirmation</span>
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
            :tone="data.latest_approval_type_id"
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
