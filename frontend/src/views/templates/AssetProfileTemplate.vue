<script setup>
import { computed, ref } from 'vue'
import { dataFromProfile } from '@/api/datax'
import { exportToPDF } from '@/api/exportx'
import logo from '@/assets/logo.png'

const props = defineProps({
  collected: { type: Array, required: true },
})

const asset = computed(() => props.collected[0] ?? {})
const profile = dataFromProfile()
const preparedBy = computed(() => profile.value?.name ?? '—')
const docEl = ref(null)

const savePdf = () => exportToPDF(docEl.value, `PRF-${asset.value?.asset_number ?? asset.value?.serial_number ?? 'ASSET'}`, 'portrait', 'a4')

const conditionColor = computed(() => {
  const c = (asset.value?.condition ?? '').toLowerCase()
  if (c.includes('good') || c.includes('excellent') || c.includes('new')) return '#22c55e'
  if (c.includes('fair') || c.includes('moderate')) return '#f59e0b'
  if (c.includes('poor') || c.includes('bad') || c.includes('damage')) return '#ef4444'
  return '#64748b'
})

const formattedValue = computed(() => {
  const v = asset.value?.current_value
  if (v == null) return '—'
  return Number(v).toLocaleString(undefined, { minimumFractionDigits: 2, maximumFractionDigits: 2 })
})
</script>

<template>
  <div class="flex w-full flex-col items-center gap-5 py-2">

  <!-- Document -->
  <div ref="docEl" class="flex h-[297mm] w-[210mm] shrink-0 flex-col overflow-hidden border border-[#e2e8f0] bg-white text-[11px] text-[#0f172a] shadow-sm">

    <!-- Header -->
    <div class="flex shrink-0 items-center justify-between gap-6 border-b border-[#384884] px-[20mm] pb-6 pt-[14mm]">
      <img :src="logo" alt="Logo" class="h-12 w-auto object-contain" />
      <div class="flex flex-col items-center text-center">
        <span class="text-[13px] font-black uppercase tracking-tight text-[#384884]">Asset Profile</span>
        <span class="mt-1 text-[9px] uppercase tracking-widest text-[#64748b]">Assets Management System</span>
      </div>
      <div class="flex min-w-[9rem] flex-col items-center border border-[#384884] px-4 py-2.5 text-center">
        <span class="font-mono text-[10px] font-black text-[#0f172a]">{{ asset.asset_number ?? asset.serial_number ?? '—' }}</span>
        <span
          class="mt-1 text-[8px] font-bold uppercase tracking-wide"
          :style="{ color: asset.disposed ? '#ef4444' : '#22c55e' }"
        >{{ asset.disposed ? 'Disposed' : 'Active' }}</span>
      </div>
    </div>

    <!-- Body -->
    <div class="flex min-h-0 flex-1 flex-col gap-12 px-[20mm] pt-[14mm]">

      <!-- Identity -->
      <div>
        <p class="mb-5 text-[8px] font-bold uppercase tracking-widest text-[#384884]">Asset Identity</p>
        <div class="grid grid-cols-2 gap-x-10 gap-y-5">
          <div class="flex flex-col gap-1 border-b border-[#e2e8f0] pb-2.5">
            <span class="text-[8px] font-bold uppercase tracking-widest text-[#64748b]">Type</span>
            <span class="text-[12px] font-semibold">{{ asset.asset_type }}</span>
          </div>
          <div class="flex flex-col gap-1 border-b border-[#e2e8f0] pb-2.5">
            <span class="text-[8px] font-bold uppercase tracking-widest text-[#64748b]">Brand</span>
            <span class="text-[12px] font-semibold">{{ asset.brand }}</span>
          </div>
          <div class="flex flex-col gap-1 border-b border-[#e2e8f0] pb-2.5">
            <span class="text-[8px] font-bold uppercase tracking-widest text-[#64748b]">Model</span>
            <span class="text-[12px] font-semibold">{{ asset.model }}</span>
          </div>
          <div class="flex flex-col gap-1 border-b border-[#e2e8f0] pb-2.5">
            <span class="text-[8px] font-bold uppercase tracking-widest text-[#64748b]">Asset Number</span>
            <span class="text-[12px] font-semibold">{{ asset.asset_number ?? '—' }}</span>
          </div>
          <div class="col-span-2 flex flex-col gap-1 border-b border-[#e2e8f0] pb-2.5">
            <span class="text-[8px] font-bold uppercase tracking-widest text-[#64748b]">Serial Number</span>
            <span class="text-[12px] font-semibold">{{ asset.serial_number ?? '—' }}</span>
          </div>
        </div>
      </div>

      <!-- Current State -->
      <div>
        <p class="mb-5 text-[8px] font-bold uppercase tracking-widest text-[#384884]">Current State</p>
        <div class="grid grid-cols-2 gap-x-10 gap-y-5">
          <div class="flex flex-col gap-1 border-b border-[#e2e8f0] pb-2.5">
            <span class="text-[8px] font-bold uppercase tracking-widest text-[#64748b]">Condition</span>
            <span class="text-[12px] font-semibold" :style="{ color: conditionColor }">{{ asset.condition ?? '—' }}</span>
          </div>
          <div class="flex flex-col gap-1 border-b border-[#e2e8f0] pb-2.5">
            <span class="text-[8px] font-bold uppercase tracking-widest text-[#64748b]">Current Value</span>
            <span class="text-[12px] font-semibold">{{ formattedValue }}</span>
          </div>
          <div class="flex flex-col gap-1 border-b border-[#e2e8f0] pb-2.5">
            <span class="text-[8px] font-bold uppercase tracking-widest text-[#64748b]">Custodian</span>
            <span class="text-[12px] font-semibold">{{ asset.custodian ?? '—' }}</span>
          </div>
          <div class="flex flex-col gap-1 border-b border-[#e2e8f0] pb-2.5">
            <span class="text-[8px] font-bold uppercase tracking-widest text-[#64748b]">Station</span>
            <span class="text-[12px] font-semibold">{{ asset.station_name ?? '—' }}</span>
          </div>
        </div>
      </div>

    </div>

    <!-- Footer: signatures pinned to page bottom -->
    <div class="mt-auto shrink-0 px-[20mm] pb-[16mm] pt-10">
      <div class="flex flex-col gap-8 border-t border-[#e2e8f0] pt-8">
        <p class="text-[8px] font-bold uppercase tracking-widest text-[#384884]">Acknowledgement</p>
        <div class="flex gap-12">
          <div class="flex flex-1 flex-col gap-3">
            <span class="text-[8px] font-bold uppercase tracking-widest text-[#64748b]">Prepared by</span>
            <div class="flex min-h-[2.5rem] items-end justify-between border-b border-[#94a3b8] pb-1">
              <span class="text-[12px] font-semibold">{{ preparedBy }}</span>
              <span class="text-[8px] text-[#64748b]">Date</span>
            </div>
          </div>
          <div class="flex flex-1 flex-col gap-3">
            <span class="text-[8px] font-bold uppercase tracking-widest text-[#64748b]">Verified by</span>
            <div class="flex min-h-[2.5rem] items-end justify-between border-b border-[#94a3b8] pb-1">
              <span class="text-[8px] text-[#64748b]">Name &amp; Signature</span>
              <span class="text-[8px] text-[#64748b]">Date</span>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>

  <!-- PDF export -->
  <div class="flex w-[210mm] justify-end">
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
