<script setup>
import { computed, reactive, watch } from 'vue'
import { Column, DataTable, Select } from 'primevue'
import { arrayFilter, objectHeaders, objectFirstId } from '@/api/objectx'
import { dataRefreshCache, dataFromCache, dataFromProfile } from '@/api/datax'

const ADMIN_ROLE_TYPE_ID = 20
const SUPERVISORY_ROLE_TYPE_ID = 40
const MANAGEMENT_ROLE_TYPE_ID = 50

const profile = dataFromProfile()

const ui = reactive({
  scopeId: 'mine',
})

// Options the signed-in profile may snapshot: custody first, then each
// admin / supervisor / manager station binding.
const scopeOptions = computed(() => {
  const options = [{ id: 'mine', label: 'My assets' }]
  const roles = profile.value?.roles ?? []

  for (const role of arrayFilter(roles, 'roleTypeId', [ADMIN_ROLE_TYPE_ID])) {
    options.push({
      id: `station-${ADMIN_ROLE_TYPE_ID}-${role.stationId}`,
      label: `Admin — ${role.stationName}`,
      scope: 'station',
      stationId: role.stationId,
      roleTypeId: ADMIN_ROLE_TYPE_ID,
    })
  }
  for (const role of arrayFilter(roles, 'roleTypeId', [SUPERVISORY_ROLE_TYPE_ID])) {
    options.push({
      id: `station-${SUPERVISORY_ROLE_TYPE_ID}-${role.stationId}`,
      label: `Supervisory — ${role.stationName}`,
      scope: 'station',
      stationId: role.stationId,
      roleTypeId: SUPERVISORY_ROLE_TYPE_ID,
    })
  }
  for (const role of arrayFilter(roles, 'roleTypeId', [MANAGEMENT_ROLE_TYPE_ID])) {
    options.push({
      id: `station-${MANAGEMENT_ROLE_TYPE_ID}-${role.stationId}`,
      label: `Organisation — ${role.stationName}`,
      scope: 'station',
      stationId: role.stationId,
      roleTypeId: MANAGEMENT_ROLE_TYPE_ID,
    })
  }
  return options
})

const selectedScope = computed(() =>
  scopeOptions.value.find((option) => option.id === ui.scopeId) ?? scopeOptions.value[0],
)

const dataKey = computed(() => {
  const scope = selectedScope.value
  if (!scope || scope.id === 'mine') return 'home/dashboard?scope=mine'
  return `home/dashboard?scope=station&stationId=${scope.stationId}&roleTypeId=${scope.roleTypeId}`
})

const dashboard = computed(() => dataFromCache(dataKey.value).value ?? {})
const summary = computed(() => dashboard.value.summary ?? {})

const panels = computed(() => [
  {
    id: 'by_type',
    title: 'By type',
    rows: dashboard.value.by_type ?? [],
  },
  {
    id: 'by_station',
    title: 'By station',
    rows: dashboard.value.by_station ?? [],
  },
  {
    id: 'by_condition',
    title: 'By condition',
    rows: dashboard.value.by_condition ?? [],
  },
  {
    id: 'by_type_condition',
    title: 'By type and condition',
    rows: dashboard.value.by_type_condition ?? [],
  },
])

const cards = computed(() => [
  {
    id: 'total',
    label: 'Total assets',
    value: summary.value.total_assets ?? 0,
    hint: 'Active inventory in this scope',
  },
  {
    id: 'value',
    label: 'Total value',
    value: summary.value.total_value ?? 0,
    hint: 'Sum of current values (active)',
  },
  {
    id: 'damaged',
    label: 'Damaged',
    value: summary.value.damaged_assets ?? 0,
    hint: 'Active assets in damaged condition',
    accent: true,
  },
])

const formatValue = (card) => {
  if (card.id === 'value') {
    return Number(card.value).toLocaleString(undefined, {
      minimumFractionDigits: 2,
      maximumFractionDigits: 2,
    })
  }
  return Number(card.value).toLocaleString()
}

const dataRefresh = () => dataRefreshCache(dataKey.value)

watch(scopeOptions, (options) => {
  if (!options.some((option) => option.id === ui.scopeId)) {
    ui.scopeId = objectFirstId(options) ?? 'mine'
  }
}, { immediate: true })

watch(dataKey, dataRefresh, { immediate: true })
</script>

<template>
  <div class="dash flex min-h-0 flex-1 flex-col gap-6 overflow-y-auto overscroll-contain pb-4">
    <div class="flex shrink-0 flex-wrap items-end justify-between gap-4">
      <div>
        <h2 class="text-xl font-semibold tracking-tight text-[#384884]">
          Welcome{{ profile?.name ? `, ${profile.name}` : '' }}
        </h2>
        <p class="mt-1 text-sm text-slate-500">
          Asset snapshot for the selected scope.
        </p>
      </div>
      <Select
        v-if="scopeOptions.length > 1"
        v-model="ui.scopeId"
        :options="scopeOptions"
        option-label="label"
        option-value="id"
        placeholder="Scope"
        size="small"
        class="w-64"
      />
    </div>

    <div class="dash-kpis shrink-0">
      <div
        v-for="card in cards"
        :key="card.id"
        class="dash-kpi"
        :class="{ 'dash-kpi--accent': card.accent }"
      >
        <p class="dash-kpi__label">{{ card.label }}</p>
        <p class="dash-kpi__value">{{ formatValue(card) }}</p>
        <p class="dash-kpi__hint">{{ card.hint }}</p>
      </div>
    </div>

    <div class="dash-grid shrink-0">
      <section
        v-for="panel in panels"
        :key="panel.id"
        class="dash-panel"
      >
        <div class="dash-panel__head">
          <h2>{{ panel.title }}</h2>
          <span>{{ panel.rows.length }} groups</span>
        </div>

        <DataTable
          :value="panel.rows"
          size="small"
          striped-rows
          paginator
          :rows="8"
          :rows-per-page-options="[8, 15, 30]"
          paginator-template="FirstPageLink PrevPageLink PageLinks NextPageLink LastPageLink RowsPerPageDropdown CurrentPageReport"
          current-page-report-template="{first}–{last} of {totalRecords}"
          class="dash-table text-sm"
        >
          <Column
            v-for="col in objectHeaders(panel.rows)"
            :key="col.field"
            :field="col.field"
            :header="col.header"
            sortable
          />
          <template #empty>
            <div class="dash-table__empty">No assets in this scope.</div>
          </template>
        </DataTable>
      </section>
    </div>
  </div>
</template>

<style scoped>
.dash-kpis {
  display: grid;
  gap: 1rem;
  grid-template-columns: repeat(1, minmax(0, 1fr));
}

@media (min-width: 640px) {
  .dash-kpis {
    grid-template-columns: repeat(3, minmax(0, 1fr));
  }
}

.dash-kpi {
  padding: 1.15rem 1.25rem 1.25rem;
  border: 1px solid #d5dceb;
  border-top: 3px solid #384884;
  border-radius: 0.5rem;
  background: linear-gradient(165deg, #eef1f8 0%, #ffffff 48%);
  box-shadow: 0 1px 2px rgb(56 72 132 / 6%);
}

.dash-kpi--accent {
  border-top-color: #b45309;
  background: linear-gradient(165deg, #fff7ed 0%, #ffffff 48%);
}

.dash-kpi__label {
  margin: 0;
  font-size: 0.7rem;
  font-weight: 700;
  letter-spacing: 0.08em;
  text-transform: uppercase;
  color: #5b6aa1;
}

.dash-kpi--accent .dash-kpi__label {
  color: #92400e;
}

.dash-kpi__value {
  margin: 0.55rem 0 0;
  font-size: 1.85rem;
  font-weight: 700;
  letter-spacing: -0.02em;
  line-height: 1.1;
  color: #384884;
}

.dash-kpi--accent .dash-kpi__value {
  color: #9a3412;
}

.dash-kpi__hint {
  margin: 0.45rem 0 0;
  font-size: 0.75rem;
  color: #64748b;
}

.dash-grid {
  display: grid;
  gap: 1rem;
  grid-template-columns: 1fr;
}

@media (min-width: 1024px) {
  .dash-grid {
    grid-template-columns: 1fr 1fr;
  }
}

.dash-panel {
  display: flex;
  min-height: 0;
  flex-direction: column;
  overflow: hidden;
  border: 1px solid #d5dceb;
  border-radius: 0.5rem;
  background: #fff;
  box-shadow: 0 1px 3px rgb(56 72 132 / 7%);
}

.dash-panel__head {
  display: flex;
  align-items: baseline;
  justify-content: space-between;
  gap: 0.75rem;
  padding: 0.85rem 1.15rem;
  border-bottom: 1px solid #e4e9f4;
  background: linear-gradient(180deg, #f3f5fb 0%, #f8fafd 100%);
}

.dash-panel__head h2 {
  margin: 0;
  font-size: 0.9rem;
  font-weight: 700;
  color: #384884;
}

.dash-panel__head span {
  font-size: 0.72rem;
  font-weight: 600;
  letter-spacing: 0.04em;
  text-transform: uppercase;
  color: #94a0b8;
}

.dash-panel :deep(.p-datatable) {
  border: 0;
  border-radius: 0;
  box-shadow: none;
  overflow: visible;
  background: transparent;
}

.dash-panel :deep(.p-datatable::before) {
  display: none;
}

.dash-panel :deep(.p-datatable-thead > tr > th) {
  font-size: 0.7rem;
  font-weight: 700;
  letter-spacing: 0.05em;
  text-transform: uppercase;
  border: 0 !important;
  border-bottom: 1px solid #e4e9f4 !important;
  background: #fff !important;
  color: #5b6aa1 !important;
  box-shadow: none !important;
  padding: 0.65rem 1rem !important;
}

.dash-panel :deep(.p-datatable-tbody > tr > td) {
  font-size: 0.8125rem;
  font-weight: 500;
  color: #334155 !important;
  border: 0 !important;
  border-bottom: 1px solid #eef2f8 !important;
  padding: 0.65rem 1rem !important;
}

.dash-panel :deep(.p-datatable-tbody > tr:last-child > td) {
  border-bottom: 0 !important;
}

.dash-panel :deep(.p-datatable-tbody > tr:hover > td) {
  background: #f3f5fb !important;
}

.dash-panel :deep(.p-paginator) {
  border: 0;
  border-top: 1px solid #e4e9f4;
  background: #f8fafd;
  padding: 0.55rem 0.75rem;
  justify-content: flex-end;
  flex-wrap: wrap;
  gap: 0.35rem;
}

.dash-panel :deep(.p-paginator .p-paginator-page.p-paginator-page-selected) {
  background: #384884;
  color: #fff;
}

.dash-table__empty {
  padding: 1.5rem 1.15rem;
  font-size: 0.875rem;
  color: #94a0b8;
}
</style>
