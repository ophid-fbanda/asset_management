<script setup>
import { computed, reactive, watch, onMounted } from 'vue'
import { Button, Column, DataTable, Tag } from 'primevue'
import { arraySearch, objectHeaders, objectReset, objectSet } from '@/api/objectx'
import { exportToExcel } from '@/api/exportx'
import { dataFetchToCache, dataFromCache, dataSearchModel, dataClearSearch } from '@/api/datax'
import { colorPalette } from '@/api/colorx'
import FormRouter from '@/commons/FormRouter.vue'

// Station the admin selected in the top bar, cached under the asset-admin role id.
const station = dataFromCache('role/20')
const search = dataSearchModel()

// Live registrations list for that station, cached per-station (load-once).
const dataKey = computed(() => `assets/registrations/${station.value}`)
const dataRecords = computed(() => dataFromCache(dataKey.value).value)
const dataRefresh = () => dataFetchToCache(dataKey.value)
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

// Open the router dialog with the collected ids riding along the options.
const collect = () => objectSet(context, 'dialog', true)

// New Registration bypasses the selection options entirely: it names the form
// to mount via `external` and launches the dialog.
const newRegistration = () => {
  objectSet(context, 'external', 'regForm')
  objectSet(context, 'dialog', true)
}

// Toggle one id in/out of the collector. In single mode, adding fires Collect.
const toggleCollectId = (id) => {
  const index = context.collector.indexOf(id)
  if (index === -1) {
    context.collector.push(id)
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
  <div class="flex min-h-0 flex-1 flex-col gap-3">
    <div class="flex items-center justify-between gap-3">
      <div class="flex items-baseline gap-3">
        <h2 class="text-base font-semibold text-[#384884]">Registrations</h2>
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
