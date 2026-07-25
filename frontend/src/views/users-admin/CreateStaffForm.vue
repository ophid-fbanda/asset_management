<script setup>
import { onMounted, reactive } from 'vue'
import { InputNumber, InputText, Password, Select } from 'primevue'
import { objectComplete, objectReset, objectResetSet } from '@/api/objectx'
import { dataFetchToCache, dataFromCache, dataRefreshCache, dataSend } from '@/api/datax'
import FeedBack from '@/commons/FeedBack.vue'

const LIST_KEY = 'users/staff'

const emit = defineEmits(['close'])

const stations = dataFromCache('meta/stations')

const form = reactive({
  id: null,
  fullName: null,
  staffEmail: null,
  staffPhone: null,
  password: null,
  homeStationId: null,
})

const ui = reactive({
  busy: null,
  error: null,
})

const submitForm = async () => {
  if (!objectComplete(form)) {
    objectResetSet(ui, 'error', 'Complete all fields.')
    return
  }
  objectResetSet(ui, 'busy', true)
  const response = await dataSend('users/staff', form)
  if (response.status === 200) {
    objectReset(form)
    await dataRefreshCache(LIST_KEY)
    emit('close')
  } else {
    objectResetSet(ui, 'error', response.data)
  }
  objectResetSet(ui, 'busy', null)
}

onMounted(() => {
  dataFetchToCache('meta/stations')
})
</script>

<template>
  <div class="flex flex-col gap-4">
    <p class="text-sm text-slate-500">
      Staff id is the login username (integer). General User is provisioned automatically at the home station.
    </p>

    <div class="grid gap-3 sm:grid-cols-2">
      <div class="flex flex-col gap-1.5">
        <label class="text-sm font-medium text-[#384884]">Staff id</label>
        <InputNumber
          v-model="form.id"
          :use-grouping="false"
          placeholder="e.g. 6"
          class="w-full"
        />
      </div>
      <div class="flex flex-col gap-1.5">
        <label class="text-sm font-medium text-[#384884]">Home station</label>
        <Select
          v-model="form.homeStationId"
          :options="stations ?? []"
          option-label="station_name"
          option-value="id"
          placeholder="Select station"
          filter
          class="w-full"
        />
      </div>
      <div class="flex flex-col gap-1.5 sm:col-span-2">
        <label class="text-sm font-medium text-[#384884]">Full name</label>
        <InputText v-model="form.fullName" class="w-full" />
      </div>
      <div class="flex flex-col gap-1.5">
        <label class="text-sm font-medium text-[#384884]">Email</label>
        <InputText v-model="form.staffEmail" class="w-full" />
      </div>
      <div class="flex flex-col gap-1.5">
        <label class="text-sm font-medium text-[#384884]">Phone</label>
        <InputText v-model="form.staffPhone" class="w-full" />
      </div>
      <div class="flex flex-col gap-1.5 sm:col-span-2">
        <label class="text-sm font-medium text-[#384884]">Password</label>
        <Password
          v-model="form.password"
          :feedback="false"
          toggle-mask
          class="w-full"
          input-class="w-full"
        />
      </div>
    </div>

    <div class="flex items-center justify-end gap-2">
      <button
        type="button"
        class="cursor-pointer border border-[#c5cce3] px-3 py-2 text-xs font-semibold text-slate-600 transition hover:bg-slate-50"
        @click="emit('close')"
      >
        Cancel
      </button>
      <button
        type="button"
        :disabled="!!ui.busy"
        class="flex cursor-pointer items-center gap-2 border border-[#384884] bg-[#384884] px-3 py-2 text-xs font-semibold text-white transition hover:bg-[#5b6aa1] disabled:cursor-not-allowed disabled:opacity-40"
        @click="submitForm"
      >
        <i class="pi pi-user-plus text-xs" />
        <span>{{ ui.busy ? 'Creating…' : 'Create staff' }}</span>
      </button>
    </div>

    <FeedBack :ui="ui" />
  </div>
</template>
