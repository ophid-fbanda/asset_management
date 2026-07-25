<script setup>
import { computed, ref } from 'vue'
import logo from '@/assets/logo.png'
import { exportToPDF } from '@/api/exportx'

defineProps({
  title: { type: String, required: true },
  refCode: { type: String, default: '' },
  meta: { type: Array, default: () => [] },
  rows: { type: Array, default: () => [] },
  columns: { type: Array, default: () => [] },
  sectionTitle: { type: String, default: 'Records' },
  /** Logged-in user who ran the report */
  preparedBy: { type: String, default: '' },
  /** Selected staff — name shown; Signature & Date left blank for wet ink */
  acknowledgedBy: { type: String, default: '' },
})

const docEl = ref(null)

const preparedDate = computed(() => {
  const d = new Date()
  const dd = String(d.getDate()).padStart(2, '0')
  const mm = String(d.getMonth() + 1).padStart(2, '0')
  const yyyy = d.getFullYear()
  return `${dd}/${mm}/${yyyy}`
})

const save = (filename, layout = 'landscape') =>
  exportToPDF(docEl.value, filename, layout, 'a4')

defineExpose({ save })
</script>

<template>
  <div
    ref="docEl"
    class="w-[297mm] min-h-[210mm] overflow-hidden border border-[#e2e8f0] bg-white text-[11px] text-[#0f172a]"
  >
    <div class="flex items-center justify-between gap-6 border-b border-[#384884] px-[18mm] pt-[10mm] pb-4">
      <img :src="logo" alt="Logo" class="h-12 w-auto object-contain" />
      <div class="flex flex-col items-center text-center">
        <span class="text-[13px] font-black tracking-tight text-[#384884] uppercase">{{ title }}</span>
        <span class="mt-0.5 text-[9px] tracking-widest text-[#64748b] uppercase">Assets Management System</span>
      </div>
      <div class="flex min-w-[9rem] flex-col items-center border border-[#384884] px-4 py-2 text-center">
        <span class="font-mono text-[10px] font-black text-[#0f172a]">{{ refCode || '—' }}</span>
      </div>
    </div>

    <div class="px-[18mm] py-[10mm]">
      <div v-if="meta.length" class="mb-8 grid grid-cols-3 gap-x-8 gap-y-3">
        <div
          v-for="(item, idx) in meta"
          :key="`${item.label}-${idx}`"
          class="flex flex-col gap-0.5 border-b border-[#e2e8f0] pb-1.5"
          :class="item.span === 2 ? 'col-span-2' : item.span === 3 ? 'col-span-3' : ''"
        >
          <span class="text-[8px] font-bold tracking-widest text-[#384884] uppercase">{{ item.label }}</span>
          <span class="font-semibold">{{ item.value || '—' }}</span>
        </div>
      </div>

      <p class="mb-3 text-[8px] font-bold tracking-widest text-[#384884] uppercase">{{ sectionTitle }}</p>

      <table v-if="rows.length && columns.length" class="w-full border-collapse text-left">
        <thead>
          <tr class="border-b border-[#384884]">
            <th
              v-for="col in columns"
              :key="col.field"
              class="px-1.5 py-2 text-[8px] font-bold tracking-wide text-[#384884] uppercase"
            >
              {{ col.header }}
            </th>
          </tr>
        </thead>
        <tbody>
          <tr
            v-for="(row, rIdx) in rows"
            :key="row.entity_id ?? rIdx"
            class="border-b border-[#e2e8f0]"
          >
            <td
              v-for="col in columns"
              :key="col.field"
              class="px-1.5 py-1.5 align-top text-[10px]"
            >
              {{ row[col.field] ?? '' }}
            </td>
          </tr>
        </tbody>
      </table>
      <p v-else class="text-[10px] text-[#64748b]">No records.</p>

      <div
        v-if="preparedBy || acknowledgedBy"
        class="mt-10 flex flex-col gap-8 border-t border-[#e2e8f0] pt-8"
      >
        <p class="text-[8px] font-bold tracking-widest text-[#384884] uppercase">Acknowledgement</p>
        <div class="flex gap-12">
          <div v-if="preparedBy" class="flex flex-1 flex-col gap-3">
            <span class="text-[8px] font-bold tracking-widest text-[#64748b] uppercase">Prepared by</span>
            <div class="flex min-h-[2.5rem] items-end justify-between border-b border-[#94a3b8] pb-1">
              <span class="text-[12px] font-semibold">{{ preparedBy }}</span>
              <span class="text-[10px] font-semibold">{{ preparedDate }}</span>
            </div>
          </div>
          <div v-if="acknowledgedBy" class="flex flex-1 flex-col gap-3">
            <span class="text-[8px] font-bold tracking-widest text-[#64748b] uppercase">{{ acknowledgedBy }}</span>
            <div class="flex min-h-[2.5rem] items-end justify-between border-b border-[#94a3b8] pb-1">
              <span class="text-[8px] text-[#64748b]">Signature</span>
              <span class="text-[8px] text-[#64748b]">Date</span>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>
