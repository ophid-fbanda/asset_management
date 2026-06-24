<script setup>
import { computed, reactive, watch, onMounted } from 'vue'
import { Button, Column, DataTable, Tag } from 'primevue'
import { arraySearch, objectHeaders, objectReset, objectSet } from '@/api/objectx'
import { exportToExcel } from '@/api/exportx'
import { dataRefreshCache, dataFromCache, dataSearchModel, dataClearSearch } from '@/api/datax'
import { colorPalette } from '@/api/colorx'
import FormRouter from '@/commons/FormRouter.vue'

const search = dataSearchModel()
const station = dataFromCache('role/50')

const dataKey = computed(() => `approvals/management/history/${station.value}`)
const dataRecords = computed(() => dataFromCache(dataKey.value).value)
const dataRefresh = () => dataRefreshCache(dataKey.value)
const columns = computed(() => objectHeaders(dataRecords.value ?? []))

const filteredRecords = computed(() => arraySearch(dataRecords.value ?? [], search.value))

const TEMPLATE_MAP = {
  Registration: 'regTemplate',
  Transfer:     'transferTemplate',
}

const context = reactive({
  dialog:    null,
  collector: [],
  options:   [{ id: null, name: null, table: 1 }],
})

const selectionMode = computed(() => Math.max(0, ...context.options.map((o) => o.table ?? 0)))

const collect = () => objectSet(context, 'dialog', true)

const toggleCollect = (row) => {
  const index = context.collector.findIndex((r) => r.entity_id === row.entity_id)
  if (index === -1) {
    context.collector.push(row)
    context.options[0].id   = TEMPLATE_MAP[row.event_type] ?? 'regTemplate'
    context.options[0].name = row.event_type
    if (selectionMode.value === 1) collect()
  } else {
    context.collector.splice(index, 1)
  }
}

const closeRouter = () => {
  objectReset(context, ['collector', 'options'])
  context.collector       = []
  context.options[0].id   = null
  context.options[0].name = null
}

const exportExcel = () => {
  exportToExcel(filteredRecords.value, 'approval-history', 'Approval History')
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
        <h2 class="text-base font-semibold text-[#384884]">Approval History</h2>
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
            @click="toggleCollect(data)"
          />
          <Button
            v-else
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
      >
        <template #body="{ data }">
          <Tag
            v-if="col.field === 'latest_approval'"
            :value="data.latest_approval"
            :severity="colorPalette(data.latest_approval_type_id)"
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
      :collected="context.collector"
      @close="closeRouter"
    />
  </div>
</template>
