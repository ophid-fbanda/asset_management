<script setup>
import { computed, onMounted, reactive } from 'vue'
import { Select } from 'primevue'
import { arrayFilter, objectFirstId } from '@/api/objectx'
import { dataFromProfile, dataToCache } from '@/api/datax'
import PendingApprovals from '@/views/management/PendingApprovals.vue'
import ApprovalsHistory from '@/views/management/ApprovalsHistory.vue'

const APPROVAL_ROLE_TYPE_IDS = [40, 50]
const APPROVAL_STATION_KEY = 'role/40'

const menuItems = [
  { id: 'pendingRequests', label: 'Pending Requests', icon: 'pi-inbox', view: PendingApprovals },
  { id: 'approvalHistory', label: 'Approval History', icon: 'pi-history', view: ApprovalsHistory },
]

const ui = reactive({
  menuItemId: 'pendingRequests',
  stationId: null,
})

const activeView = computed(() => menuItems.find((item) => item.id === ui.menuItemId)?.view)

const profile = dataFromProfile()

const stationOptions = computed(() =>
  arrayFilter(profile.value?.roles, 'roleTypeId', APPROVAL_ROLE_TYPE_IDS).map((role) => ({
    id: role.stationId,
    name: role.stationName,
  })),
)

const onStationChange = () => {
  dataToCache(APPROVAL_STATION_KEY, ui.stationId)
}

onMounted(() => {
  ui.stationId = objectFirstId(stationOptions.value)
  if (ui.stationId) onStationChange()
})

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
        Approvals
      </h1>
      <nav
        class="no-scrollbar flex flex-1 items-center justify-start gap-1.5 overflow-x-auto lg:justify-end"
        aria-label="Approval sections"
      >
        <button
          v-for="item in menuItems"
          :key="item.id"
          type="button"
          :class="menuBtnClass(item.id)"
          :title="item.label"
          @click="ui.menuItemId = item.id"
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
