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
    icon: 'pi pi-tags',
    accent: '#384884',
    rows: dashboard.value.by_type ?? [],
  },
  {
    id: 'by_station',
    title: 'By station',
    icon: 'pi pi-building',
    accent: '#0e7490',
    rows: dashboard.value.by_station ?? [],
  },
  {
    id: 'by_condition',
    title: 'By condition',
    icon: 'pi pi-check-circle',
    accent: '#0f766e',
    rows: dashboard.value.by_condition ?? [],
  },
  {
    id: 'by_type_condition',
    title: 'By type and condition',
    icon: 'pi pi-th-large',
    accent: '#b45309',
    rows: dashboard.value.by_type_condition ?? [],
  },
])

const cards = computed(() => [
  {
    id: 'total',
    label: 'Total assets',
    value: summary.value.total_assets ?? 0,
    hint: 'Active inventory in this scope',
    icon: 'pi pi-box',
    accent: '#384884',
  },
  {
    id: 'value',
    label: 'Total value',
    value: summary.value.total_value ?? 0,
    hint: 'Sum of current values (active)',
    icon: 'pi pi-wallet',
    accent: '#0f766e',
  },
  {
    id: 'damaged',
    label: 'Damaged',
    value: summary.value.damaged_assets ?? 0,
    hint: 'Active assets in damaged condition',
    icon: 'pi pi-exclamation-triangle',
    accent: '#b45309',
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
        :style="{ '--accent': card.accent }"
      >
        <span class="dash-kpi__icon"><i :class="card.icon" /></span>
        <div class="dash-kpi__body">
          <p class="dash-kpi__label">{{ card.label }}</p>
          <p class="dash-kpi__value">{{ formatValue(card) }}</p>
          <p class="dash-kpi__hint">{{ card.hint }}</p>
        </div>
      </div>
    </div>

    <div class="dash-grid shrink-0">
      <section
        v-for="panel in panels"
        :key="panel.id"
        class="dash-panel"
        :style="{ '--accent': panel.accent }"
      >
        <div class="dash-panel__head">
          <span class="dash-panel__icon"><i :class="panel.icon" /></span>
          <h2>{{ panel.title }}</h2>
          <span class="dash-panel__count">{{ panel.rows.length }} {{ panel.rows.length === 1 ? 'group' : 'groups' }}</span>
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
  display: flex;
  align-items: flex-start;
  gap: 0.95rem;
  padding: 1.15rem 1.25rem;
  border: 1px solid #e2e8f2;
  border-radius: 0.9rem;
  background: #ffffff;
  box-shadow: 0 1px 2px rgb(15 23 42 / 4%);
  transition: box-shadow 0.18s ease, transform 0.18s ease, border-color 0.18s ease;
}

.dash-kpi:hover {
  transform: translateY(-2px);
  box-shadow: 0 10px 26px rgb(15 23 42 / 8%);
  border-color: color-mix(in srgb, var(--accent) 35%, #e2e8f2);
}

.dash-kpi__icon {
  display: flex;
  align-items: center;
  justify-content: center;
  width: 2.85rem;
  height: 2.85rem;
  flex-shrink: 0;
  border-radius: 0.8rem;
  font-size: 1.2rem;
  color: var(--accent);
  background: color-mix(in srgb, var(--accent) 12%, #ffffff);
  box-shadow: inset 0 0 0 1px color-mix(in srgb, var(--accent) 18%, transparent);
}

.dash-kpi__body {
  display: flex;
  min-width: 0;
  flex-direction: column;
  gap: 0.2rem;
}

.dash-kpi__label {
  margin: 0;
  font-size: 0.72rem;
  font-weight: 600;
  letter-spacing: 0.04em;
  text-transform: uppercase;
  color: #64748b;
}

.dash-kpi__value {
  margin: 0.1rem 0 0;
  font-size: 1.95rem;
  font-weight: 700;
  letter-spacing: -0.02em;
  line-height: 1.05;
  color: #0f172a;
}

.dash-kpi__hint {
  margin: 0.1rem 0 0;
  font-size: 0.75rem;
  color: #94a3b8;
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
  border: 1px solid #e2e8f2;
  border-radius: 0.9rem;
  background: #fff;
  box-shadow: 0 1px 2px rgb(15 23 42 / 4%);
  transition: box-shadow 0.18s ease, border-color 0.18s ease;
}

.dash-panel:hover {
  box-shadow: 0 10px 26px rgb(15 23 42 / 7%);
  border-color: color-mix(in srgb, var(--accent) 28%, #e2e8f2);
}

.dash-panel__head {
  display: flex;
  align-items: center;
  gap: 0.6rem;
  padding: 0.85rem 1.1rem;
  border-bottom: 1px solid #eef2f8;
  background: #fff;
}

.dash-panel__icon {
  display: flex;
  align-items: center;
  justify-content: center;
  width: 1.95rem;
  height: 1.95rem;
  flex-shrink: 0;
  border-radius: 0.6rem;
  font-size: 0.85rem;
  color: var(--accent);
  background: color-mix(in srgb, var(--accent) 12%, #ffffff);
}

.dash-panel__head h2 {
  flex: 1;
  margin: 0;
  font-size: 0.92rem;
  font-weight: 650;
  color: #0f172a;
}

.dash-panel__count {
  flex-shrink: 0;
  font-size: 0.68rem;
  font-weight: 600;
  letter-spacing: 0.03em;
  text-transform: uppercase;
  color: #475569;
  background: #f1f5f9;
  border-radius: 999px;
  padding: 0.18rem 0.62rem;
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
  font-size: 0.68rem;
  font-weight: 600;
  letter-spacing: 0.04em;
  text-transform: uppercase;
  border: 0 !important;
  border-bottom: 1px solid #eef2f8 !important;
  background: #fafbfe !important;
  color: #64748b !important;
  box-shadow: none !important;
  padding: 0.6rem 1.05rem !important;
}

.dash-panel :deep(.p-datatable-tbody > tr > td) {
  font-size: 0.82rem;
  font-weight: 500;
  color: #334155 !important;
  border: 0 !important;
  border-bottom: 1px solid #f1f5f9 !important;
  padding: 0.68rem 1.05rem !important;
}

.dash-panel :deep(.p-datatable-tbody > tr:nth-child(even) > td) {
  background: #fbfcfe !important;
}

.dash-panel :deep(.p-datatable-tbody > tr:last-child > td) {
  border-bottom: 0 !important;
}

.dash-panel :deep(.p-datatable-tbody > tr:hover > td) {
  background: #f4f7fd !important;
}

.dash-panel :deep(.p-datatable-tbody > tr:hover) {
  box-shadow: none !important;
}

.dash-panel :deep(.p-paginator) {
  border: 0;
  border-top: 1px solid #eef2f8;
  background: #fafbfe;
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
