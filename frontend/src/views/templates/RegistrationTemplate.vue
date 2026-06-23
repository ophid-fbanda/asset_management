<script setup>
import { computed, onMounted } from 'vue'
import { dataFetchToCache, dataFromCache } from '@/api/datax'
import logo from '@/assets/logo.png'

const props = defineProps({
  collected: { type: Array, required: true },
})

const entity = computed(() => props.collected[0] ?? {})

const dataKey      = computed(() => entity.value?.entity_id != null ? `assets/registrations/${entity.value.entity_id}` : null)
const registration = computed(() => dataKey.value ? (dataFromCache(dataKey.value).value ?? {}) : {})
const details      = computed(() => registration.value.details ?? {})
const assets       = computed(() => registration.value.list    ?? [])

onMounted(() => {
  if (dataKey.value) dataFetchToCache(dataKey.value)
})
</script>

<template>
  <div class="w-[297mm] min-h-[210mm] bg-white shadow-xl text-[#0f172a] text-[11px] overflow-hidden">

    <!-- Header -->
    <div class="px-[18mm] pt-[10mm] pb-4 border-b border-[#384884] flex items-center justify-between gap-6">
      <img :src="logo" alt="Logo" class="h-12 w-auto object-contain" />
      <div class="flex flex-col items-center text-center">
        <span class="text-[13px] font-black uppercase tracking-tight text-[#384884]">Asset Registration Record</span>
        <span class="text-[9px] uppercase tracking-widest text-[#64748b] mt-0.5">Assets Management System</span>
      </div>
      <div class="border border-[#384884] px-4 py-2 text-right">
        <span class="text-[8px] font-bold uppercase tracking-widest text-[#384884] block">Doc Ref</span>
        <span class="text-sm font-mono font-black text-[#0f172a]">RG-{{ entity.entity_id }}</span>
      </div>
    </div>

    <div class="px-[18mm] py-[10mm]">

      <!-- Meta grid -->
      <div class="grid grid-cols-3 gap-x-8 gap-y-3 mb-8">
        <div class="flex flex-col gap-0.5 border-b border-[#e2e8f0] pb-1.5">
          <span class="text-[8px] font-bold uppercase tracking-widest text-[#384884]">Station</span>
          <span class="font-semibold">{{ entity.station_name }}</span>
        </div>
        <div class="flex flex-col gap-0.5 border-b border-[#e2e8f0] pb-1.5">
          <span class="text-[8px] font-bold uppercase tracking-widest text-[#384884]">Registered By</span>
          <span class="font-semibold">{{ entity.admin_name }}</span>
        </div>
        <div class="flex flex-col gap-0.5 border-b border-[#e2e8f0] pb-1.5">
          <span class="text-[8px] font-bold uppercase tracking-widest text-[#384884]">Event Date</span>
          <span class="font-semibold">{{ entity.event_date }}</span>
        </div>
        <div class="flex flex-col gap-0.5 border-b border-[#e2e8f0] pb-1.5">
          <span class="text-[8px] font-bold uppercase tracking-widest text-[#384884]">Program</span>
          <span class="font-semibold">{{ details.program }}</span>
        </div>
        <div class="flex flex-col gap-0.5 border-b border-[#e2e8f0] pb-1.5">
          <span class="text-[8px] font-bold uppercase tracking-widest text-[#384884]">Supplier</span>
          <span class="font-semibold">{{ details.supplier }}</span>
        </div>
        <div class="flex flex-col gap-0.5 border-b border-[#e2e8f0] pb-1.5">
          <span class="text-[8px] font-bold uppercase tracking-widest text-[#384884]">Acquisition Type</span>
          <span class="font-semibold">{{ details.acquisition_type }}</span>
        </div>
        <div class="flex flex-col gap-0.5 border-b border-[#e2e8f0] pb-1.5">
          <span class="text-[8px] font-bold uppercase tracking-widest text-[#384884]">Reference Type</span>
          <span class="font-semibold">{{ details.reference_type }}</span>
        </div>
        <div class="flex flex-col gap-0.5 border-b border-[#e2e8f0] pb-1.5">
          <span class="text-[8px] font-bold uppercase tracking-widest text-[#384884]">Reference Date</span>
          <span class="font-semibold">{{ details.reference_date }}</span>
        </div>
        <div v-if="details.reference_attachment" class="flex flex-col gap-0.5 border-b border-[#e2e8f0] pb-1.5">
          <span class="text-[8px] font-bold uppercase tracking-widest text-[#384884]">Attachment</span>
          <a
            :href="`/uploads/${details.reference_attachment}`"
            target="_blank"
            class="inline-flex items-center gap-1 text-[#384884] font-semibold underline underline-offset-2"
          >
            <i class="pi pi-paperclip text-[9px]" />
            <span>{{ details.reference_attachment }}</span>
          </a>
        </div>
        <div v-if="details.notes" class="col-span-3 flex flex-col gap-0.5 border-b border-[#e2e8f0] pb-1.5">
          <span class="text-[8px] font-bold uppercase tracking-widest text-[#384884]">Notes</span>
          <span>{{ details.notes }}</span>
        </div>
      </div>

      <!-- Assets table -->
      <div class="mb-8">
        <div class="flex items-center gap-2 mb-2">
          <div class="h-3 w-1 bg-[#384884] rounded-full"></div>
          <span class="text-[9px] font-bold uppercase tracking-widest text-[#384884]">
            Registered Assets ({{ assets.length }})
          </span>
        </div>
        <table v-if="assets.length" class="w-full border-collapse text-[10px]">
          <thead>
            <tr>
              <th
                v-for="col in Object.keys(assets[0])"
                :key="col"
                class="border border-[#384884] bg-[#f1f4fd] px-2 py-1.5 text-left font-bold uppercase text-[9px] tracking-wide text-[#384884]"
              >{{ col.replace(/_/g, ' ') }}</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="(asset, i) in assets" :key="i">
              <td
                v-for="col in Object.keys(assets[0])"
                :key="col"
                class="border border-[#cbd5e1] px-2 py-1"
              >{{ asset[col] }}</td>
            </tr>
          </tbody>
        </table>
        <p v-else class="text-[10px] text-[#94a3b8] uppercase tracking-widest py-4 text-center">
          No assets loaded
        </p>
      </div>

      <!-- Signature block -->
      <div class="mt-10 pt-4 border-t-2 border-[#384884] grid grid-cols-2 gap-12">
        <div class="flex flex-col gap-8">
          <span class="text-[8px] font-bold uppercase tracking-widest text-[#384884]">Supervisor — Name, Signature &amp; Date</span>
          <div class="border-b border-[#0f172a]"></div>
        </div>
        <div class="flex flex-col gap-8">
          <span class="text-[8px] font-bold uppercase tracking-widest text-[#384884]">Manager — Name, Signature &amp; Date</span>
          <div class="border-b border-[#0f172a]"></div>
        </div>
      </div>

    </div>
  </div>
</template>
