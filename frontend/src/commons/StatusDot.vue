<script setup>
import { computed } from 'vue'
import { colorTone } from '@/api/colorx'

const props = defineProps({
  label: { type: [String, Number], default: '' },
  tone: { type: [String, Number], default: 0 },
})

const color = computed(() => colorTone(props.tone))
</script>

<template>
  <span class="inline-flex items-center gap-2 whitespace-nowrap">
    <span
      class="inline-block size-2 shrink-0 rounded-full"
      :style="{
        backgroundColor: color,
        boxShadow: `0 0 0 3px color-mix(in srgb, ${color} 20%, transparent)`,
      }"
      aria-hidden="true"
    />
    <span>{{ label }}</span>
  </span>
</template>
