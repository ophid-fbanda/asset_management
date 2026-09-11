<script setup>
import { computed, onMounted, ref } from 'vue'
import { Column, DataTable } from 'primevue'
import { dataApiUrl, dataFetchToCache, dataFromCache } from '@/api/datax'
import { exportToPDF } from '@/api/exportx'
import { objectHeaders } from '@/api/objectx'
import logo from '@/assets/logo.png'

const props = defineProps({
  collected: { type: Array, required: true },
})

const entity  = computed(() => props.collected[0] ?? {})
const docEl   = ref(null)

const savePdf = () => exportToPDF(docEl.value, `REG-EN${entity.value?.entity_id}EV${entity.value?.event_id}`, 'landscape', 'a4')

const dataKey      = computed(() => entity.value?.entity_id != null ? `assets/registration/${entity.value.entity_id}` : null)
const registration = computed(() => dataKey.value ? (dataFromCache(dataKey.value).value ?? {}) : {})
const details      = computed(() => registration.value.details   ?? {})
const assets       = computed(() => registration.value.list      ?? [])
const approvals    = computed(() => registration.value.approvals ?? [])
const assetColumns = computed(() => objectHeaders(assets.value))

const supervisorApproval = computed(() => approvals.value.find((a) => a.approval_type_id === 40 || a.approval_type_id === 41) ?? null)
const managerApproval    = computed(() => approvals.value.find((a) => a.approval_type_id === 50 || a.approval_type_id === 51) ?? null)

// Even type IDs = approved (blue), odd = rejected (red)
const approvalColor = (typeId) => typeId % 2 === 0 ? '#384884' : '#ef4444'

const latestApprovalColor = computed(() => {
  const id = entity.value?.latest_approval_type_id ?? 0
  if (id === 0) return '#f59e0b'
  return id % 2 === 0 ? '#22c55e' : '#ef4444'
})

onMounted(() => {
  if (dataKey.value) dataFetchToCache(dataKey.value)
})
</script>

<template>
  <div class="flex flex-col gap-4 w-[297mm]">

  <!-- Document -->
  <div ref="docEl" class="w-[297mm] min-h-[210mm] bg-white text-[#0f172a] text-[11px] overflow-hidden border border-[#e2e8f0]">

    <!-- Header -->
    <div class="px-[18mm] pt-[10mm] pb-4 border-b border-[#384884] flex items-center justify-between gap-6">
      <img :src="logo" alt="Logo" class="h-12 w-auto object-contain" />
      <div class="flex flex-col items-center text-center">
        <span class="text-[13px] font-black uppercase tracking-tight text-[#384884]">Asset Registration Record</span>
        <span class="text-[9px] uppercase tracking-widest text-[#64748b] mt-0.5">Assets Management System</span>
      </div>
      <div class="border border-[#384884] px-4 py-2 flex flex-col items-center text-center min-w-[9rem]">
        <span class="text-sm font-mono font-black text-[#0f172a]">DOC-REF: EN{{ entity.entity_id }}EV{{ entity.event_id }}</span>
        <span
          v-if="entity.latest_approval"
          class="text-[8px] font-bold uppercase tracking-wide mt-0.5"
          :style="{ color: latestApprovalColor }"
        >{{ entity.latest_approval }}</span>
      </div>
    </div>

    <div class="px-[18mm] py-[10mm]">

      <!-- Meta grid -->
      <div class="grid grid-cols-3 gap-x-8 gap-y-3 mb-8">
        <div class="flex flex-col gap-0.5 border-b border-[#e2e8f0] pb-1.5">
          <span class="text-[8px] font-bold uppercase tracking-widest text-[#384884]">Acquisition Type</span>
          <span class="font-semibold">{{ details.acquisition_type }}</span>
        </div>
        <div class="flex flex-col gap-0.5 border-b border-[#e2e8f0] pb-1.5">
          <span class="text-[8px] font-bold uppercase tracking-widest text-[#384884]">Supplier</span>
          <span class="font-semibold">{{ details.supplier }}</span>
        </div>
        <div class="flex flex-col gap-0.5 border-b border-[#e2e8f0] pb-1.5">
          <span class="text-[8px] font-bold uppercase tracking-widest text-[#384884]">Reference Date</span>
          <span class="font-semibold">{{ details.reference_date }}</span>
        </div>
        <div class="flex flex-col gap-0.5 border-b border-[#e2e8f0] pb-1.5">
          <span class="text-[8px] font-bold uppercase tracking-widest text-[#384884]">Program</span>
          <span class="font-semibold">{{ details.program }}</span>
        </div>
        <div class="flex flex-col gap-0.5 border-b border-[#e2e8f0] pb-1.5">
          <span class="text-[8px] font-bold uppercase tracking-widest text-[#384884]">Station</span>
          <span class="font-semibold">{{ entity.station_name }}</span>
        </div>
        <div v-if="details.notes" class="col-span-3 flex flex-col gap-0.5 border-b border-[#e2e8f0] pb-1.5">
          <span class="text-[8px] font-bold uppercase tracking-widest text-[#384884]">Notes</span>
          <span>{{ details.notes }}</span>
        </div>
      </div>

      <!-- Assets table -->
      <div class="mb-10">
        <DataTable
          :value="assets"
          size="small"
          striped-rows
          show-gridlines
          class="text-[10px]"
        >
          <Column
            v-for="col in assetColumns"
            :key="col.field"
            :field="col.field"
            :header="col.header"
          />
        </DataTable>
      </div>

      <!-- Signature block: horizontal rows, split 50/50 -->
      <div class="border-t border-[#e2e8f0] pt-6 flex flex-col">

        <!-- Row 1: role labels only -->
        <div class="flex gap-10 pb-1">
          <div class="flex-1">
            <span class="text-[8px] font-bold uppercase tracking-widest text-[#64748b]">Submitted By</span>
          </div>
          <div class="flex-1">
            <span
              class="text-[8px] font-bold uppercase tracking-widest"
              :style="{ color: supervisorApproval ? approvalColor(supervisorApproval.approval_type_id) : '#384884' }"
            >{{ supervisorApproval ? supervisorApproval.approval : 'Supervisor — Name, Signature &amp; Date' }}</span>
          </div>
          <div class="flex-1">
            <span
              class="text-[8px] font-bold uppercase tracking-widest"
              :style="{ color: managerApproval ? approvalColor(managerApproval.approval_type_id) : '#384884' }"
            >{{ managerApproval ? managerApproval.approval : 'Manager — Name, Signature &amp; Date' }}</span>
          </div>
        </div>

        <!-- Row 2: name left, timestamp right, on the signature line -->
        <div class="flex gap-10 pt-2 pb-1">
          <div class="flex-1 border-b border-[#94a3b8] flex items-end justify-between">
            <span class="font-semibold text-[11px]">{{ entity.admin_name }}</span>
            <span class="text-[8px] text-[#64748b] pb-0.5">{{ entity.captured }}</span>
          </div>
          <div class="flex-1 border-b flex items-end justify-between" :style="{ borderColor: supervisorApproval ? approvalColor(supervisorApproval.approval_type_id) : '#94a3b8' }">
            <span class="font-semibold text-[11px]">{{ supervisorApproval ? supervisorApproval.approved_by : '' }}</span>
            <span v-if="supervisorApproval" class="text-[8px] text-[#64748b] pb-0.5">{{ supervisorApproval.stamp }}</span>
          </div>
          <div class="flex-1 border-b flex items-end justify-between" :style="{ borderColor: managerApproval ? approvalColor(managerApproval.approval_type_id) : '#94a3b8' }">
            <span class="font-semibold text-[11px]">{{ managerApproval ? managerApproval.approved_by : '' }}</span>
            <span v-if="managerApproval" class="text-[8px] text-[#64748b] pb-0.5">{{ managerApproval.stamp }}</span>
          </div>
        </div>

        <!-- Row 3: notes (only when at least one side has notes) -->
        <div v-if="supervisorApproval?.notes || managerApproval?.notes" class="flex gap-10 pt-1">
          <div class="flex-1"></div>
          <div class="flex-1">
            <p v-if="supervisorApproval?.notes" class="text-[9px] text-[#64748b] italic">{{ supervisorApproval.notes }}</p>
          </div>
          <div class="flex-1">
            <p v-if="managerApproval?.notes" class="text-[9px] text-[#64748b] italic">{{ managerApproval.notes }}</p>
          </div>
        </div>

      </div>

    </div>
  </div>

  <!-- PDF export button -->
  <div class="flex justify-end">
    <button
      type="button"
      class="flex cursor-pointer items-center gap-2 rounded-sm border border-[#384884] bg-[#e8eefa] px-3 py-1.5 text-xs font-medium text-[#384884] transition hover:bg-[#384884] hover:text-white"
      @click="savePdf"
    >
      <i class="pi pi-file-pdf text-sm" />
      <span>Export to PDF</span>
    </button>
  </div>

  <!-- Reference attachment viewer -->
  <div v-if="details.reference_attachment" class="w-[297mm] bg-white overflow-hidden border border-[#e2e8f0]">
    <div class="px-4 py-2 border-b border-[#e2e8f0] flex items-center gap-2">
      <i class="pi pi-paperclip text-[#384884] text-sm" />
      <span class="text-[10px] font-bold uppercase tracking-widest text-[#384884]">{{ details.reference_type ?? 'Attachment' }}:</span>
      <span class="text-[10px] text-[#64748b]">{{ details.reference_attachment }}</span>
    </div>
    <iframe
      :src="dataApiUrl(`files/${details.reference_attachment}`)"
      class="w-full h-[400px] border-0"
      title="Reference Attachment"
    />
  </div>

  </div>
</template>
