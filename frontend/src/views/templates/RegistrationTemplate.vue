<script setup>
import { computed, onMounted } from 'vue'
import { dataFetchToCache, dataFromCache } from '@/api/datax'

const props = defineProps({
  collected: { type: Array, required: true },
})

const entity = computed(() => props.collected[0] ?? {})

const dataKey = computed(() => {
  const id = entity.value?.entity_id
  return id != null ? `assets/registrations/${id}/list` : null
})

const assets = computed(() => dataKey.value ? (dataFromCache(dataKey.value).value ?? []) : [])

onMounted(() => {
  if (dataKey.value) dataFetchToCache(dataKey.value)
})
</script>

<template>
  <div class="w-[297mm] min-h-[210mm] bg-white p-[18mm] shadow-xl text-[#0f172a] text-[11px]">

    <!-- Header -->
    <div class="mb-6">
      <div class="grid grid-cols-3 items-start">
        <div class="text-[9px] font-bold uppercase tracking-widest text-[#94a3b8]">
          Assets Management System
        </div>
        <div class="flex flex-col items-center text-center gap-0.5">
          <span class="text-[13px] font-black uppercase tracking-tight">OPHID</span>
          <span class="text-[9px] font-bold uppercase tracking-[0.2em] text-[#64748b]">Asset Registration Record</span>
        </div>
        <div class="text-right">
          <div class="inline-block border border-[#e2e8f0] bg-[#f8fafc] px-4 py-2">
            <span class="text-[9px] font-bold uppercase text-[#94a3b8] block mb-0.5">Doc Ref</span>
            <span class="text-sm font-mono font-black">RG-{{ entity.entity_id }}</span>
          </div>
        </div>
      </div>
      <div class="h-px w-full bg-[#0f172a] mt-3"></div>
    </div>

    <!-- Meta -->
    <div class="grid grid-cols-3 gap-x-10 gap-y-2.5 mb-8">
      <div class="flex gap-2 border-b border-[#e2e8f0] pb-1">
        <span class="uppercase text-[#94a3b8] shrink-0">Station:</span>
        <span class="font-bold">{{ entity.station_name }}</span>
      </div>
      <div class="flex gap-2 border-b border-[#e2e8f0] pb-1">
        <span class="uppercase text-[#94a3b8] shrink-0">Registered By:</span>
        <span class="font-bold">{{ entity.admin_name }}</span>
      </div>
      <div class="flex gap-2 border-b border-[#e2e8f0] pb-1">
        <span class="uppercase text-[#94a3b8] shrink-0">Date:</span>
        <span class="font-bold">{{ entity.event_date }}</span>
      </div>
    </div>

    <!-- Assets Table -->
    <div>
      <div class="text-[9px] font-bold uppercase tracking-widest text-[#94a3b8] mb-2">
        Registered Assets ({{ assets.length }})
      </div>
      <table v-if="assets.length" class="w-full border-collapse text-[10px]">
        <thead>
          <tr class="bg-[#f8fafc]">
            <th
              v-for="col in Object.keys(assets[0])"
              :key="col"
              class="border border-[#e2e8f0] px-2 py-1.5 text-left font-bold uppercase text-[#64748b]"
            >{{ col.replace(/_/g, ' ') }}</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="(asset, i) in assets" :key="i" :class="i % 2 === 0 ? 'bg-white' : 'bg-[#f8fafc]'">
            <td
              v-for="col in Object.keys(assets[0])"
              :key="col"
              class="border border-[#e2e8f0] px-2 py-1"
            >{{ asset[col] }}</td>
          </tr>
        </tbody>
      </table>
      <p v-else class="text-[10px] text-[#94a3b8] uppercase tracking-widest py-4 text-center">
        No assets loaded
      </p>
    </div>

    <!-- Approval Footer -->
    <div class="mt-12 pt-4 border-t border-[#e2e8f0] grid grid-cols-2 gap-8">
      <div class="flex flex-col gap-6">
        <span class="text-[9px] font-bold uppercase tracking-widest text-[#94a3b8]">Supervisor (Name, Signature &amp; Date)</span>
        <div class="border-b border-[#0f172a] h-1"></div>
      </div>
      <div class="flex flex-col gap-6">
        <span class="text-[9px] font-bold uppercase tracking-widest text-[#94a3b8]">Manager (Name, Signature &amp; Date)</span>
        <div class="border-b border-[#0f172a] h-1"></div>
      </div>
    </div>

  </div>
</template>
