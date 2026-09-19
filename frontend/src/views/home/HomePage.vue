<script setup>
import { computed, reactive } from 'vue'
import { objectSet } from '@/api/objectx'
import DashboardView from '@/views/home/DashboardView.vue'
import AssetsView from '@/views/home/AssetsView.vue'
import AssignmentsView from '@/views/home/AssignmentsView.vue'
import IncidentsView from '@/views/home/IncidentsView.vue'

const menuItems = [
  { id: 'dashboard', label: 'Dashboard', icon: 'pi-chart-pie' },
  { id: 'assets', label: 'Assets', icon: 'pi-box' },
  { id: 'assignments', label: 'Assignments', icon: 'pi-inbox' },
  { id: 'incidents', label: 'Incidents', icon: 'pi-exclamation-triangle' },
]

const sectionViews = {
  dashboard: DashboardView,
  assets: AssetsView,
  assignments: AssignmentsView,
  incidents: IncidentsView,
}

const ui = reactive({
  menuItemId: 'dashboard',
})

const activeView = computed(() => sectionViews[ui.menuItemId])

const menuBtnClass = (id) => [
  'inline-flex shrink-0 items-center justify-center gap-1.5 rounded-lg border px-3 py-2 text-xs font-semibold uppercase tracking-wide whitespace-nowrap transition-all duration-150',
  ui.menuItemId === id
    ? 'border-transparent bg-white text-[#384884] shadow-sm [&_i]:text-[#384884]'
    : 'border-white/15 bg-white/5 text-[#aab4d4] [&_i]:text-[#aab4d4] hover:border-white/25 hover:bg-white/10 hover:text-white hover:[&_i]:text-white',
]
</script>

<template>
  <div class="flex min-h-0 flex-1 flex-col overflow-hidden rounded-2xl border border-[#dbe1f0] shadow-[0_1px_2px_rgb(15_23_42/0.04),0_12px_30px_rgb(15_23_42/0.06)]">
    <header class="flex shrink-0 items-center gap-4 bg-gradient-to-r from-[#384884] to-[#2d3a6b] px-3 py-2.5 sm:px-4">
      <h1 class="shrink-0 text-sm font-bold whitespace-nowrap text-white sm:text-base">
        Home
      </h1>
      <nav
        class="no-scrollbar flex flex-1 items-center justify-start gap-1.5 overflow-x-auto lg:justify-end"
        aria-label="Home sections"
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
