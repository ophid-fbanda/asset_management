<script setup>
import { computed, reactive, watch } from 'vue'
import { Select } from 'primevue'
import { arrayFilter, objectFirstId, objectSet } from '@/api/objectx'
import { dataToCache, dataFromProfile } from '@/api/datax'
import RegistrationsView from '@/views/asset-admin/RegistrationsView.vue'
import AssetsView from '@/views/asset-admin/AssetsView.vue'
import IncomingView from '@/views/asset-admin/IncomingView.vue'
import RequisitionsView from '@/views/asset-admin/RequisitionsView.vue'
import IncidentsView from '@/views/asset-admin/IncidentsView.vue'
import ChangesView from '@/views/asset-admin/ChangesView.vue'

// role_types.id of the asset-admin role; the user's station bindings for it
// drive the picker, and the chosen station is cached under role/<id>.
const ADMIN_ROLE_TYPE_ID = 20

const menuItems = [
  { id: 'registrations', label: 'Registrations', icon: 'pi-file-plus' },
  { id: 'assets', label: 'Assets', icon: 'pi-box' },
  { id: 'incoming', label: 'Incoming', icon: 'pi-download' },
  { id: 'requisitions', label: 'Requisitions', icon: 'pi-inbox' },
  { id: 'incidents', label: 'Incidents', icon: 'pi-exclamation-triangle' },
  { id: 'changes', label: 'Changes', icon: 'pi-calendar' },
]

const sectionViews = {
  registrations: RegistrationsView,
  assets: AssetsView,
  incoming: IncomingView,
  requisitions: RequisitionsView,
  incidents: IncidentsView,
  changes: ChangesView,
}

const ui = reactive({
  menuItemId: 'assets',
  stationId: null,
})

const activeView = computed(() => sectionViews[ui.menuItemId])

const profile = dataFromProfile()

// Stations the signed-in user administers, taken from their admin-role bindings.
const stationOptions = computed(() =>
  arrayFilter(profile.value?.roles, 'roleTypeId', [ADMIN_ROLE_TYPE_ID]).map((role) => ({
    id: role.stationId,
    name: role.stationName,
  })),
)

const onStationChange = () => {
  dataToCache(`role/${ADMIN_ROLE_TYPE_ID}`, ui.stationId)
}

// Set station during setup (not onMounted) so child views never fetch role/20 as undefined.
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
      <h1 v-else class="shrink-0 text-sm font-bold whitespace-nowrap text-white sm:text-base">
        Assets Administration
      </h1>
      <nav
        class="no-scrollbar flex flex-1 items-center justify-start gap-1.5 overflow-x-auto lg:justify-end"
        aria-label="Assets admin sections"
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
