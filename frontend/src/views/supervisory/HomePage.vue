<script setup>
import { computed, reactive, watch } from 'vue'
import { Select } from 'primevue'
import { arrayFilter, objectFirstId, objectSet } from '@/api/objectx'
import { dataToCache, dataFromProfile } from '@/api/datax'
import PendingApprovals from '@/views/supervisory/PendingApprovals.vue'
import ApprovalsHistory from '@/views/supervisory/ApprovalsHistory.vue'

const ROLE_TYPE_ID = 40

const menuItems = [
  { id: 'pending', label: 'Pending', icon: 'pi-inbox', view: PendingApprovals },
  { id: 'history', label: 'History', icon: 'pi-history', view: ApprovalsHistory },
]

const ui = reactive({
  menuItemId: 'pending',
  stationId: null,
})

const activeView = computed(() => menuItems.find((item) => item.id === ui.menuItemId)?.view)

const profile = dataFromProfile()

const stationOptions = computed(() =>
  arrayFilter(profile.value?.roles, 'roleTypeId', [ROLE_TYPE_ID]).map((role) => ({
    id: role.stationId,
    name: role.stationName,
  })),
)

const onStationChange = () => {
  dataToCache(`role/${ROLE_TYPE_ID}`, ui.stationId)
}

// Set station during setup so Pending/History never fetch role/40 as undefined.
watch(
  stationOptions,
  (opts) => {
    if (ui.stationId != null || !opts?.length) return
    ui.stationId = objectFirstId(opts)
    if (ui.stationId) onStationChange()
  },
  { immediate: true },
)

const menuBtnClass = (id) => [
  'inline-flex shrink-0 items-center justify-center gap-1.5 rounded-md border px-3 py-2 text-xs font-semibold uppercase tracking-wide whitespace-nowrap transition-colors',
  ui.menuItemId === id
    ? 'border-[#5b6aa1] bg-[#5b6aa1] text-white [&_i]:text-white'
    : 'border-white/15 bg-white/5 text-[#a0a9ca] [&_i]:text-[#a0a9ca] hover:border-white/25 hover:bg-white/10 hover:text-white hover:[&_i]:text-white',
]
</script>

<template>
  <div class="flex min-h-0 flex-1 flex-col overflow-hidden rounded-xl border border-[#c5cce3] shadow-sm">
    <header class="flex shrink-0 items-center gap-4 bg-[#384884] px-3 py-2.5 sm:px-4">
      <Select
        v-if="stationOptions.length"
        v-model="ui.stationId"
        :options="stationOptions"
        option-label="name"
        option-value="id"
        placeholder="Station"
        size="small"
        class="w-44 shrink-0"
        @change="onStationChange"
      />
      <h1 class="shrink-0 text-sm font-bold whitespace-nowrap text-white sm:text-base">
        Supervisory
      </h1>
      <nav
        class="no-scrollbar flex flex-1 items-center justify-start gap-1.5 overflow-x-auto lg:justify-end"
        aria-label="Supervisory sections"
      >
        <button
          v-for="item in menuItems"
          :key="item.id"
          type="button"
          :class="menuBtnClass(item.id)"
          :title="item.label"
          @click="objectSet(ui, 'menuItemId', item.id)"
        >
          <i class="pi text-sm" :class="item.icon" />
          <span>{{ item.label }}</span>
        </button>
      </nav>
    </header>

    <main class="flex min-h-0 flex-1 flex-col overflow-hidden bg-white p-4 sm:p-6">
      <component :is="activeView" />
    </main>
  </div>
</template>

<style scoped>
.no-scrollbar {
  -ms-overflow-style: none;
  scrollbar-width: none;
}
.no-scrollbar::-webkit-scrollbar {
  display: none;
}
</style>
