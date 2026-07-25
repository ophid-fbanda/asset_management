<script setup>
import { computed, reactive, watch } from 'vue'
import { Button, Checkbox, Column, DataTable, DatePicker, Select } from 'primevue'
import { arraySearch, objectFirstId, objectHeaders, objectSet } from '@/api/objectx'
import { exportToExcel } from '@/api/exportx'
import {
  dataFromCache,
  dataFromProfile,
  dataRefreshCache,
  dataSearchModel,
} from '@/api/datax'

const ASSETS_ADMIN_ROLE_TYPE_ID = 20
const SUPERVISOR_ROLE_TYPE_ID = 40
const MANAGER_ROLE_TYPE_ID = 50

const PERIODIC_REPORTS = [
  { id: 'procured', roles: [10, 20, 40, 50], label: 'Assets Procured' },
  { id: 'incidents', roles: [10, 20, 40, 50], label: 'Incidents Reported' },
  { id: 'damaged', roles: [10, 20, 40, 50], label: 'Assets Damaged' },
  { id: 'disposed', roles: [10, 20, 40, 50], label: 'Assets Disposed' },
  { id: 'auctioned', roles: [10, 20, 40, 50], label: 'Assets Auctioned' },
]

const monthStart = () => {
  const d = new Date()
  return new Date(d.getFullYear(), d.getMonth(), 1)
}

const toIsoDate = (value) => {
  if (!value) return null
  const d = value instanceof Date ? value : new Date(value)
  if (Number.isNaN(d.getTime())) return null
  const y = d.getFullYear()
  const m = String(d.getMonth() + 1).padStart(2, '0')
  const day = String(d.getDate()).padStart(2, '0')
  return `${y}-${m}-${day}`
}

const profile = dataFromProfile()
const search = dataSearchModel()

const ui = reactive({
  reportId: null,
  from: monthStart(),
  to: new Date(),
  cascade: true,
  ranKey: null,
})

const userRoleIds = computed(() =>
  [...new Set((profile.value?.roles ?? []).map((role) => role.roleTypeId))],
)

const reportOptions = computed(() =>
  PERIODIC_REPORTS.filter((report) =>
    report.roles.some((roleId) => userRoleIds.value.includes(roleId)),
  ),
)

const selectedReport = computed(
  () => reportOptions.value.find((report) => report.id === ui.reportId) ?? null,
)

const isManager = computed(() => userRoleIds.value.includes(MANAGER_ROLE_TYPE_ID))
const hasStationRole = computed(() =>
  userRoleIds.value.includes(ASSETS_ADMIN_ROLE_TYPE_ID)
  || userRoleIds.value.includes(SUPERVISOR_ROLE_TYPE_ID),
)
const showCascade = computed(() => isManager.value || hasStationRole.value)
const cascadeLocked = computed(() => isManager.value)

const periodReady = computed(() => !!toIsoDate(ui.from) && !!toIsoDate(ui.to))

const rowsKey = computed(() => ui.ranKey)
const rows = computed(() => (rowsKey.value ? (dataFromCache(rowsKey.value).value ?? []) : []))
const columns = computed(() => objectHeaders(rows.value))
const filteredRows = computed(() => arraySearch(rows.value, search.value))

const buildRunKey = () => {
  const report = selectedReport.value
  const from = toIsoDate(ui.from)
  const to = toIsoDate(ui.to)
  if (!report || !from || !to) return null

  let key = `reports/periodic/${report.id}?from=${from}&to=${to}`
  if (!isManager.value && hasStationRole.value) {
    key += `&cascade=${ui.cascade}`
  }
  return key
}

watch(cascadeLocked, (locked) => {
  if (locked) ui.cascade = true
})

const runReport = () => {
  const key = buildRunKey()
  if (!key) return
  objectSet(ui, 'ranKey', key)
  dataRefreshCache(key)
}

const exportExcel = () => {
  const label = selectedReport.value?.label ?? 'periodic'
  exportToExcel(filteredRows.value, `report-${selectedReport.value?.id ?? 'periodic'}`, label)
}

watch(
  reportOptions,
  (options) => {
    if (!options.length) {
      ui.reportId = null
      return
    }
    if (!options.some((report) => report.id === ui.reportId)) {
      ui.reportId = objectFirstId(options) ?? options[0].id
    }
  },
  { immediate: true },
)
</script>

<template>
  <div class="flex min-h-0 flex-1 flex-col gap-4 overflow-hidden">
    <div class="flex shrink-0 flex-wrap items-end gap-3">
      <div class="flex min-w-[14rem] flex-1 flex-col gap-1.5 sm:max-w-xs">
        <label class="text-xs font-semibold tracking-wide text-[#384884] uppercase">Report</label>
        <Select
          v-model="ui.reportId"
          :options="reportOptions"
          option-label="label"
          option-value="id"
          placeholder="Select report"
          class="w-full"
        />
      </div>

      <div class="flex flex-col gap-1.5">
        <label class="text-xs font-semibold tracking-wide text-[#384884] uppercase">From</label>
        <DatePicker v-model="ui.from" date-format="dd/mm/yy" show-icon class="w-40" />
      </div>

      <div class="flex flex-col gap-1.5">
        <label class="text-xs font-semibold tracking-wide text-[#384884] uppercase">To</label>
        <DatePicker v-model="ui.to" date-format="dd/mm/yy" show-icon class="w-40" />
      </div>

      <label
        v-if="showCascade"
        class="flex items-center gap-2 pb-2 text-sm text-slate-700"
        :class="cascadeLocked ? 'opacity-60' : ''"
        :title="cascadeLocked ? 'Management is always global' : 'Include child stations'"
      >
        <Checkbox v-model="ui.cascade" binary :disabled="cascadeLocked" />
        <span>Cascade</span>
      </label>

      <Button
        type="button"
        label="Run Report"
        icon="pi pi-sync"
        size="small"
        :disabled="!selectedReport || !periodReady"
        class="w-36 shrink-0"
        @click="runReport"
      />

      <Button
        v-if="rowsKey"
        type="button"
        label="Export to Excel"
        icon="pi pi-file-excel"
        severity="secondary"
        size="small"
        class="shrink-0"
        @click="exportExcel"
      />
    </div>

    <div class="flex shrink-0 flex-wrap items-baseline gap-3">
      <h2 class="text-lg font-semibold text-[#384884]">
        {{ selectedReport?.label ?? 'Periodic Reports' }}
      </h2>
      <span v-if="rowsKey" class="text-sm text-slate-500">{{ filteredRows.length }} rows</span>
    </div>

    <div class="assem-table-shell min-h-0 flex-1">
      <DataTable
        :value="filteredRows"
        data-key="entity_id"
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
              rowsKey
                ? 'No rows for this period.'
                : 'Choose a report, set the period, and click Run Report.'
            }}
          </div>
        </template>
      </DataTable>
    </div>
  </div>
</template>
