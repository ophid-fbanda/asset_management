<script setup>
defineProps({
  options: {
    type: Array,
    required: true,
  },
})

const model = defineModel({
  type: String,
  required: true,
})
</script>

<template>
  <div
    class="inline-grid min-w-[16.5rem] grid-cols-2 gap-1 rounded-md border border-[#c5cce3] bg-[#e8eefa] p-1"
    role="tablist"
    aria-label="Register view switch"
  >
    <button
      v-for="option in options"
      :key="option.value"
      type="button"
      role="tab"
      :aria-selected="model === option.value"
      :title="`Show ${option.label.toLowerCase()}`"
      class="grid w-full cursor-pointer grid-cols-[1rem_1fr] items-center gap-2.5 rounded-[0.3125rem] px-4 py-1.5 text-left text-[0.6875rem] font-semibold uppercase tracking-[0.06em] transition-all duration-200"
      :class="
        model === option.value
          ? 'bg-white text-[#384884] shadow-[0_1px_4px_rgba(56,72,132,0.14)]'
          : 'bg-transparent text-[#5b6aa1] hover:bg-white/50 hover:text-[#384884]'
      "
      @click="model = option.value"
    >
      <i
        class="pi shrink-0 text-sm leading-none transition-colors duration-200"
        :class="
          model === option.value
            ? 'pi-check-circle text-[#384884]'
            : 'pi-circle text-[#a0a9ca]'
        "
        aria-hidden="true"
      />
      <span>{{ option.label }}</span>
    </button>
  </div>
</template>
