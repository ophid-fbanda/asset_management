<script setup>
import { computed } from 'vue'
import { Dialog, Message } from 'primevue'
import { objectSet } from '@/api/objectx'

const props = defineProps({
  ui: {
    type: Object,
    required: true,
  },
  popup: {
    type: Boolean,
    default: false,
  },
})

// One entry per feedback channel on the ui bundle, mapped to a PrimeVue Message
// severity. busy is service-driven only, so it carries no close affordance.
// Array order doubles as display precedence.
const KINDS = {
  busy: { label: 'Working…', severity: 'warn', closable: false },
  error: { label: 'Something went wrong', severity: 'error', closable: true },
  success: { label: 'Done', severity: 'info', closable: true },
  file: { label: 'File ready', severity: 'secondary', closable: true },
}

const ORDER = ['busy', 'error', 'success', 'file']

const active = computed(() => {
  const key = ORDER.find((k) => props.ui[k] != null)
  if (!key) return null

  const value = props.ui[key]
  return {
    key,
    ...KINDS[key],
    body: typeof value === 'string' ? value : '',
  }
})

const close = () => {
  if (active.value?.closable) {
    objectSet(props.ui, active.value.key, null)
  }
}
</script>

<template>
  <!-- POPUP: modal dialog, blocks interaction until cleared -->
  <Dialog
    v-if="popup"
    :visible="!!active"
    modal
    :closable="false"
    :draggable="false"
    :style="{ width: 'min(92vw, 24rem)' }"
    :pt="{
      mask: { class: 'bg-slate-900/40' },
      root: { class: '!border-0 !bg-transparent !shadow-none' },
      content: { class: '!p-0' },
    }"
  >
    <Message
      v-if="active"
      :severity="active.severity"
      :closable="active.closable"
      class="!m-0"
      @close="close"
    >
      <span class="font-medium">{{ active.label }}</span>
      <span v-if="active.body"> — {{ active.body }}</span>
    </Message>
  </Dialog>

  <!-- MESSAGE: inline strip, sits wherever placed (e.g. a form footer) -->
  <Message
    v-else-if="active"
    :severity="active.severity"
    :closable="active.closable"
    size="small"
    class="!my-0"
    @close="close"
  >
    {{ active.body || active.label }}
  </Message>
</template>
