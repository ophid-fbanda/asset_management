<script setup>
import { computed, reactive } from 'vue'
import { objectSet } from '@/api/objectx'
import CurrentStateView from '@/views/reports/CurrentStateView.vue'
import PeriodicView from '@/views/reports/PeriodicView.vue'
import ProfileView from '@/views/reports/ProfileView.vue'

const menuItems = [
  { id: 'current', label: 'Current State Reports', icon: 'pi-sitemap' },
  { id: 'periodic', label: 'Periodic Reports', icon: 'pi-calendar' },
  { id: 'profile', label: 'Profile Reports', icon: 'pi-id-card' },
]

const sectionViews = {
  current: CurrentStateView,
  periodic: PeriodicView,
  profile: ProfileView,
}

const ui = reactive({
  menuItemId: 'current',
})

const activeView = computed(() => sectionViews[ui.menuItemId])

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
      <h1 class="shrink-0 text-sm font-bold whitespace-nowrap text-white sm:text-base">
        Reports
      </h1>
      <nav
        class="no-scrollbar flex flex-1 items-center justify-start gap-1.5 overflow-x-auto lg:justify-end"
        aria-label="Report sections"
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
          <span class="hidden sm:inline">{{ item.label }}</span>
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
