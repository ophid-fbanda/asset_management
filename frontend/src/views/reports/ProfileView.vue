<script setup>
import { computed, nextTick, onMounted, reactive, ref, watch } from 'vue'
import { Button, Column, DataTable, Select } from 'primevue'
import { arraySearch, objectHeaders, objectSet } from '@/api/objectx'
import { exportToExcel } from '@/api/exportx'
import {
  dataFetchToCache,
  dataFromCache,
  dataFromProfile,
  dataRefreshCache,
  dataSearchModel,
} from '@/api/datax'
import ProfilePdfDocument from '@/views/reports/ProfilePdfDocument.vue'

const GENERAL_USER_ROLE_TYPE_ID = 10
const ASSETS_ADMIN_ROLE_TYPE_ID = 20
const SUPERVISOR_ROLE_TYPE_ID = 40
const MANAGER_ROLE_TYPE_ID = 50

const profile = dataFromProfile()
const search = dataSearchModel()
const staffProfiles = dataFromCache('meta/staff_profiles')
const stations = dataFromCache('meta/stations')
const assetOptions = dataFromCache('reports/profile/options/assets')
const pdfDoc = ref(null)

const ui = reactive({
  profileTypeId: 'asset',
  assetId: null,
  staffId: null,
  stationId: null,
  ranKey: null,
  exportingPdf: false,
})

const userRoleIds = computed(() =>
  [...new Set((profile.value?.roles ?? []).map((role) => role.roleTypeId))],
)

const isPrivileged = computed(() =>
  userRoleIds.value.includes(ASSETS_ADMIN_ROLE_TYPE_ID)
  || userRoleIds.value.includes(SUPERVISOR_ROLE_TYPE_ID)
  || userRoleIds.value.includes(MANAGER_ROLE_TYPE_ID),
)

const isManager = computed(() => userRoleIds.value.includes(MANAGER_ROLE_TYPE_ID))

/** Station profiles are for 20/40/50 only — role 10 alone has no station report. */
const profileTypes = computed(() => {
  const types = [
    { id: 'asset', label: 'Asset', placeholder: 'Search asset' },
    { id: 'staff', label: 'Staff', placeholder: 'Search staff member' },
  ]
  if (isPrivileged.value) {
    types.push({ id: 'station', label: 'Station', placeholder: 'Search station' })
  }
  return types
})

const selectedType = computed(
  () => profileTypes.value.find((item) => item.id === ui.profileTypeId) ?? profileTypes.value[0],
)

const staffOptions = computed(() => {
  const rows = staffProfiles.value ?? []
  if (isPrivileged.value) return rows
  const selfId = profile.value?.profileId
  return rows.filter((row) => row.id === selfId)
})

const stationOptions = computed(() => {
  const rows = stations.value ?? []
  if (isManager.value) return rows

  const roles = profile.value?.roles ?? []
  if (!isPrivileged.value) {
    const homeIds = new Set(
      roles
        .filter((role) => role.roleTypeId === GENERAL_USER_ROLE_TYPE_ID)
        .map((role) => role.stationId),
    )
    return rows.filter((row) => homeIds.has(row.id))
  }

  const prefixes = roles
    .filter((role) =>
      role.roleTypeId === ASSETS_ADMIN_ROLE_TYPE_ID
      || role.roleTypeId === SUPERVISOR_ROLE_TYPE_ID,
    )
    .map((role) => role.stationCode)
    .filter(Boolean)

  // Scope filter uses codes internally; UI only shows station names.
  return rows.filter((row) =>
    prefixes.some((prefix) => String(row.station_code ?? '').startsWith(prefix)),
  )
})

const valueModel = computed({
  get() {
    if (selectedType.value.id === 'asset') return ui.assetId
    if (selectedType.value.id === 'staff') return ui.staffId
    return ui.stationId
  },
  set(value) {
    if (selectedType.value.id === 'asset') ui.assetId = value
    else if (selectedType.value.id === 'staff') ui.staffId = value
    else ui.stationId = value
  },
})

const valueOptions = computed(() => {
  if (selectedType.value.id === 'asset') return assetOptions.value ?? []
  if (selectedType.value.id === 'staff') return staffOptions.value
  return stationOptions.value
})

const valueOptionLabel = computed(() => {
  if (selectedType.value.id === 'staff') return 'full_name'
  if (selectedType.value.id === 'station') return 'station_name'
  return 'label'
})

const canRun = computed(() => valueModel.value != null)

const rowsKey = computed(() => ui.ranKey)
const payload = computed(() => (rowsKey.value ? (dataFromCache(rowsKey.value).value ?? {}) : {}))

const isAssetRun = computed(() => rowsKey.value?.startsWith('reports/profile/asset/') ?? false)
const isStaffRun = computed(() => rowsKey.value?.startsWith('reports/profile/staff/') ?? false)
const isStationRun = computed(() => rowsKey.value?.startsWith('reports/profile/station/') ?? false)

const asset = computed(() => (isAssetRun.value ? (payload.value.asset ?? null) : null))
const staff = computed(() => (isStaffRun.value ? (payload.value.staff ?? null) : null))
const station = computed(() => (isStationRun.value ? (payload.value.station ?? null) : null))

const hasSubject = computed(() => !!(asset.value || staff.value || station.value))

const tableRows = computed(() => {
  if (isAssetRun.value) return payload.value.journey ?? []
  if (isStaffRun.value || isStationRun.value) return payload.value.assets ?? []
  return []
})

const columns = computed(() => objectHeaders(tableRows.value))
const filteredRows = computed(() => arraySearch(tableRows.value, search.value))

const heading = computed(() => {
  if (isStaffRun.value) return 'Staff Assets'
  if (isStationRun.value) return 'Station Assets'
  if (isAssetRun.value) return 'Asset Journey'
  return `${selectedType.value.label} Report`
})

const pdfTitle = computed(() => {
  if (isStaffRun.value) return 'Staff Profile Report'
  if (isStationRun.value) return 'Station Profile Report'
  if (isAssetRun.value) return 'Asset Profile Report'
  return 'Profile Report'
})

const pdfRefCode = computed(() => {
  if (isAssetRun.value) return asset.value?.asset_number || asset.value?.serial_number || 'ASSET'
  if (isStaffRun.value) return staff.value?.full_name || 'STAFF'
  if (isStationRun.value) return station.value?.station_name || 'STATION'
  return 'PROFILE'
})

const pdfMeta = computed(() => {
  if (isAssetRun.value && asset.value) {
    return [
      { label: 'Type', value: asset.value.asset_type },
      { label: 'Brand', value: asset.value.brand },
      { label: 'Model', value: asset.value.model },
      { label: 'Asset Number', value: asset.value.asset_number },
      { label: 'Serial Number', value: asset.value.serial_number },
      { label: 'Condition', value: asset.value.condition },
      { label: 'Current Value', value: asset.value.current_value },
      { label: 'Custodian', value: asset.value.custodian },
      { label: 'Station', value: asset.value.station_name },
      { label: 'Status', value: asset.value.disposed ? 'Disposed' : 'Active' },
    ]
  }
  if (isStaffRun.value && staff.value) {
    return [
      { label: 'Staff', value: staff.value.full_name },
      { label: 'Email', value: staff.value.staff_email },
      { label: 'Phone', value: staff.value.staff_phone },
      { label: 'Assets Held', value: String(filteredRows.value.length) },
    ]
  }
  if (isStationRun.value && station.value) {
    return [
      { label: 'Station', value: station.value.station_name },
      { label: 'Assets Under Station', value: String(filteredRows.value.length) },
    ]
  }
  return []
})

const pdfFilename = computed(() => {
  if (isStaffRun.value) return `profile-staff-${staff.value?.full_name ?? 'staff'}`
  if (isStationRun.value) return `profile-station-${station.value?.station_name ?? 'station'}`
  return `profile-asset-${asset.value?.asset_number || asset.value?.serial_number || 'asset'}`
})

/** All PDFs: Prepared by = login user. Staff: selected name for wet ink. Others: Verified by. */
const pdfPreparedBy = computed(() =>
  hasSubject.value ? (profile.value?.name ?? '') : '',
)
const pdfAcknowledgedBy = computed(() => {
  if (!hasSubject.value) return ''
  if (isStaffRun.value) return staff.value?.full_name ?? ''
  return 'Verified by'
})

const buildRunKey = () => {
  if (!canRun.value) return null
  if (selectedType.value.id === 'asset') return `reports/profile/asset/${ui.assetId}`
  if (selectedType.value.id === 'staff') return `reports/profile/staff/${ui.staffId}`
  if (selectedType.value.id === 'station') return `reports/profile/station/${ui.stationId}`
  return null
}

const runReport = () => {
  const key = buildRunKey()
  if (!key) return
  objectSet(ui, 'ranKey', key)
  dataRefreshCache(key)
}

const exportExcel = () => {
  if (isStaffRun.value) {
    exportToExcel(filteredRows.value, pdfFilename.value, 'Staff Assets')
    return
  }
  if (isStationRun.value) {
    exportToExcel(filteredRows.value, pdfFilename.value, 'Station Assets')
    return
  }
  exportToExcel(filteredRows.value, pdfFilename.value, 'Asset Journey')
}

const exportPdf = async () => {
  if (!hasSubject.value || ui.exportingPdf) return
  ui.exportingPdf = true
  try {
    await nextTick()
    await pdfDoc.value?.save(pdfFilename.value, 'landscape')
  } finally {
    ui.exportingPdf = false
  }
}

watch(
  () => ui.profileTypeId,
  () => {
    objectSet(ui, 'ranKey', null)
    objectSet(ui, 'assetId', null)
    objectSet(ui, 'staffId', null)
    objectSet(ui, 'stationId', null)
    if (!isPrivileged.value && profile.value?.profileId) {
      ui.staffId = profile.value.profileId
    }
  },
)

watch(
  isPrivileged,
  (privileged) => {
    if (!privileged && ui.profileTypeId === 'station') {
      objectSet(ui, 'profileTypeId', 'asset')
    }
  },
  { immediate: true },
)

onMounted(() => {
  dataFetchToCache('meta/staff_profiles')
  if (isPrivileged.value) dataFetchToCache('meta/stations')
  dataFetchToCache('reports/profile/options/assets')
})
</script>

<template>
  <div class="flex min-h-0 flex-1 flex-col gap-4 overflow-hidden">
    <div class="flex shrink-0 flex-wrap items-end gap-3">
      <div class="flex min-w-[11rem] flex-col gap-1.5 sm:w-44">
        <label class="text-xs font-semibold tracking-wide text-[#384884] uppercase">Profile</label>
        <Select
          v-model="ui.profileTypeId"
          :options="profileTypes"
          option-label="label"
          option-value="id"
          class="w-full"
        />
      </div>

      <div class="flex min-w-[16rem] flex-1 flex-col gap-1.5 sm:max-w-lg">
        <label class="text-xs font-semibold tracking-wide text-[#384884] uppercase">Value</label>
        <Select
          v-model="valueModel"
          :options="valueOptions"
          :option-label="valueOptionLabel"
          option-value="id"
          :placeholder="selectedType.placeholder"
          filter
          class="w-full"
        />
      </div>

      <Button
        type="button"
        label="Run Report"
        icon="pi pi-sync"
        size="small"
        :disabled="!canRun"
        class="w-36 shrink-0"
        @click="runReport"
      />

      <Button
        v-if="hasSubject && filteredRows.length"
        type="button"
        label="Excel"
        icon="pi pi-file-excel"
        severity="secondary"
        size="small"
        class="shrink-0"
        @click="exportExcel"
      />

      <Button
        v-if="hasSubject"
        type="button"
        label="PDF"
        icon="pi pi-file-pdf"
        severity="secondary"
        size="small"
        class="shrink-0"
        :loading="ui.exportingPdf"
        @click="exportPdf"
      />
    </div>

    <div
      v-if="asset"
      class="grid shrink-0 gap-3 border border-[#c5cce3] bg-[#f8fafd] p-3 sm:grid-cols-2 lg:grid-cols-4"
    >
      <div>
        <p class="text-[10px] font-semibold tracking-wide text-slate-500 uppercase">Asset</p>
        <p class="text-sm font-semibold text-[#384884]">
          {{ asset.asset_type }} {{ asset.brand }} {{ asset.model }}
        </p>
      </div>
      <div>
        <p class="text-[10px] font-semibold tracking-wide text-slate-500 uppercase">Identity</p>
        <p class="text-sm font-semibold text-[#384884]">
          {{ asset.asset_number || asset.serial_number || '—' }}
        </p>
      </div>
      <div>
        <p class="text-[10px] font-semibold tracking-wide text-slate-500 uppercase">Condition / Station</p>
        <p class="text-sm font-semibold text-[#384884]">
          {{ asset.condition }} · {{ asset.station_name }}
        </p>
      </div>
      <div>
        <p class="text-[10px] font-semibold tracking-wide text-slate-500 uppercase">Status</p>
        <p class="text-sm font-semibold text-[#384884]">
          {{ asset.disposed ? 'Disposed' : 'Active' }}
          <span v-if="asset.custodian"> · {{ asset.custodian }}</span>
        </p>
      </div>
    </div>

    <div
      v-if="staff"
      class="grid shrink-0 gap-3 border border-[#c5cce3] bg-[#f8fafd] p-3 sm:grid-cols-2 lg:grid-cols-3"
    >
      <div>
        <p class="text-[10px] font-semibold tracking-wide text-slate-500 uppercase">Staff</p>
        <p class="text-sm font-semibold text-[#384884]">{{ staff.full_name }}</p>
      </div>
      <div>
        <p class="text-[10px] font-semibold tracking-wide text-slate-500 uppercase">Email</p>
        <p class="text-sm font-semibold text-[#384884]">{{ staff.staff_email || '—' }}</p>
      </div>
      <div>
        <p class="text-[10px] font-semibold tracking-wide text-slate-500 uppercase">Phone</p>
        <p class="text-sm font-semibold text-[#384884]">{{ staff.staff_phone || '—' }}</p>
      </div>
    </div>

    <div
      v-if="station"
      class="grid shrink-0 gap-3 border border-[#c5cce3] bg-[#f8fafd] p-3"
    >
      <div>
        <p class="text-[10px] font-semibold tracking-wide text-slate-500 uppercase">Station</p>
        <p class="text-sm font-semibold text-[#384884]">{{ station.station_name }}</p>
      </div>
    </div>

    <div class="flex shrink-0 flex-wrap items-baseline gap-3">
      <h2 class="text-lg font-semibold text-[#384884]">{{ heading }}</h2>
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
              !rowsKey
                ? 'Select a value, then Run Report.'
                : isStaffRun || isStationRun
                  ? 'No current assets for that selection.'
                  : 'No journey found for that asset (or you are not allowed to see it).'
            }}
          </div>
        </template>
      </DataTable>
    </div>

    <!-- Off-screen PDF sheet: keeps phone/email/identity with the rows -->
    <div
      v-if="hasSubject"
      class="pointer-events-none fixed top-0 -left-[10000px]"
      aria-hidden="true"
    >
      <ProfilePdfDocument
        ref="pdfDoc"
        :title="pdfTitle"
        :ref-code="pdfRefCode"
        :meta="pdfMeta"
        :rows="filteredRows"
        :columns="columns"
        :section-title="heading"
        :prepared-by="pdfPreparedBy"
        :acknowledged-by="pdfAcknowledgedBy"
      />
    </div>
  </div>
</template>
