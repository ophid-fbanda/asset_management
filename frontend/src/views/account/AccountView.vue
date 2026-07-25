<script setup>
import { computed, reactive, watch } from 'vue'
import { Button, InputText, Password } from 'primevue'
import FeedBack from '@/commons/FeedBack.vue'
import { objectReset, objectResetSet, objectSet } from '@/api/objectx'
import { dataFromProfile, dataSend, dataToProfile } from '@/api/datax'

const profile = dataFromProfile()

const contact = reactive({
  email: '',
  phone: '',
})

const passwordForm = reactive({
  currentPassword: null,
  newPassword: null,
  confirmPassword: null,
})

const contactUi = reactive({
  busy: null,
  error: null,
  success: null,
})

const passwordUi = reactive({
  busy: null,
  error: null,
  success: null,
})

const roles = computed(() => profile.value?.roles ?? [])

const homeStation = computed(() => {
  const home = roles.value.find((role) => role.roleTypeId === 10)
  return home?.stationName ?? '—'
})

const assignableRoles = computed(() =>
  roles.value.filter((role) => role.roleTypeId !== 10),
)

watch(
  profile,
  (value) => {
    contact.email = value?.email ?? ''
    contact.phone = value?.phone ?? ''
  },
  { immediate: true },
)

const contactDirty = computed(() =>
  (contact.email ?? '') !== (profile.value?.email ?? '')
  || (contact.phone ?? '') !== (profile.value?.phone ?? ''),
)

const saveContact = async () => {
  objectReset(contactUi)
  if (!contact.email?.trim() || !contact.phone?.trim()) {
    objectSet(contactUi, 'error', 'Email and phone are required.')
    return
  }
  objectSet(contactUi, 'busy', true)
  const response = await dataSend('auth/contact', {
    email: contact.email.trim(),
    phone: contact.phone.trim(),
  })
  if (response.status === 200) {
    dataToProfile(response.data)
    objectResetSet(contactUi, 'success', 'Contact details updated.')
  } else {
    objectSet(contactUi, 'error', response.data)
  }
  objectSet(contactUi, 'busy', null)
}

const changePassword = async () => {
  objectReset(passwordUi)
  if (!passwordForm.currentPassword || !passwordForm.newPassword || !passwordForm.confirmPassword) {
    objectSet(passwordUi, 'error', 'Fill in all password fields.')
    return
  }
  if (passwordForm.newPassword !== passwordForm.confirmPassword) {
    objectSet(passwordUi, 'error', 'New password and confirmation do not match.')
    return
  }
  if (String(passwordForm.newPassword).length < 4) {
    objectSet(passwordUi, 'error', 'New password must be at least 4 characters.')
    return
  }
  objectSet(passwordUi, 'busy', true)
  const response = await dataSend('auth/password', {
    currentPassword: passwordForm.currentPassword,
    newPassword: passwordForm.newPassword,
  })
  if (response.status === 200) {
    objectReset(passwordForm)
    objectResetSet(passwordUi, 'success', 'Password changed.')
  } else {
    objectSet(passwordUi, 'error', response.data)
  }
  objectSet(passwordUi, 'busy', null)
}

const inputPt = {
  root: {
    class:
      'min-h-11 w-full !rounded-md !border-[#c5cce3] !bg-white !text-[#0f172a] focus:!border-[#384884] focus:!shadow-[0_0_0_3px_rgba(56,72,132,0.12)]',
  },
}
</script>

<template>
  <div class="flex min-h-0 flex-1 flex-col overflow-hidden rounded-xl border border-[#c5cce3] bg-white shadow-sm">
    <header class="shrink-0 border-b border-[#e4e9f4] bg-[#f8fafd] px-4 py-4 sm:px-6">
      <h1 class="text-lg font-semibold text-[#384884]">My Account</h1>
      <p class="mt-1 text-sm text-slate-500">Manage your profile details and login password.</p>
    </header>

    <div class="min-h-0 flex-1 overflow-y-auto p-4 sm:p-6">
      <div class="mx-auto grid max-w-5xl gap-6 lg:grid-cols-2">
        <!-- Identity -->
        <section class="rounded-lg border border-[#d5dceb] bg-white p-5 sm:p-6">
          <h2 class="text-sm font-bold tracking-wide text-[#384884] uppercase">Profile</h2>
          <dl class="mt-5 grid gap-4 sm:grid-cols-2">
            <div>
              <dt class="text-[10px] font-semibold tracking-wide text-slate-500 uppercase">Staff ID</dt>
              <dd class="mt-1 text-sm font-semibold text-[#0f172a]">{{ profile?.profileId ?? '—' }}</dd>
            </div>
            <div>
              <dt class="text-[10px] font-semibold tracking-wide text-slate-500 uppercase">Full name</dt>
              <dd class="mt-1 text-sm font-semibold text-[#0f172a]">{{ profile?.name ?? '—' }}</dd>
            </div>
            <div class="sm:col-span-2">
              <dt class="text-[10px] font-semibold tracking-wide text-slate-500 uppercase">Home station</dt>
              <dd class="mt-1 text-sm font-semibold text-[#0f172a]">{{ homeStation }}</dd>
            </div>
          </dl>

          <div class="mt-6 border-t border-[#e4e9f4] pt-5">
            <h3 class="text-xs font-bold tracking-wide text-[#5b6aa1] uppercase">Assigned roles</h3>
            <ul v-if="assignableRoles.length" class="mt-3 flex flex-col gap-2">
              <li
                v-for="role in assignableRoles"
                :key="`${role.roleTypeId}-${role.stationId}`"
                class="flex items-center justify-between gap-3 rounded-md border border-[#e4e9f4] bg-[#f8fafd] px-3 py-2 text-sm"
              >
                <span class="font-medium text-[#384884]">{{ role.roleTypeName }}</span>
                <span class="text-slate-500">{{ role.stationName }}</span>
              </li>
            </ul>
            <p v-else class="mt-3 text-sm text-slate-400">No additional roles assigned.</p>
          </div>
        </section>

        <!-- Contact -->
        <section class="rounded-lg border border-[#d5dceb] bg-white p-5 sm:p-6">
          <h2 class="text-sm font-bold tracking-wide text-[#384884] uppercase">Contact</h2>
          <form class="mt-5 flex flex-col gap-4" @submit.prevent="saveContact">
            <div class="flex flex-col gap-2">
              <label for="account-email" class="text-xs font-semibold tracking-wide text-[#384884] uppercase">Email</label>
              <InputText
                id="account-email"
                v-model="contact.email"
                type="email"
                autocomplete="email"
                :disabled="!!contactUi.busy"
                :pt="inputPt"
              />
            </div>
            <div class="flex flex-col gap-2">
              <label for="account-phone" class="text-xs font-semibold tracking-wide text-[#384884] uppercase">Phone</label>
              <InputText
                id="account-phone"
                v-model="contact.phone"
                type="text"
                autocomplete="tel"
                :disabled="!!contactUi.busy"
                :pt="inputPt"
              />
            </div>
            <Button
              type="submit"
              label="Save contact"
              icon="pi pi-save"
              size="small"
              class="w-fit"
              :loading="!!contactUi.busy"
              :disabled="!contactDirty"
            />
            <FeedBack :ui="contactUi" />
          </form>
        </section>

        <!-- Password -->
        <section class="rounded-lg border border-[#d5dceb] bg-white p-5 sm:p-6 lg:col-span-2">
          <h2 class="text-sm font-bold tracking-wide text-[#384884] uppercase">Change password</h2>
          <form class="mt-5 grid gap-4 sm:grid-cols-3" @submit.prevent="changePassword">
            <div class="flex flex-col gap-2">
              <label for="current-password" class="text-xs font-semibold tracking-wide text-[#384884] uppercase">
                Current password
              </label>
              <Password
                id="current-password"
                v-model="passwordForm.currentPassword"
                toggle-mask
                :feedback="false"
                class="w-full"
                :disabled="!!passwordUi.busy"
                :pt="{ root: { class: 'w-full' }, pcInputText: { root: inputPt.root } }"
              />
            </div>
            <div class="flex flex-col gap-2">
              <label for="new-password" class="text-xs font-semibold tracking-wide text-[#384884] uppercase">
                New password
              </label>
              <Password
                id="new-password"
                v-model="passwordForm.newPassword"
                toggle-mask
                :feedback="false"
                class="w-full"
                :disabled="!!passwordUi.busy"
                :pt="{ root: { class: 'w-full' }, pcInputText: { root: inputPt.root } }"
              />
            </div>
            <div class="flex flex-col gap-2">
              <label for="confirm-password" class="text-xs font-semibold tracking-wide text-[#384884] uppercase">
                Confirm password
              </label>
              <Password
                id="confirm-password"
                v-model="passwordForm.confirmPassword"
                toggle-mask
                :feedback="false"
                class="w-full"
                :disabled="!!passwordUi.busy"
                :pt="{ root: { class: 'w-full' }, pcInputText: { root: inputPt.root } }"
              />
            </div>
            <div class="flex flex-col gap-3 sm:col-span-3 sm:flex-row sm:items-center">
              <Button
                type="submit"
                label="Update password"
                icon="pi pi-key"
                size="small"
                class="w-fit"
                :loading="!!passwordUi.busy"
              />
              <FeedBack :ui="passwordUi" />
            </div>
          </form>
        </section>
      </div>
    </div>
  </div>
</template>
