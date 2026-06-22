<script setup>
import { onMounted, reactive } from 'vue'
import { Button, IconField, InputIcon, InputText, Password } from 'primevue'
import logoUrl from '@/assets/logo.png'
import { dataAutoSignIn, dataSend, dataToProfile } from '@/api/datax'
import { objectSet, objectReset, objectComplete, objectResetSet } from '@/api/objectx'

const form = reactive({
  username: null,
  password: null,
})

const ui = reactive({
  busy: null,
  error: null,
})

const primaryBtnPt = {
  root: {
    class:
      'mt-1 w-full !border-[#384884] !bg-[#384884] hover:!border-[#5b6aa1] hover:!bg-[#5b6aa1]',
  },
}

const outlineBtnPt = {
  root: {
    class:
      'w-full !border-[#c5cce3] !bg-white !text-[#384884] hover:!border-[#5b6aa1] hover:!bg-[#e8eefa]',
  },
}

const submitForm = async () => {
  objectReset(ui)

  if (!objectComplete(form)) {
    objectSet(ui, 'error', 'Please enter your email address and password.')
    return
  }

  objectSet(ui, 'busy', true)

  const response = await dataSend('auth/login', form)

  if (response.status === 200) {
    objectReset(form)
    objectReset(ui)
    dataToProfile(response.data)
    return
  }

  objectResetSet(ui, 'error', response.data)
}

onMounted(() => {
  dataAutoSignIn('auth/refresh')
})
</script>

<template>
  <div class="flex min-h-screen items-center justify-center bg-[#384884] px-6 py-10 font-sans antialiased sm:px-10">
    <div
      class="relative z-10 flex w-full max-w-lg flex-col rounded-md bg-white px-6 py-10 shadow-[0_28px_56px_rgba(0,0,0,0.55),0_12px_24px_rgba(0,0,0,0.35)] sm:px-10 lg:px-16"
    >
      <header>
        <section class="text-center">
          <div class="flex justify-center px-4 pb-10 sm:pb-12">
            <img :src="logoUrl" alt="OPHID" class="h-14 w-auto max-w-full object-contain sm:h-16" />
          </div>

          <div class="relative flex items-center justify-center">
            <div class="h-px w-full bg-[#c5cce3]" />
            <h1
              class="absolute bg-white px-4 text-base leading-snug font-normal tracking-wide text-[#384884] uppercase sm:text-lg"
            >
              Asset Management System
            </h1>
          </div>
        </section>

        <section class="pt-8 pb-8 text-center">
          <p class="text-base leading-relaxed text-[#5b6aa1]">
            Sign in to continue.
          </p>
        </section>
      </header>

      <form class="flex flex-col gap-5" @submit.prevent="submitForm">
        <div class="flex flex-col gap-3">
          <label for="username" class="text-sm font-medium text-[#384884]">Username</label>
          <IconField class="w-full">
            <InputIcon class="pi pi-user text-[#5b6aa1]" />
            <InputText
              id="username"
              v-model="form.username"
              type="text"
              placeholder="Enter your username"
              autocomplete="username"
              class="min-h-10 w-full"
              :disabled="ui.busy"
            />
          </IconField>
        </div>

        <div class="flex flex-col gap-3">
          <div class="flex items-center justify-between gap-4">
            <label for="password" class="text-sm font-medium text-[#384884]">Password</label>
            <a href="#" class="shrink-0 text-sm text-[#5b6aa1] hover:underline">Forgot password?</a>
          </div>
          <IconField class="w-full">
            <InputIcon class="pi pi-lock text-[#5b6aa1]" />
            <Password
              id="password"
              v-model="form.password"
              toggleMask
              :feedback="false"
              placeholder="Enter your password"
              class="w-full"
              :disabled="ui.busy"
              :pt="{
                root: { class: 'w-full' },
                pcInputText: {
                  root: { class: 'min-h-10 w-full', autocomplete: 'current-password' },
                },
              }"
            />
          </IconField>
        </div>

        <Button type="submit" label="Sign in" :loading="ui.busy" :pt="primaryBtnPt" />

        <div class="flex items-center gap-4 py-1">
          <div class="h-px flex-1 bg-[#c5cce3]" />
          <span class="text-xs text-[#5b6aa1]">or</span>
          <div class="h-px flex-1 bg-[#c5cce3]" />
        </div>

        <Button
          type="button"
          icon="pi pi-microsoft"
          label="Sign in with Microsoft 365"
          severity="secondary"
          outlined
          disabled
          :pt="outlineBtnPt"
        />

        <div class="mt-10 min-h-[3.25rem]" aria-live="polite">
          <div
            v-if="ui.error"
            class="flex items-start gap-3 rounded-lg border border-red-300 bg-red-50 px-4 py-3 text-sm leading-relaxed text-red-800"
            role="alert"
          >
            <i class="pi pi-exclamation-circle mt-0.5 shrink-0 text-base" />
            <span>{{ ui.error }}</span>
          </div>
        </div>
      </form>
    </div>
  </div>
</template>
