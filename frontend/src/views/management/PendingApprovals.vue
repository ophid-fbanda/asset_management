<script setup>
import { computed, reactive, watch, onMounted } from 'vue'
import { Button, Column, DataTable, Tag } from 'primevue'
import { arraySearch, objectHeaders, objectReset, objectSet } from '@/api/objectx'
import { exportToExcel } from '@/api/exportx'
import { dataFetchToCache, dataFromCache, dataSearchModel, dataClearSearch } from '@/api/datax'
import { colorPalette } from '@/api/colorx'
import FormRouter from '@/commons/FormRouter.vue'

const search = dataSearchModel()
const stationSupervisory = dataFromCache('role/40')
const stationManagement = dataFromCache('role/50')

// role 40 (supervisory) takes precedence — if present, use it; else fall back to role 50 (management)
const dataKey = computed(() => {
  if (stationSupervisory.value) return `approvals/supervisory/${stationSupervisory.value}`
  if (stationManagement.value) return `approvals/management/${stationManagement.value}`
  return null
})
const dataRecords = computed(() => dataKey.value ? dataFromCache(dataKey.value).value : null)
const dataRefresh = () => dataKey.value && dataFetchToCache(dataKey.value)
const columns = computed(() => objectHeaders(dataRecords.value ?? []))

const filteredRecords = computed(() => arraySearch(dataRecords.value ?? [], search.value))

const context = reactive({
  dialog: null,
  external: null,
  collector: [],
  options: [
    { id: 'approvalTemplate', name: 'Approval', table: 1 },
  ],
})

const selectionMode = computed(() => Math.max(0, ...context.options.map((option) => option.table ?? 0)))

const collect = () => objectSet(context, 'dialog', true)

const toggleCollectId = (id) => {
  const index = context.collector.indexOf(id)
  if (index === -1) {
    context.collector.push(id)
    if (selectionMode.value === 1) collect()
  } else {
    context.collector.splice(index, 1)
  }
}

const closeRouter = () => {
  objectReset(context, ['options'])
  context.collector = []
}

const exportExcel = () => {
  exportToExcel(filteredRecords.value, 'pending-approvals', 'Pending Approvals')
}

watch(dataKey, dataRefresh, { immediate: true })

onMounted(() => {
  dataClearSearch()
})
</script>

<template>
  <div class="flex min-h-0 flex-1 flex-col gap-3">
    <div class="flex items-center justify-between gap-3">
      <div class="flex items-baseline gap-3">
        <h2 class="text-base font-semibold text-[#384884]">Pending Requests</h2>
        <span class="text-xs text-surface-500">{{ filteredRecords.length }} records</span>
      </div>
      <div class="flex items-center gap-2">
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
      data-key="entity_id"
      size="small"
      striped-rows
      show-gridlines
      scrollable
      scroll-height="flex"
      paginator
      :rows="10"
      :rows-per-page-options="[10, 25, 50]"
      class="flex min-h-0 flex-1 flex-col text-sm"
    >
      <Column
        v-if="selectionMode"
        :header-style='{ width: "2rem" }'
        :exportable="false"
      >
        <template #body="{ data }">
          <Button
            v-if="selectionMode === 1"
            icon="pi pi-folder"
            severity="info"
            size="small"
            text
            @click="toggleCollectId(data.entity_id)"
          />
          <Button
            v-else
            :icon="context.collector.includes(data.entity_id) ? 'pi pi-check-square' : 'pi pi-stop'"
            severity="info"
            size="small"
            text
            @click="toggleCollectId(data.entity_id)"
          />
        </template>
      </Column>
      <Column
        v-for="col in columns"
        :key="col.field"
        :field="col.field"
        :header="col.header"
      >
        <template #body="{ data }">
          <Tag
            v-if="col.field === 'status'"
            :value="data.status"
            :severity="colorPalette(data.status_id)"
          />
          <span
            v-else-if="col.field === 'quantity'"
            class="font-semibold text-[#384884]"
          >
            {{ data.quantity }}
          </span>
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
