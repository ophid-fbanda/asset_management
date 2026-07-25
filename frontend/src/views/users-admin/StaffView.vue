<script setup>
import { computed, onMounted, reactive, ref, watch } from 'vue'
import { DataView, Dialog } from 'primevue'
import { arraySearch, objectSet } from '@/api/objectx'
import { dataClearSearch, dataFetchToCache, dataFromCache, dataSearchModel } from '@/api/datax'
import StaffCard from '@/views/users-admin/StaffCard.vue'
import CreateStaffForm from '@/views/users-admin/CreateStaffForm.vue'

const LIST_KEY = 'users/staff'
const search = dataSearchModel()
const pageFirst = ref(0)

const ui = reactive({
  createOpen: false,
})

const dataRecords = computed(() => dataFromCache(LIST_KEY).value ?? [])
const filteredRecords = computed(() => arraySearch(dataRecords.value, search.value))

watch(search, () => { pageFirst.value = 0 })

onMounted(() => {
  dataClearSearch()
  dataFetchToCache(LIST_KEY)
})
</script>

<template>
  <div class="flex min-h-0 flex-1 flex-col gap-4 overflow-hidden">
    <div class="flex shrink-0 flex-wrap items-baseline justify-between gap-3">
      <div class="flex items-baseline gap-3">
        <h2 class="text-lg font-semibold text-[#384884]">Staff</h2>
        <span class="text-sm text-slate-500">{{ filteredRecords.length }} people</span>
      </div>
      <button
        type="button"
        class="flex cursor-pointer items-center gap-2 border border-[#384884] bg-[#384884] px-3 py-1.5 text-xs font-semibold text-white transition hover:bg-[#5b6aa1]"
        @click="objectSet(ui, 'createOpen', true)"
      >
        <i class="pi pi-user-plus text-sm" />
        <span>Create staff</span>
      </button>
    </div>

    <div class="min-h-0 flex-1 overflow-auto">
      <DataView
        :value="filteredRecords"
        layout="grid"
        data-key="entity_id"
        paginator
        :rows="9"
        :rows-per-page-options="[9, 18, 36]"
        v-model:first="pageFirst"
        paginator-template="FirstPageLink PrevPageLink PageLinks NextPageLink LastPageLink RowsPerPageDropdown CurrentPageReport"
        current-page-report-template="{first}–{last} of {totalRecords}"
        class="staff-dataview"
      >
        <template #grid="{ items }">
          <div class="grid gap-4 sm:grid-cols-2 xl:grid-cols-3">
            <StaffCard
              v-for="row in items"
              :key="row.entity_id"
              :staff="row"
            />
          </div>
        </template>
        <template #empty>
          <p class="text-sm text-slate-400">No staff found.</p>
        </template>
      </DataView>
    </div>

    <Dialog
      v-model:visible="ui.createOpen"
      modal
      header="Create staff"
      :style="{ width: 'min(92vw, 36rem)' }"
      :draggable="false"
    >
      <CreateStaffForm @close="objectSet(ui, 'createOpen', false)" />
    </Dialog>
  </div>
</template>

<style scoped>
.staff-dataview :deep(.p-dataview-content) {
  background: transparent;
  border: 0;
  padding: 0;
}

.staff-dataview :deep(.p-dataview-paginator-bottom) {
  border: 0;
  border-top: 1px solid #e4e9f4;
  background: transparent;
  margin-top: 1rem;
  padding: 0.75rem 0 0;
}
</style>
