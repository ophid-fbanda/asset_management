<script setup>
import { computed, reactive, watch, onMounted } from 'vue'
import { Button, Column, DataTable } from 'primevue'
import { arraySearch, objectHeaders, objectReset, objectSet } from '@/api/objectx'
import { exportToExcel } from '@/api/exportx'
import { dataFetchToCache, dataFromCache, dataSearchModel, dataClearSearch } from '@/api/datax'
import FormRouter from '@/commons/FormRouter.vue'
import StatusDot from '@/commons/StatusDot.vue'

// Station the admin selected in the top bar, cached under the asset-admin role id.
const station = dataFromCache('role/20')
const search = dataSearchModel()

// Live registrations list for that station, cached per-station (load-once).
const dataKey = computed(() => (station.value != null ? `assets/registrations/${station.value}` : null))
const dataRecords = computed(() => (dataKey.value ? dataFromCache(dataKey.value).value : null))
const dataRefresh = () => {
  if (!dataKey.value) return
  dataFetchToCache(dataKey.value)
}
const columns = computed(() => objectHeaders(dataRecords.value ?? []))

// Rows narrowed by the shared top-bar search term (full-text across values).
const filteredRecords = computed(() => arraySearch(dataRecords.value ?? [], search.value))

const context = reactive({
  dialog: null,
  external: null,
  collector: [],
  options: [
    { id: 'regTemplate', name: 'Registration', table: 1 }
  ]
})

// What the table is allowed to do, taken straight off the options:
// 2 = checkbox multi-select, 1 = single click, 0 = read-only.
const selectionMode = computed(() => Math.max(0, ...context.options.map((option) => option.table ?? 0)))

const onRowClick = (event) => {
  if (selectionMode.value === 1) toggleCollect(event.data)
}


// Open the router dialog with the collected ids riding along the options.
const collect = () => objectSet(context, 'dialog', true)

// New Registration bypasses the selection options entirely: it names the form
// to mount via `external` and launches the dialog.
const newRegistration = () => {
  objectSet(context, 'external', 'regForm')
  objectSet(context, 'dialog', true)
}

// Toggle one row in/out of the collector. In single mode, adding fires Collect.
const toggleCollect = (row) => {
  const index = context.collector.findIndex((r) => r.entity_id === row.entity_id)
  if (index === -1) {
    context.collector.push(row)
    if (selectionMode.value === 1) collect()
  } else {
    context.collector.splice(index, 1)
  }
}

// Tear down the dialog and empty the collector.
const closeRouter = () => {
  objectReset(context, ['options'])
  context.collector = []
}

const exportExcel = () => {
  exportToExcel(filteredRecords.value, 'registrations', 'Registrations')
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
        <h2>Registrations</h2>
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
        <button
          type="button"
          class="flex cursor-pointer items-center gap-2 rounded-sm border border-[#384884] bg-[#384884] px-3 py-1.5 text-xs font-medium text-white transition hover:bg-[#5b6aa1] hover:border-[#5b6aa1]"
          @click="newRegistration"
        >
          <i class="pi pi-plus text-sm" />
          <span>New Registration</span>
        </button>
      </div>
    </div>

    <DataTable
      :value="filteredRecords"
      data-key="entity_id"
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
            :icon="context.collector.some((r) => r.entity_id === data.entity_id) ? 'pi pi-check-square' : 'pi pi-stop'"
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
          <StatusDot
            v-if="col.field === 'status'"
            :label="data.status"
            :tone="data.status_id"
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
