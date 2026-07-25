<script setup>
import { computed, onMounted, reactive, watch } from 'vue'
import { Password, Select } from 'primevue'
import { objectComplete, objectReset, objectResetSet, objectSet } from '@/api/objectx'
import { dataFetchToCache, dataFromCache, dataPatchCache, dataSend } from '@/api/datax'

const LIST_KEY = 'users/staff'
const GENERAL_USER_ROLE_TYPE_ID = 10

const props = defineProps({
  // Same row shape the staff list would feed a DataTable.
  staff: { type: Object, required: true },
})

const roleTypes = dataFromCache('meta/role_types')
const stations = dataFromCache('meta/stations')

const form = reactive({
  roleTypeId: null,
  stationId: null,
})

const home = reactive({
  stationId: null,
})

const passwordForm = reactive({
  password: null,
})

const ui = reactive({
  busy: null,
  error: null,
  success: null,
})

const roles = computed(() => props.staff?.roles ?? [])

// General User is baseline existence (auto-provisioned) — never offered as a role.
const assignableRoleTypes = computed(() =>
  (roleTypes.value ?? []).filter((role) => role.id !== GENERAL_USER_ROLE_TYPE_ID),
)

const homeDirty = computed(() => {
  if (home.stationId == null) return false
  return Number(home.stationId) !== Number(props.staff?.home_station_id)
})

watch(
  () => props.staff?.home_station_id,
  (value) => { home.stationId = value != null ? Number(value) : null },
  { immediate: true },
)

const patchSelf = () =>
  dataPatchCache(`users/staff/${props.staff.entity_id}`, LIST_KEY)

const submitForm = async () => {
  if (!objectComplete(form)) {
    objectResetSet(ui, 'error', 'Select a role and station.')
    return
  }
  objectResetSet(ui, 'busy', true)
  const response = await dataSend(`users/staff/${props.staff.entity_id}/roles`, {
    roleTypeId: form.roleTypeId,
    stationId: form.stationId,
  })
  if (response.status === 200) {
    objectReset(form)
    objectSet(ui, 'error', null)
    await patchSelf()
  } else {
    objectSet(ui, 'error', response.data)
  }
  objectSet(ui, 'busy', null)
}

const updateHomeStation = async () => {
  if (home.stationId == null) {
    objectResetSet(ui, 'error', 'Select a home station.')
    return
  }
  objectResetSet(ui, 'busy', true)
  const response = await dataSend(`users/staff/${props.staff.entity_id}/home-station`, {
    stationId: Number(home.stationId),
  })
  if (response.status === 200) {
    objectSet(ui, 'error', null)
    await patchSelf()
  } else {
    objectSet(ui, 'error', response.data)
  }
  objectSet(ui, 'busy', null)
}

const removeRole = async (instanceId) => {
  objectResetSet(ui, 'busy', true)
  const response = await dataSend('users/roles/remove', { instanceId })
  if (response.status === 200) {
    objectSet(ui, 'error', null)
    await patchSelf()
  } else {
    objectSet(ui, 'error', response.data)
  }
  objectSet(ui, 'busy', null)
}

const resetPassword = async () => {
  if (!passwordForm.password || String(passwordForm.password).length < 4) {
    objectResetSet(ui, 'error', 'Password must be at least 4 characters.')
    return
  }
  objectResetSet(ui, 'busy', true)
  const response = await dataSend(`users/staff/${props.staff.entity_id}/password`, {
    password: passwordForm.password,
  })
  if (response.status === 200) {
    objectReset(passwordForm)
    objectResetSet(ui, 'success', 'Password reset.')
  } else {
    objectResetSet(ui, 'error', response.data)
  }
}

onMounted(() => {
  dataFetchToCache('meta/role_types')
  dataFetchToCache('meta/stations')
})
</script>

<template>
  <article class="flex flex-col gap-4 border border-[#c5cce3] bg-white p-4 shadow-sm">
    <header class="border-b border-[#e4e9f4] pb-3">
      <h3 class="text-base font-semibold text-[#384884]">{{ staff.full_name }}</h3>
      <p class="mt-1 text-sm text-slate-600">{{ staff.staff_email }}</p>
      <p class="text-sm text-slate-500">{{ staff.staff_phone }}</p>
    </header>

    <section class="flex flex-col gap-2">
      <h4 class="text-[11px] font-bold uppercase tracking-widest text-[#5b6aa1]">Home station</h4>
      <div class="flex gap-2">
        <Select
          v-model="home.stationId"
          :options="stations ?? []"
          option-label="station_name"
          option-value="id"
          placeholder="Home station"
          filter
          size="small"
          class="min-w-0 flex-1"
        />
        <button
          type="button"
          :disabled="!!ui.busy || !homeDirty"
          class="shrink-0 cursor-pointer border border-[#384884] bg-[#e8eefa] px-3 py-2 text-xs font-semibold text-[#384884] transition hover:bg-[#384884] hover:text-white disabled:cursor-not-allowed disabled:opacity-40"
          @click="updateHomeStation"
        >
          Update
        </button>
      </div>
    </section>

    <section class="flex flex-col gap-2">
      <div class="flex items-baseline justify-between gap-2">
        <h4 class="text-[11px] font-bold uppercase tracking-widest text-[#5b6aa1]">Roles</h4>
        <span class="text-[11px] font-semibold text-slate-400">{{ roles.length }}</span>
      </div>

      <ul v-if="roles.length" class="flex flex-col gap-1.5">
        <li
          v-for="role in roles"
          :key="role.instanceId"
          class="flex items-center justify-between gap-2 border border-[#e4e9f4] bg-[#f8fafd] px-2.5 py-2"
        >
          <div class="min-w-0">
            <p class="truncate text-sm font-medium text-slate-800">{{ role.roleTypeName }}</p>
            <p class="truncate text-xs text-slate-500">{{ role.stationName }}</p>
          </div>
          <button
            type="button"
            :disabled="!!ui.busy"
            class="flex size-7 shrink-0 cursor-pointer items-center justify-center border border-[#c5cce3] text-slate-500 transition hover:border-red-300 hover:bg-red-50 hover:text-red-600 disabled:cursor-not-allowed disabled:opacity-40"
            title="Remove role"
            @click="removeRole(role.instanceId)"
          >
            <i class="pi pi-times text-xs" />
          </button>
        </li>
      </ul>
      <p v-else class="text-sm text-slate-400">No roles assigned.</p>
    </section>

    <section class="flex flex-col gap-2 border-t border-[#e4e9f4] pt-3">
      <h4 class="text-[11px] font-bold uppercase tracking-widest text-[#5b6aa1]">Reset password</h4>
      <div class="flex gap-2">
        <Password
          v-model="passwordForm.password"
          :feedback="false"
          toggle-mask
          placeholder="New password"
          class="min-w-0 flex-1"
          input-class="w-full"
          size="small"
        />
        <button
          type="button"
          :disabled="!!ui.busy"
          class="shrink-0 cursor-pointer border border-[#384884] bg-[#e8eefa] px-3 py-2 text-xs font-semibold text-[#384884] transition hover:bg-[#384884] hover:text-white disabled:cursor-not-allowed disabled:opacity-40"
          @click="resetPassword"
        >
          Reset
        </button>
      </div>
      <p v-if="ui.success" class="text-xs text-emerald-600">{{ ui.success }}</p>
    </section>

    <section class="flex flex-col gap-2 border-t border-[#e4e9f4] pt-3">
      <h4 class="text-[11px] font-bold uppercase tracking-widest text-[#5b6aa1]">Add role</h4>
      <div class="flex flex-col gap-2">
        <Select
          v-model="form.roleTypeId"
          :options="assignableRoleTypes"
          option-label="name"
          option-value="id"
          placeholder="Role type"
          filter
          size="small"
          class="w-full"
        />
        <Select
          v-model="form.stationId"
          :options="stations ?? []"
          option-label="station_name"
          option-value="id"
          placeholder="Station"
          filter
          size="small"
          class="w-full"
        />
        <button
          type="button"
          :disabled="!!ui.busy"
          class="flex cursor-pointer items-center justify-center gap-2 border border-[#384884] bg-[#384884] px-3 py-2 text-xs font-semibold text-white transition hover:bg-[#5b6aa1] disabled:cursor-not-allowed disabled:opacity-40"
          @click="submitForm"
        >
          <i class="pi pi-plus text-xs" />
          <span>{{ ui.busy ? 'Saving…' : 'Add role' }}</span>
        </button>
        <p v-if="ui.error" class="text-xs text-red-500">{{ ui.error }}</p>
      </div>
    </section>
  </article>
</template>
