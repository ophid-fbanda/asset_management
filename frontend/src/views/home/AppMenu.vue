<script setup>
import { computed } from 'vue'
import { RouterLink } from 'vue-router'
import { dataFromProfile } from '@/api/datax'

const profile = dataFromProfile()

const roleTypeIds = computed(() => {
  const roles = profile.value?.roles ?? []
  return [...new Set(roles.map((role) => role.roleTypeId))]
})

const hasRole = (id) => roleTypeIds.value.includes(id)

// roles 20, 40, 50 are mutually exclusive — if 20 then assets-admin, else if 40 then supervisory approvals, else if 50 then management approvals
const primaryRole = computed(() => [20, 40, 50].find((id) => roleTypeIds.value.includes(id)) ?? null)

const menuLinkClass =
  'group relative flex items-center gap-3 rounded-lg px-3.5 py-2.5 text-sm leading-5 text-[#aab4d4] no-underline transition-all duration-150 [&_i]:text-[#8f9bc4] [&_i]:text-[0.95rem] hover:bg-white/10 hover:text-white hover:[&_i]:text-white'

const menuLinkActiveClass =
  'bg-white/12 font-semibold text-white [&_i]:text-white before:absolute before:left-0 before:top-1/2 before:h-6 before:w-[3px] before:-translate-y-1/2 before:rounded-r-full before:bg-white'
</script>

<template>
  <nav class="flex flex-col gap-1">
    <template v-if="hasRole(10)">
      <RouterLink to="/" :class="menuLinkClass" :active-class="menuLinkActiveClass">
        <i class="pi pi-home" />
        <span>Home</span>
      </RouterLink>
      <RouterLink to="/reports" :class="menuLinkClass" :active-class="menuLinkActiveClass">
        <i class="pi pi-chart-bar" />
        <span>Reports</span>
      </RouterLink>
    </template>

    <RouterLink v-if="hasRole(20)" to="/assets-admin" :class="menuLinkClass" :active-class="menuLinkActiveClass">
      <i class="pi pi-database" />
      <span>Assets Admin</span>
    </RouterLink>

    <RouterLink v-if="hasRole(40)" to="/supervisory" :class="menuLinkClass" :active-class="menuLinkActiveClass">
      <i class="pi pi-check-circle" />
      <span>Supervisory</span>
    </RouterLink>

    <RouterLink v-if="hasRole(50)" to="/management" :class="menuLinkClass" :active-class="menuLinkActiveClass">
      <i class="pi pi-verified" />
      <span>Management</span>
    </RouterLink>

    <RouterLink v-if="hasRole(60)" to="/audits" :class="menuLinkClass" :active-class="menuLinkActiveClass">
      <i class="pi pi-search" />
      <span>Audits</span>
    </RouterLink>

    <RouterLink v-if="hasRole(70)" to="/users" :class="menuLinkClass" :active-class="menuLinkActiveClass">
      <i class="pi pi-users" />
      <span>Users</span>
    </RouterLink>

    <RouterLink v-if="hasRole(80)" to="/system" :class="menuLinkClass" :active-class="menuLinkActiveClass">
      <i class="pi pi-cog" />
      <span>System</span>
    </RouterLink>
  </nav>
</template>
