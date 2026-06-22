<script setup>
import { computed } from 'vue'
import { RouterLink } from 'vue-router'
import { dataFromProfile } from '@/api/datax'

const profile = dataFromProfile()

const roleTypeIds = computed(() => {
  const roles = profile.value?.roles ?? []
  return [...new Set(roles.map((role) => role.roleTypeId))]
})

// role 10 is always present; all other roles are mutually exclusive — pick the first one found
const activeRole = computed(() => roleTypeIds.value.find((id) => id !== 10) ?? null)

const menuLinkClass =
  'flex items-center gap-2.5 rounded-lg px-3.5 py-2.5 text-sm leading-5 text-[#a0a9ca] no-underline transition [&_i]:text-[#a0a9ca] hover:bg-white/10 hover:text-white hover:[&_i]:text-white'

const menuLinkActiveClass = 'bg-[#5b6aa1] font-semibold text-white [&_i]:text-white'
</script>

<template>
  <nav class="flex flex-col gap-1">
    <template v-if="hasRole(10)">
      <RouterLink to="/" :class="menuLinkClass" :active-class="menuLinkActiveClass">
        <i class="pi pi-home" />
        <span>Home</span>
      </RouterLink>
      <RouterLink to="/my-assets" :class="menuLinkClass" :active-class="menuLinkActiveClass">
        <i class="pi pi-box" />
        <span>My Assets</span>
      </RouterLink>
      <RouterLink to="/reports" :class="menuLinkClass" :active-class="menuLinkActiveClass">
        <i class="pi pi-chart-bar" />
        <span>Reports</span>
      </RouterLink>
    </template>

    <RouterLink v-if="activeRole === 20" to="/assets-admin" :class="menuLinkClass" :active-class="menuLinkActiveClass">
      <i class="pi pi-database" />
      <span>Assets Admin</span>
    </RouterLink>

    <RouterLink v-if="activeRole === 40 || activeRole === 50" to="/approvals" :class="menuLinkClass" :active-class="menuLinkActiveClass">
      <i class="pi pi-check-circle" />
      <span>Approvals</span>
    </RouterLink>

    <RouterLink v-if="activeRole === 60" to="/audits" :class="menuLinkClass" :active-class="menuLinkActiveClass">
      <i class="pi pi-search" />
      <span>Audits</span>
    </RouterLink>

    <RouterLink v-if="activeRole === 70" to="/users" :class="menuLinkClass" :active-class="menuLinkActiveClass">
      <i class="pi pi-users" />
      <span>Users</span>
    </RouterLink>

    <RouterLink v-if="activeRole === 80" to="/system" :class="menuLinkClass" :active-class="menuLinkActiveClass">
      <i class="pi pi-cog" />
      <span>System</span>
    </RouterLink>
  </nav>
</template>
