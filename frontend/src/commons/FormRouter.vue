<script setup>
import { computed, onMounted, reactive } from 'vue'
import { Dialog } from 'primevue'
import { objectSet } from '@/api/objectx'
import RegistrationForm from '@/views/asset-admin/forms/RegistrationForm.vue'

const props = defineProps({
  header: {
    type: String,
    default: 'Form',
  },
  options: {
    type: Array,
    default: () => [],
  },
  external: {
    type: String,
    default: null,
  },
  collected: {
    type: Array,
    default: () => [],
  },
})

const emit = defineEmits(['close'])

const ui = reactive({
  leftToggled: null,
})

const context = reactive({
  formId: null,
})

const leftCollapse = computed(
  () =>
    ui.leftToggled ??
    (!props.options?.length || props.options.length <= 1),
)

// An external form takes over: mount it alone, hide the options menu.
const showMenu = computed(() => !props.external && (props.options?.length ?? 0) > 0)

const menuOpen = computed(() => !leftCollapse.value && showMenu.value)

const toggleLeft = () => {
  ui.leftToggled = !leftCollapse.value
}

const selectForm = (id) => {
  objectSet(context, 'formId', id)
}

onMounted(() => {
  if (props.external) {
    selectForm(props.external)
  } else if (props.options?.length === 1) {
    selectForm(props.options[0].id)
  }
})
</script>

<template>
  <Dialog
    :visible="true"
    modal
    maximizable
    :header="header"
    :style="{ width: 'min(96vw, 88rem)', borderRadius: '0.375rem' }"
    content-class="!p-0"
    :draggable="false"
    :pt="{
      mask: { class: 'bg-slate-900/50' },
      root: {
        class: 'overflow-hidden border border-slate-200 bg-white shadow-2xl !rounded-[0.375rem] [&.p-dialog-maximized]:!rounded-none',
        style: { borderRadius: '0.375rem' },
      },
      header: {
        class: 'shrink-0 min-h-0 border-b border-slate-700 bg-slate-800 !px-4 !py-1.5 text-slate-100 !rounded-t-[0.375rem] [.p-dialog-maximized_&]:!rounded-none',
        style: { padding: '0.375rem 1rem', borderRadius: '0.375rem 0.375rem 0 0' },
      },
      title: { class: '!text-sm !font-medium leading-none tracking-wide text-slate-100' },
      headerActions: { class: 'gap-0.5' },
      pcMaximizeButton: {
        root: { class: '!size-7 !min-w-0 !p-0 !text-slate-300 hover:!bg-slate-700 hover:!text-white' },
        icon: { class: '!text-xs' },
      },
      pcCloseButton: {
        root: { class: '!size-7 !min-w-0 !p-0 !text-slate-300 hover:!bg-slate-700 hover:!text-white' },
        icon: { class: '!text-xs' },
      },
      content: {
        class: '!p-0 bg-slate-50 !rounded-b-[0.375rem] [.p-dialog-maximized_&]:!rounded-none',
        style: { borderRadius: '0 0 0.375rem 0.375rem' },
      },
    }"
    @update:visible="emit('close')"
  >
    <div
      class="flex h-[min(85vh,42rem)] min-h-[32rem] w-full bg-slate-50 [.p-dialog-maximized_&]:h-[calc(100dvh-2.5rem)] [.p-dialog-maximized_&]:min-h-0"
    >
      <aside
        class="flex min-w-0 flex-col overflow-hidden border-r border-slate-200 bg-white transition-all duration-200 ease-in-out"
        :class="leftCollapse ? 'w-0 flex-[0_0_0] border-r-0 opacity-0' : 'flex-1 opacity-100'"
      >
        <div class="min-h-0 flex-1 overflow-auto p-4 sm:p-5">
          <slot name="left" />
        </div>
      </aside>

      <aside
        class="flex shrink-0 flex-col border-r border-slate-200 bg-slate-100 py-3 transition-all duration-200 ease-in-out"
        :class="menuOpen ? 'w-44' : 'w-12'"
      >
        <div class="flex justify-start px-2" :class="menuOpen && 'border-b border-[#c5cce3] pb-3'">
          <button
            type="button"
            class="flex size-8 cursor-pointer items-center justify-center rounded-md border border-slate-300 bg-white text-slate-600 transition hover:border-slate-400 hover:bg-slate-200 hover:text-slate-800"
            :aria-label="leftCollapse ? 'Expand left panel' : 'Collapse left panel'"
            @click="toggleLeft"
          >
            <i class="pi text-sm" :class="leftCollapse ? 'pi-angle-right' : 'pi-angle-left'" />
          </button>
        </div>

        <div v-if="menuOpen" class="flex min-h-0 flex-1 flex-col gap-1 overflow-auto px-2 pt-4">
          <button
            v-for="option in options"
            :key="option.id"
            type="button"
            class="group flex w-full cursor-pointer items-center gap-2.5 rounded-md border px-3 py-2.5 text-left text-sm font-medium transition-colors"
            :class="
              context.formId === option.id
                ? 'border-[#384884] bg-[#384884] text-white shadow-sm'
                : 'border-[#a0a9ca] text-slate-600 hover:border-[#5b6aa1] hover:bg-white hover:text-[#384884]'
            "
            @click="selectForm(option.id)"
          >
            <span
              class="flex size-7 shrink-0 items-center justify-center rounded-md transition-colors"
              :class="
                context.formId === option.id
                  ? 'bg-white/15 text-white'
                  : 'bg-white text-[#5b6aa1] group-hover:bg-[#e8eefa]'
              "
            >
              <i :class="['pi text-sm', option.icon || 'pi-file-edit']" />
            </span>
            <span class="min-w-0 flex-1 truncate">{{ option.name }}</span>
          </button>
        </div>
      </aside>

      <aside class="flex min-h-0 min-w-0 flex-1 flex-col overflow-hidden bg-white p-3">
        <RegistrationForm v-if="context.formId === 'regForm'" :collected="collected" />
      </aside>
    </div>
  </Dialog>
</template>
