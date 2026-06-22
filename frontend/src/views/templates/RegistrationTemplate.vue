<script setup>
defineProps({
  collected: { type: Array, required: true },
})

const entity = {
  entity_id: 'RG-001',
  station: 'Central Office',
  program: 'TASQC',
  acquisition_type: 'Purchase',
  reference_type: 'Invoice',
  reference_number: 'INV-2026-0042',
  reference_date: '15/06/2026',
  supplier: 'Liquid',
  registered_by: 'Asset Administrator',
  event_date: '15/06/2026',
  notes: 'Initial batch of laptops for the TASQC program rollout.',
}

const assets = [
  { asset_number: 'SGAN/TASQC/Laptop/1', serial_number: 'SN-HP-001', type: 'Laptop', brand: 'HP', model: 'ProBook 450 G12', condition: 'New', value: '$1,200.00' },
  { asset_number: 'SGAN/TASQC/Laptop/2', serial_number: 'SN-HP-002', type: 'Laptop', brand: 'HP', model: 'ProBook 450 G12', condition: 'New', value: '$1,200.00' },
  { asset_number: 'SGAN/TASQC/Laptop/3', serial_number: 'SN-LN-001', type: 'Laptop', brand: 'Lenovo', model: 'ThinkPad T490', condition: 'New', value: '$1,350.00' },
]
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
            <span class="text-sm font-mono font-black">{{ entity.entity_id }}</span>
          </div>
        </div>
      </div>
      <div class="h-px w-full bg-[#0f172a] mt-3"></div>
    </div>

    <!-- Meta -->
    <div class="grid grid-cols-3 gap-x-10 gap-y-2.5 mb-8">
      <div class="flex gap-2 border-b border-[#e2e8f0] pb-1">
        <span class="uppercase text-[#94a3b8] shrink-0">Station:</span>
        <span class="font-bold">{{ entity.station }}</span>
      </div>
      <div class="flex gap-2 border-b border-[#e2e8f0] pb-1">
        <span class="uppercase text-[#94a3b8] shrink-0">Program:</span>
        <span class="font-bold">{{ entity.program }}</span>
      </div>
      <div class="flex gap-2 border-b border-[#e2e8f0] pb-1">
        <span class="uppercase text-[#94a3b8] shrink-0">Supplier:</span>
        <span class="font-bold">{{ entity.supplier }}</span>
      </div>
      <div class="flex gap-2 border-b border-[#e2e8f0] pb-1">
        <span class="uppercase text-[#94a3b8] shrink-0">Acquisition:</span>
        <span class="font-bold">{{ entity.acquisition_type }}</span>
      </div>
      <div class="flex gap-2 border-b border-[#e2e8f0] pb-1">
        <span class="uppercase text-[#94a3b8] shrink-0">Reference:</span>
        <span class="font-mono font-bold">{{ entity.reference_number }}</span>
      </div>
      <div class="flex gap-2 border-b border-[#e2e8f0] pb-1">
        <span class="uppercase text-[#94a3b8] shrink-0">Date:</span>
        <span class="font-bold">{{ entity.event_date }}</span>
      </div>
      <div class="flex gap-2 border-b border-[#e2e8f0] pb-1">
        <span class="uppercase text-[#94a3b8] shrink-0">Registered By:</span>
        <span class="font-bold">{{ entity.registered_by }}</span>
      </div>
      <div v-if="entity.notes" class="col-span-3 pt-1">
        <span class="uppercase text-[#94a3b8] block mb-0.5">Notes:</span>
        <span class="italic">{{ entity.notes }}</span>
      </div>
    </div>

    <!-- Assets Table -->
    <div>
      <div class="text-[9px] font-bold uppercase tracking-widest text-[#94a3b8] mb-2">
        Registered Assets ({{ assets.length }})
      </div>
      <table class="w-full border-collapse text-[10px]">
        <thead>
          <tr class="bg-[#f8fafc]">
            <th class="border border-[#e2e8f0] px-2 py-1.5 text-left font-bold uppercase text-[#64748b]">Asset No.</th>
            <th class="border border-[#e2e8f0] px-2 py-1.5 text-left font-bold uppercase text-[#64748b]">Serial No.</th>
            <th class="border border-[#e2e8f0] px-2 py-1.5 text-left font-bold uppercase text-[#64748b]">Type</th>
            <th class="border border-[#e2e8f0] px-2 py-1.5 text-left font-bold uppercase text-[#64748b]">Brand</th>
            <th class="border border-[#e2e8f0] px-2 py-1.5 text-left font-bold uppercase text-[#64748b]">Model</th>
            <th class="border border-[#e2e8f0] px-2 py-1.5 text-left font-bold uppercase text-[#64748b]">Condition</th>
            <th class="border border-[#e2e8f0] px-2 py-1.5 text-right font-bold uppercase text-[#64748b]">Value</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="(asset, i) in assets" :key="i" :class="i % 2 === 0 ? 'bg-white' : 'bg-[#f8fafc]'">
            <td class="border border-[#e2e8f0] px-2 py-1 font-mono">{{ asset.asset_number }}</td>
            <td class="border border-[#e2e8f0] px-2 py-1 font-mono">{{ asset.serial_number }}</td>
            <td class="border border-[#e2e8f0] px-2 py-1">{{ asset.type }}</td>
            <td class="border border-[#e2e8f0] px-2 py-1">{{ asset.brand }}</td>
            <td class="border border-[#e2e8f0] px-2 py-1">{{ asset.model }}</td>
            <td class="border border-[#e2e8f0] px-2 py-1">{{ asset.condition }}</td>
            <td class="border border-[#e2e8f0] px-2 py-1 text-right font-mono">{{ asset.value }}</td>
          </tr>
        </tbody>
      </table>
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
