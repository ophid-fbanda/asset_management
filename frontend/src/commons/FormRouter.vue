<script setup>
import { computed, onMounted, reactive } from 'vue'
import { Column, DataTable, Dialog, Select, Textarea, useToast } from 'primevue'
import { objectHeaders, objectSet } from '@/api/objectx'
import { dataFetchToCache, dataFromCache, dataSend } from '@/api/datax'
import RegistrationForm from '@/views/asset-admin/forms/RegistrationForm.vue'
import TransferForm from '@/views/asset-admin/forms/TransferForm.vue'
import IssuanceForm from '@/views/asset-admin/forms/IssuanceForm.vue'
import VerificationForm from '@/views/asset-admin/forms/VerificationForm.vue'
import EvaluationForm from '@/views/asset-admin/forms/EvaluationForm.vue'
import PlacementForm from '@/views/asset-admin/forms/PlacementForm.vue'
import DisposalForm from '@/views/asset-admin/forms/DisposalForm.vue'
import IncidentForm from '@/views/home/forms/IncidentForm.vue'
import RequisitionForm from '@/views/asset-admin/forms/RequisitionForm.vue'
import RegistrationTemplate from '@/views/templates/RegistrationTemplate.vue'
import TransferTemplate from '@/views/templates/TransferTemplate.vue'
import IssuanceTemplate from '@/views/templates/IssuanceTemplate.vue'
import VerificationTemplate from '@/views/templates/VerificationTemplate.vue'
import EvaluationTemplate from '@/views/templates/EvaluationTemplate.vue'
import PlacementTemplate from '@/views/templates/PlacementTemplate.vue'
import DisposalTemplate from '@/views/templates/DisposalTemplate.vue'
import IncidentTemplate from '@/views/templates/IncidentTemplate.vue'
import RequisitionTemplate from '@/views/templates/RequisitionTemplate.vue'
import AssetProfileTemplate from '@/views/templates/AssetProfileTemplate.vue'

const props = defineProps({
  header: { type: String, default: 'Form' },
  options: { type: Array, default: () => [] },
  external: { type: String, default: null },
  collected: { type: Array, default: () => [] },
})

const emit = defineEmits(['close'])

const toast = useToast()
const ui = reactive({ busy: null, error: null })
const context = reactive({ formId: null })
const form = reactive({ eventId: null, approvalTypeId: null, notes: '' })

const showMenu = computed(() => !props.external && (props.options?.length ?? 0) > 0)
const menuOpen = computed(() => showMenu.value)
const selectForm = (id) => objectSet(context, 'formId', id)

// Options visible in the menu: if more than 1 item is collected, only show multi-asset
// options (table >= 2). Single-asset options (table: 1) don't make sense for a batch.
const visibleOptions = computed(() => {
  const count = props.collected?.length ?? 0
  if (count <= 1) return props.options
  return props.options.filter((o) => (o.table ?? 1) >= 2)
})

// Columns for the always-visible collected items table
const collectedColumns = computed(() => objectHeaders(props.collected ?? []))

// The currently selected option object
const selectedOption = computed(() => props.options.find((o) => o.id === context.formId) ?? null)

// The entity driving the document (first collected row)
const entity = computed(() => props.collected[0] ?? null)

// Resolve approval type choices from meta, filtered to the option's choice IDs
const allApprovalTypes = computed(() => dataFromCache('meta/approval_types').value ?? [])
const approvalChoices = computed(() => {
  const ids = selectedOption.value?.choices ?? []
  return allApprovalTypes.value.filter((t) => ids.includes(t.id))
})

// Show the approval footer only when the entity's current approval state matches the option target
const showApprovalFooter = computed(() =>
  selectedOption.value?.target != null &&
  entity.value?.latest_approval_type_id === selectedOption.value.target
)

const submitApproval = async () => {
  objectSet(ui, 'busy', true)
  form.eventId = entity.value?.event_id
  const result = await dataSend('approvals/approve', form)
  if (result.status === 200) {
    toast.add({ severity: 'success', summary: 'Approved', detail: 'Approval submitted successfully.', life: 4000 })
    emit('close')
  } else {
    objectSet(ui, 'error', result.data)
  }
  objectSet(ui, 'busy', null)
}

onMounted(() => {
  dataFetchToCache('meta/approval_types')
  if (props.external) {
    selectForm(props.external)
  } else if (visibleOptions.value?.length) {
    // Open the first option so the form/document is visible immediately.
    selectForm(visibleOptions.value[0].id)
  }
})
</script>

<template>
  <Dialog
    :visible="true"
    modal
    maximizable
    :header="header"
    :style="{ width: 'min(96vw, 88rem)', borderRadius: '0.375rem' }"
    content-class="!p-0"
    :draggable="false"
    :pt="{
      mask: { class: 'bg-slate-900/50' },
      root: {
        class: 'overflow-hidden border border-slate-200 bg-white shadow-2xl !rounded-[0.375rem] [&.p-dialog-maximized]:!rounded-none',
        style: { borderRadius: '0.375rem' },
      },
      header: {
        class: 'shrink-0 min-h-0 border-b border-slate-700 bg-slate-800 !px-4 !py-1.5 text-slate-100 !rounded-t-[0.375rem] [.p-dialog-maximized_&]:!rounded-none',
        style: { padding: '0.375rem 1rem', borderRadius: '0.375rem 0.375rem 0 0' },
      },
      title: { class: '!text-sm !font-medium leading-none tracking-wide text-slate-100' },
      headerActions: { class: 'gap-0.5' },
      pcMaximizeButton: {
        root: { class: '!size-7 !min-w-0 !p-0 !text-slate-300 hover:!bg-slate-700 hover:!text-white' },
        icon: { class: '!text-xs' },
      },
      pcCloseButton: {
        root: { class: '!size-7 !min-w-0 !p-0 !text-slate-300 hover:!bg-slate-700 hover:!text-white' },
        icon: { class: '!text-xs' },
      },
      content: {
        class: '!p-0 bg-slate-50 !rounded-b-[0.375rem] [.p-dialog-maximized_&]:!rounded-none',
        style: { borderRadius: '0 0 0.375rem 0.375rem' },
      },
    }"
    @update:visible="emit('close')"
  >
    <div
      class="flex h-[min(85vh,42rem)] min-h-[32rem] w-full bg-slate-50 [.p-dialog-maximized_&]:h-[calc(100dvh-2.5rem)] [.p-dialog-maximized_&]:min-h-0"
    >
      <aside
        class="flex shrink-0 flex-col border-r border-slate-200 bg-slate-100 py-3 transition-all duration-200 ease-in-out"
        :class="menuOpen ? 'w-44' : 'w-12'"
      >
        <div v-if="menuOpen" class="flex min-h-0 flex-1 flex-col gap-1 overflow-auto px-2 pt-3">
          <button
            v-for="option in visibleOptions"
            :key="option.id"
            type="button"
            class="group flex w-full cursor-pointer items-center gap-2.5 rounded-md border px-3 py-2.5 text-left text-sm font-medium transition-colors"
            :class="
              context.formId === option.id
                ? 'border-[#384884] bg-[#384884] text-white shadow-sm'
                : 'border-[#a0a9ca] text-slate-600 hover:border-[#5b6aa1] hover:bg-white hover:text-[#384884]'
            "
            @click="selectForm(option.id)"
          >
            <span
              class="flex size-7 shrink-0 items-center justify-center rounded-md transition-colors"
              :class="
                context.formId === option.id
                  ? 'bg-white/15 text-white'
                  : 'bg-white text-[#5b6aa1] group-hover:bg-[#e8eefa]'
              "
            >
              <i :class="['pi text-sm', option.icon || 'pi-file-edit']" />
            </span>
            <span class="min-w-0 flex-1 truncate">{{ option.name }}</span>
          </button>
        </div>
      </aside>

      <aside class="flex min-h-0 min-w-0 flex-1 flex-col overflow-hidden">
        <div class="flex min-h-0 flex-1 flex-col overflow-auto bg-slate-100 p-6 gap-4">
          <!-- Selected form / template -->
          <div v-if="context.formId">
            <RegistrationForm     v-if="context.formId === 'regForm'"           :collected="collected" />
            <TransferForm         v-else-if="context.formId === 'transferForm'"     :collected="collected" />
            <IssuanceForm         v-else-if="context.formId === 'issuanceForm'"     :collected="collected" />
            <VerificationForm     v-else-if="context.formId === 'verificationForm'" :collected="collected" />
            <EvaluationForm       v-else-if="context.formId === 'evaluationForm'"   :collected="collected" />
            <PlacementForm        v-else-if="context.formId === 'placementForm'"    :collected="collected" />
            <DisposalForm         v-else-if="context.formId === 'disposalForm'"     :collected="collected" />
            <IncidentForm         v-else-if="context.formId === 'incidentForm'"     :collected="collected" />
            <RequisitionForm      v-else-if="context.formId === 'requisitionForm'" :collected="collected" />
            <RegistrationTemplate v-else-if="context.formId === 'regTemplate'"      :collected="collected" />
            <TransferTemplate     v-else-if="context.formId === 'transferTemplate'"  :collected="collected" />
            <IssuanceTemplate      v-else-if="context.formId === 'issuanceTemplate'"      :collected="collected" />
            <VerificationTemplate  v-else-if="context.formId === 'verificationTemplate'"  :collected="collected" />
            <EvaluationTemplate   v-else-if="context.formId === 'evaluationTemplate'"    :collected="collected" />
            <PlacementTemplate    v-else-if="context.formId === 'placementTemplate'"     :collected="collected" />
            <DisposalTemplate     v-else-if="context.formId === 'disposalTemplate'"      :collected="collected" />
            <IncidentTemplate     v-else-if="context.formId === 'incidentTemplate'"      :collected="collected" />
            <RequisitionTemplate  v-else-if="context.formId === 'reqTemplate'"        :collected="collected" />
            <AssetProfileTemplate v-else-if="context.formId === 'assetProfile'"          :collected="collected" />
          </div>

          <!-- Always-visible collected items table -->
          <div v-if="collected.length" class="flex flex-col gap-2 rounded-md border border-[#c5cce3] bg-white p-4">
            <h3 class="text-sm font-semibold uppercase tracking-wide text-[#384884]">
              Collected ({{ collected.length }})
            </h3>
            <DataTable :value="collected" size="small" striped-rows show-gridlines class="text-sm">
              <Column
                v-for="col in collectedColumns"
                :key="col.field"
                :field="col.field"
                :header="col.header"
              />
            </DataTable>
          </div>
        </div>

        <div v-if="showApprovalFooter" class="shrink-0 border-t border-slate-200 bg-white px-6 py-4 flex items-end gap-4">
          <div class="flex flex-col gap-1">
            <span class="text-[10px] font-bold uppercase tracking-wider text-slate-500">Decision</span>
            <Select
              v-model="form.approvalTypeId"
              :options="approvalChoices"
              option-label="name"
              option-value="id"
              placeholder="Select decision"
              size="small"
              class="w-52"
            />
          </div>
          <div class="flex flex-1 flex-col gap-1">
            <span class="text-[10px] font-bold uppercase tracking-wider text-slate-500">Notes <span class="text-red-500">*</span></span>
            <Textarea
              v-model="form.notes"
              rows="1"
              auto-resize
              placeholder="Official justification (required)"
              class="!text-sm"
            />
          </div>
          <button
            type="button"
            :disabled="!form.approvalTypeId || !form.notes || ui.busy"
            class="flex shrink-0 cursor-pointer items-center gap-2 rounded-sm border border-[#384884] bg-[#384884] px-4 py-2 text-xs font-semibold text-white transition hover:bg-[#5b6aa1] disabled:cursor-not-allowed disabled:opacity-40"
            @click="submitApproval"
          >
            <i class="pi pi-check text-sm" />
            <span>{{ ui.busy ? 'Submitting…' : 'Submit' }}</span>
          </button>
          <span v-if="ui.error" class="text-xs text-red-500">{{ ui.error }}</span>
        </div>
      </aside>
    </div>
  </Dialog>
</template>
