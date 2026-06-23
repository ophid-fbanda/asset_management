<script setup>
import { computed, watch, onMounted } from 'vue'
import { Column, DataTable } from 'primevue'
import { arraySearch, objectHeaders } from '@/api/objectx'
import { exportToExcel } from '@/api/exportx'
import { dataFetchToCache, dataFromCache, dataSearchModel, dataClearSearch } from '@/api/datax'

const station = dataFromCache('role/20')
const search  = dataSearchModel()

const dataKey     = computed(() => `assets/station/${station.value}`)
const dataRecords = computed(() => dataFromCache(dataKey.value).value)
const dataRefresh = () => dataFetchToCache(dataKey.value)
const columns     = computed(() => objectHeaders(dataRecords.value ?? []))

const filteredRecords = computed(() => arraySearch(dataRecords.value ?? [], search.value))

const exportExcel = () => exportToExcel(filteredRecords.value, 'station-assets', 'Station Assets')

watch(dataKey, dataRefresh, { immediate: true })

onMounted(() => {
  dataClearSearch()
})
</script>

<template>
  <div class="flex min-h-0 flex-1 flex-col gap-3">
    <div class="flex items-center justify-between gap-3">
      <div class="flex items-baseline gap-3">
        <h2 class="text-base font-semibold text-[#384884]">Station Assets</h2>
        <span class="text-xs text-surface-500">{{ filteredRecords.length }} records</span>
      </div>
      <div class="flex items-center gap-2">
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
      show-gridlines
      scrollable
      scroll-height="flex"
      paginator
      :rows="10"
      :rows-per-page-options="[10, 25, 50]"
      class="flex min-h-0 flex-1 flex-col text-sm"
    >
      <Column
        v-for="col in columns"
        :key="col.field"
        :field="col.field"
        :header="col.header"
      />
    </DataTable>
  </div>
</template>
