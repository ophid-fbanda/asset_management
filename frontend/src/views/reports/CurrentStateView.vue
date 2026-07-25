<script setup>
import { computed, reactive, watch } from 'vue'
import { Button, Checkbox, Column, DataTable, Select } from 'primevue'
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

// One catalog entry each — backend scopes by strongest role (50 > 20/40 > 10).
const CURRENT_REPORTS = [
  { id: 'assets', roles: [10, 20, 40, 50], label: 'All Assets' },
  { id: 'new-assets', roles: [10, 20, 40, 50], label: 'New Assets' },
  { id: 'good-assets', roles: [10, 20, 40, 50], label: 'Good Assets' },
  { id: 'fair-assets', roles: [10, 20, 40, 50], label: 'Fair Assets' },
  { id: 'poor-assets', roles: [10, 20, 40, 50], label: 'Poor Assets' },
  { id: 'damaged-assets', roles: [10, 20, 40, 50], label: 'Damaged Assets' },
]

const profile = dataFromProfile()
const search = dataSearchModel()

const ui = reactive({
  reportId: null,
  cascade: true,
  ranKey: null,
})

const userRoleIds = computed(() =>
  [...new Set((profile.value?.roles ?? []).map((role) => role.roleTypeId))],
)

const reportOptions = computed(() =>
  CURRENT_REPORTS.filter((report) =>
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

const rowsKey = computed(() => ui.ranKey)
const rows = computed(() => (rowsKey.value ? (dataFromCache(rowsKey.value).value ?? []) : []))
const columns = computed(() => objectHeaders(rows.value))
const filteredRows = computed(() => arraySearch(rows.value, search.value))

const buildRunKey = () => {
  const report = selectedReport.value
  if (!report) return null
  if (isManager.value || !hasStationRole.value) {
    return `reports/current/${report.id}`
  }
  return `reports/current/${report.id}?cascade=${ui.cascade}`
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
  const label = selectedReport.value?.label ?? 'current-state'
  exportToExcel(filteredRows.value, `report-${selectedReport.value?.id ?? 'current'}`, label)
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
        :disabled="!selectedReport"
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
        {{ selectedReport?.label ?? 'Current State Reports' }}
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
                ? 'No rows for this report.'
                : 'Choose a report and click Run Report.'
            }}
          </div>
        </template>
      </DataTable>
    </div>
  </div>
</template>
