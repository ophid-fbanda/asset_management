<script setup>
import { computed, onMounted, ref } from 'vue'
import { dataFetchToCache, dataFromCache } from '@/api/datax'
import { exportToPDF } from '@/api/exportx'
import logo from '@/assets/logo.png'

const props = defineProps({
  collected: { type: Array, required: true },
})

const entity = computed(() => props.collected[0] ?? {})
const docEl  = ref(null)

const savePdf = () => exportToPDF(docEl.value, `EVL-EN${entity.value?.entity_id}EV${entity.value?.event_id}`, 'landscape', 'a4')

const dataKey    = computed(() => entity.value?.entity_id != null ? `assets/evaluation/${entity.value.entity_id}` : null)
const evaluation = computed(() => dataKey.value ? (dataFromCache(dataKey.value).value ?? {}) : {})
const details    = computed(() => evaluation.value.details   ?? {})
const approvals  = computed(() => evaluation.value.approvals ?? [])

const supervisorApproval = computed(() => approvals.value.find((a) => a.approval_type_id === 40 || a.approval_type_id === 41) ?? null)
const managerApproval    = computed(() => approvals.value.find((a) => a.approval_type_id === 50 || a.approval_type_id === 51) ?? null)

const approvalColor = (typeId) => typeId % 2 === 0 ? '#384884' : '#ef4444'

const latestApprovalColor = computed(() => {
  const id = entity.value?.latest_approval_type_id ?? 0
  if (id === 0) return '#f59e0b'
  return id % 2 === 0 ? '#22c55e' : '#ef4444'
})

const formattedValue = computed(() => {
  const v = details.value.evaluated_value
  if (v == null) return '—'
  return Number(v).toLocaleString(undefined, { minimumFractionDigits: 2, maximumFractionDigits: 2 })
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
        <span class="text-[13px] font-black uppercase tracking-tight text-[#384884]">Asset Evaluation Record</span>
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
          <span class="text-[8px] font-bold uppercase tracking-widest text-[#384884]">Asset</span>
          <span class="font-semibold">{{ details.asset_type }} — {{ details.brand }} {{ details.model }}</span>
        </div>
        <div class="flex flex-col gap-0.5 border-b border-[#e2e8f0] pb-1.5">
          <span class="text-[8px] font-bold uppercase tracking-widest text-[#384884]">Asset Number</span>
          <span class="font-semibold">{{ details.asset_number ?? '—' }}</span>
        </div>
        <div class="flex flex-col gap-0.5 border-b border-[#e2e8f0] pb-1.5">
          <span class="text-[8px] font-bold uppercase tracking-widest text-[#384884]">Serial Number</span>
          <span class="font-semibold">{{ details.serial_number ?? '—' }}</span>
        </div>
        <div class="flex flex-col gap-0.5 border-b border-[#e2e8f0] pb-1.5">
          <span class="text-[8px] font-bold uppercase tracking-widest text-[#384884]">Station</span>
          <span class="font-semibold">{{ details.station }}</span>
        </div>
        <div class="flex flex-col gap-0.5 border-b border-[#e2e8f0] pb-1.5">
          <span class="text-[8px] font-bold uppercase tracking-widest text-[#384884]">Evaluation Type</span>
          <span class="font-semibold">{{ details.evaluation_type }}</span>
        </div>
        <div class="flex flex-col gap-0.5 border-b border-[#e2e8f0] pb-1.5">
          <span class="text-[8px] font-bold uppercase tracking-widest text-[#384884]">Evaluated Value</span>
          <span class="font-semibold">{{ formattedValue }}</span>
        </div>
        <div class="flex flex-col gap-0.5 border-b border-[#e2e8f0] pb-1.5">
          <span class="text-[8px] font-bold uppercase tracking-widest text-[#384884]">Evaluation Date</span>
          <span class="font-semibold">{{ details.evaluation_date }}</span>
        </div>
        <div v-if="details.notes" class="col-span-3 flex flex-col gap-0.5 border-b border-[#e2e8f0] pb-1.5">
          <span class="text-[8px] font-bold uppercase tracking-widest text-[#384884]">Notes</span>
          <span>{{ details.notes }}</span>
        </div>
      </div>

      <!-- Signature block -->
      <div class="border-t border-[#e2e8f0] pt-6 flex flex-col">

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

        <div class="flex gap-10 pt-2 pb-1">
          <div class="flex-1 border-b border-[#94a3b8] flex items-end justify-between">
            <span class="font-semibold text-[11px]">{{ details.submitted_by }}</span>
            <span class="text-[8px] text-[#64748b] pb-0.5">{{ details.evaluation_date }}</span>
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

  <!-- PDF export -->
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

  </div>
</template>
