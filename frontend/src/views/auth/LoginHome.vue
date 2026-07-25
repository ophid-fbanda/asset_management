<script setup>
import { onMounted, reactive } from 'vue'
import { Button, IconField, InputIcon, InputText, Password } from 'primevue'
import logoUrl from '@/assets/logo.png'
import { dataAutoSignIn, dataSend, dataToProfile } from '@/api/datax'
import { objectSet, objectReset, objectComplete, objectResetSet } from '@/api/objectx'
import FeedBack from '@/commons/FeedBack.vue'

const form = reactive({
  username: null,
  password: null,
})

const ui = reactive({
  busy: null,
  error: null,
})

const year = new Date().getFullYear()

const capabilities = [
  {
    icon: 'pi pi-box',
    title: 'Lifecycle control',
    text: 'Registration, transfer, issuance, verification, and disposal — end to end.',
  },
  {
    icon: 'pi pi-check-circle',
    title: 'Governed approvals',
    text: 'Supervisory and management sign-off on every material asset event.',
  },
  {
    icon: 'pi pi-building',
    title: 'Station accountability',
    text: 'Custody, location, condition, and value resolved per station in real time.',
  },
]

const inputPt = {
  root: {
    class:
      'min-h-12 w-full !rounded-md !border-[#c5cce3] !bg-white !text-[#0f172a] placeholder:!text-[#94a3b8] focus:!border-[#384884] focus:!shadow-[0_0_0_3px_rgba(56,72,132,0.14)]',
  },
}

const primaryBtnPt = {
  root: {
    class:
      'mt-1 min-h-12 w-full !rounded-md !border-[#384884] !bg-[#384884] !text-sm !font-semibold !tracking-wide hover:!border-[#2d3a6b] hover:!bg-[#2d3a6b]',
  },
}

const submitForm = async () => {
  objectReset(ui)

  if (!objectComplete(form)) {
    objectSet(ui, 'error', 'Enter your username and password to continue.')
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
  <div class="login-shell flex h-dvh max-h-dvh flex-col overflow-hidden bg-[#eef1f7] font-sans antialiased lg:flex-row">

    <!-- Capabilities column — desktop only; logo/title live above the form on all sizes -->
    <aside
      class="login-brand relative hidden shrink-0 flex-col justify-between overflow-hidden bg-[#2a3568] lg:flex lg:w-[52%] xl:w-[55%]"
    >
      <div class="login-grid pointer-events-none absolute inset-0" />
      <div class="login-glow pointer-events-none absolute inset-0" />

      <div class="relative z-10 flex flex-1 flex-col justify-center px-8 py-12 sm:px-12 lg:px-16 xl:px-28">
        <ul class="flex max-w-xl flex-col gap-10">
          <li
            v-for="item in capabilities"
            :key="item.title"
            class="flex gap-6 border-l-2 border-[#5b6aa1]/60 pl-7"
          >
            <div class="flex size-11 shrink-0 items-center justify-center rounded-sm border border-white/15 bg-white/5">
              <i :class="[item.icon, 'text-base text-white/90']" />
            </div>
            <div>
              <p class="text-sm font-semibold text-white">{{ item.title }}</p>
              <p class="mt-2 text-[13px] leading-relaxed text-[#a0b4e8]">{{ item.text }}</p>
            </div>
          </li>
        </ul>
      </div>

      <div class="relative z-10 border-t border-white/10 px-8 py-10 sm:px-12 lg:px-16 xl:px-28">
        <div class="flex flex-wrap items-center gap-x-12 gap-y-4 text-[11px] uppercase tracking-widest text-[#8fa0d4]">
          <span class="inline-flex items-center gap-2">
            <i class="pi pi-shield text-xs" />
            Encrypted session
          </span>
          <span class="inline-flex items-center gap-2">
            <i class="pi pi-history text-xs" />
            Audit trail
          </span>
          <span class="inline-flex items-center gap-2">
            <i class="pi pi-users text-xs" />
            Role-based access
          </span>
        </div>
      </div>
    </aside>

    <!-- Authentication column -->
    <main class="flex min-h-0 flex-1 flex-col overflow-hidden">
      <div class="flex min-h-0 flex-1 items-center justify-center px-6 py-6 sm:px-10 lg:px-14">
        <div class="w-full max-w-[26rem]">

          <!-- Brand above form (all screen sizes) -->
          <div class="mb-10 flex flex-col items-center border-b border-[#d8deec] pb-8 text-center">
            <img :src="logoUrl" alt="Logo" class="mb-6 h-14 w-auto object-contain" />
            <p class="text-[10px] font-semibold uppercase tracking-widest text-[#5b6aa1]">Asset Management System</p>
            <p class="mt-3 text-base font-semibold text-[#384884]">Log in to continue</p>
          </div>

          <form class="flex flex-col gap-5" @submit.prevent="submitForm">
            <div class="flex flex-col gap-2">
              <label for="username" class="text-xs font-semibold tracking-wide text-[#384884] uppercase">
                Username
              </label>
              <IconField class="w-full">
                <InputIcon class="pi pi-user text-[#5b6aa1]" />
                <InputText
                  id="username"
                  v-model="form.username"
                  type="text"
                  placeholder="Staff ID"
                  autocomplete="username"
                  class="w-full"
                  :disabled="ui.busy"
                  :pt="{ root: inputPt.root }"
                />
              </IconField>
            </div>

            <div class="flex flex-col gap-2">
              <label for="password" class="text-xs font-semibold tracking-wide text-[#384884] uppercase">
                Password
              </label>
              <IconField class="w-full">
                <InputIcon class="pi pi-lock text-[#5b6aa1]" />
                <Password
                  id="password"
                  v-model="form.password"
                  toggleMask
                  :feedback="false"
                  placeholder="Your password"
                  class="w-full"
                  :disabled="ui.busy"
                  :pt="{
                    root: { class: 'w-full' },
                    pcInputText: {
                      root: {
                        class: inputPt.root.class,
                        autocomplete: 'current-password',
                      },
                    },
                  }"
                />
              </IconField>
            </div>

            <Button
              type="submit"
              label="Sign in"
              icon="pi pi-arrow-right"
              icon-pos="right"
              :loading="ui.busy"
              :pt="primaryBtnPt"
            />

            <div class="min-h-[2.5rem]">
              <FeedBack :ui="ui" />
            </div>
          </form>

          <footer class="mt-10 space-y-2 border-t border-[#d8deec] pt-8 text-center sm:mt-10 sm:space-y-3">
            <p class="text-[10px] leading-relaxed text-[#94a3b8]">
              Unauthorised access is prohibited and may be subject to disciplinary or legal action.
            </p>
            <p class="text-[10px] uppercase tracking-widest text-[#b0bac9]">
              © {{ year }} Assets Management System
            </p>
          </footer>
        </div>
      </div>
    </main>
  </div>
</template>

<style scoped>
.login-brand {
  background: linear-gradient(155deg, #1e2749 0%, #2a3568 42%, #384884 100%);
}

.login-grid {
  background-image:
    linear-gradient(rgba(255, 255, 255, 0.04) 1px, transparent 1px),
    linear-gradient(90deg, rgba(255, 255, 255, 0.04) 1px, transparent 1px);
  background-size: 56px 56px;
  mask-image: linear-gradient(to bottom, black 55%, transparent 100%);
}

.login-glow {
  background:
    radial-gradient(ellipse 80% 50% at 20% 20%, rgba(255, 255, 255, 0.08), transparent 55%),
    radial-gradient(ellipse 60% 40% at 85% 75%, rgba(91, 106, 161, 0.25), transparent 50%);
}

.login-shell {
  height: 100dvh;
  max-height: 100dvh;
  overflow: hidden;
}
</style>
