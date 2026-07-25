<script setup>
import { IconField, InputIcon, InputText } from 'primevue'
import { RouterLink } from 'vue-router'
import logoUrl from '@/assets/logo.png'
import AppMenu from '@/views/home/AppMenu.vue'
import { dataSearchModel, dataFromProfile, dataSignOut } from '@/api/datax'

const profile = dataFromProfile()

// Shared search term in the store; any view can read it via dataSearchModel().
const searchQuery = dataSearchModel()
</script>

<template>
  <div class="flex h-screen flex-col overflow-hidden font-sans antialiased">
    <input id="nav-toggle" type="checkbox" class="peer sr-only" />

    <header class="flex shrink-0 items-center justify-between border-b border-surface-200 bg-white px-4 py-3 sm:px-6">
      <div class="flex items-center gap-3">
        <label
          for="nav-toggle"
          class="flex h-10 w-10 cursor-pointer items-center justify-center rounded-lg border border-surface-300 bg-surface-50 text-[#384884] transition hover:border-[#5b6aa1] hover:bg-[#e8eefa] md:hidden"
          aria-label="Open menu"
        >
          <i class="pi pi-bars" />
        </label>
        <img :src="logoUrl" alt="OPHID" class="h-9 w-auto shrink-0 object-contain" />
        <span class="hidden text-sm font-normal tracking-wide text-[#384884] uppercase sm:inline lg:text-base">
          Asset Management System
        </span>
      </div>

      <div class="flex items-center gap-2 sm:gap-3">
        <div class="hidden md:block">
          <IconField>
            <InputIcon class="pi pi-search text-[#5b6aa1]" />
            <InputText
              v-model="searchQuery"
              type="text"
              placeholder="Search..."
              class="min-h-10 w-56 lg:w-72"
            />
          </IconField>
        </div>

        <button
          type="button"
          class="relative flex h-10 w-10 cursor-pointer items-center justify-center rounded-full border border-surface-300 bg-surface-50 text-[#384884] transition hover:border-[#5b6aa1] hover:bg-[#e8eefa]"
          aria-label="Notifications"
        >
          <i class="pi pi-bell" />
          <span class="absolute top-2 right-2 h-2 w-2 rounded-full bg-red-500 ring-2 ring-white" />
        </button>

        <div v-if="profile" class="group relative">
          <button
            type="button"
            class="flex h-10 w-10 cursor-pointer items-center justify-center rounded-full bg-[#384884] text-white transition hover:bg-[#5b6aa1] group-focus-within:bg-[#5b6aa1]"
            :aria-label="profile.name"
            aria-haspopup="true"
          >
            <i class="pi pi-user" />
          </button>

          <div
            class="invisible absolute top-full right-0 z-50 min-w-44 pt-2 opacity-0 transition group-hover:visible group-hover:opacity-100 group-focus-within:visible group-focus-within:opacity-100"
          >
            <div
              class="rounded-xl border border-surface-200 bg-surface-0 p-1.5 shadow-[0_10px_15px_-3px_rgb(0_0_0/0.08),0_4px_6px_-4px_rgb(0_0_0/0.08)]"
              role="menu"
            >
              <div class="border-b border-surface-200 px-3 py-2">
                <p class="truncate text-sm font-medium text-surface-800">{{ profile.name }}</p>
              </div>
              <RouterLink
                to="/account"
                class="mt-1 flex items-center gap-2.5 rounded-lg px-3 py-2.5 text-sm leading-5 text-surface-700 no-underline transition hover:bg-surface-100 hover:text-surface-900"
                role="menuitem"
              >
                <i class="pi pi-id-card" />
                <span>My Account</span>
              </RouterLink>
              <button
                type="button"
                class="flex w-full cursor-pointer items-center gap-2.5 rounded-lg border-0 bg-transparent px-3 py-2.5 text-sm leading-5 text-surface-700 transition hover:bg-red-50 hover:text-red-600"
                role="menuitem"
                @click="dataSignOut('auth/logout')"
              >
                <i class="pi pi-sign-out" />
                <span>Logout</span>
              </button>
            </div>
          </div>
        </div>
      </div>
    </header>

    <div class="shrink-0 border-b border-surface-200 bg-white px-4 py-2 md:hidden">
      <IconField class="w-full">
        <InputIcon class="pi pi-search text-[#5b6aa1]" />
        <InputText
          v-model="searchQuery"
          type="text"
          placeholder="Search..."
          class="min-h-10 w-full"
        />
      </IconField>
    </div>

    <label
      for="nav-toggle"
      class="fixed inset-0 z-40 bg-slate-900/45 opacity-0 invisible transition peer-checked:visible peer-checked:opacity-100 md:hidden"
      aria-label="Close menu"
    />

    <aside
      class="fixed top-0 left-0 z-50 flex h-full w-[min(18rem,88vw)] -translate-x-full flex-col bg-[#384884] shadow-2xl transition-transform peer-checked:translate-x-0 md:hidden"
    >
      <div class="flex items-center justify-between border-b border-white/10 p-4">
        <p class="text-xs font-semibold tracking-[0.2em] text-[#a0a9ca] uppercase">Menu</p>
        <label
          for="nav-toggle"
          class="flex h-8 w-8 cursor-pointer items-center justify-center rounded-md text-[#a0a9ca] transition hover:bg-white/10 hover:text-white"
          aria-label="Close menu"
        >
          <i class="pi pi-times" />
        </label>
      </div>
      <div class="overflow-y-auto p-4">
        <AppMenu />
      </div>
    </aside>

    <div class="flex min-h-0 flex-1">
      <aside class="hidden w-56 shrink-0 bg-[#384884] md:block">
        <div class="p-4">
          <p class="mb-3 text-xs font-semibold tracking-[0.2em] text-[#a0a9ca] uppercase">Menu</p>
          <AppMenu />
        </div>
      </aside>

      <main class="flex min-h-0 flex-1 flex-col overflow-hidden bg-[#e8eefa] p-4 sm:p-6">
        <slot />
      </main>
    </div>
  </div>
</template>
