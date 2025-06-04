<template>
  <div class="item">
    <div class="d-flex justify-content-between align-items-center flex-wrap">

      <div class="d-flex align-items-center flex-grow-1 me-2">
        <BFormCheckbox
            v-model="localItem.posted"
            @change="updatePostedStatus"
            class="me-2"
            title="Опубликовано"
        />

        <div v-if="editMode" class="flex-grow-1">
          <BFormInput
              v-model="localItem.title"
              :placeholder="`Публикация #${postNumber}`"
              size="sm"
              class="mb-0"
              @input="debouncedUpdate"
          />
        </div>

        <span
            v-else
            :style="{ textDecoration: localItem.posted ? 'line-through' : 'none' }"
            class="text-sm"
        >
    {{ postNumber }}. {{ localItem.title }}
  </span>
      </div>

      <div class="d-flex flex-wrap align-items-center">
        <BBadge
            v-for="(tag, i) in localItem.tags"
            :key="i"
            variant="secondary"
            class="me-1 mb-1"
        >
          {{ tag }}
        </BBadge>
        <BButton v-if="editMode" variant="danger" size="sm" @click="$emit('remove')">
        Удалить
        </BButton>
        <small v-if="localItem.deadline && !editMode" class="text-muted ms-2">
          {{ formattedDate }}
        </small>
      </div>
    </div>

    <!-- Режим редактирования -->
    <div v-if="editMode" class="d-flex align-items-center flex-wrap gap-2 mt-2">

      <!-- Типы публикации как кнопки -->
      <BFormCheckboxGroup
      v-model="localItem.tags"
      :options="contentTypeOptions"
      buttons
      size="sm"
      class="content-type"
      button-variant="secondary"
      @change="debouncedUpdate"
    />

      <!-- Календарь -->
      <Datepicker
        v-model="localItemDate"
        :format="'dd.MM.yyyy'"
        :enable-time-picker="false"
        placeholder="Дата"
        class="custom-datepicker form-control-sm"
        style="max-width: 160px;"
        @update:model-value="onDateChange"
      />

    </div>
  </div>
</template>

<script setup>
import { computed, ref, watch } from 'vue'
import {
  BFormCheckbox,
  BFormSelect,
  BCard, BTooltip,
  BButton,
  BBadge, BFormInput,
    BFormCheckboxGroup,
} from 'bootstrap-vue-next'

import Datepicker from '@vuepic/vue-datepicker'
import '@vuepic/vue-datepicker/dist/main.css'

const props = defineProps({
  modelValue: Object,
  editMode: Boolean,
  postNumber: Number
})
const emit = defineEmits(['update:modelValue', 'remove'])

// Create a local copy to avoid direct mutation of props
const localItem = ref({
  id: null,
  title: '',
  posted: false,
  deadline: null,
  platform: '',
  tags: [],
  // Legacy fields for backward compatibility
  text: '',
  done: false,
  date: null,
  types: [],
  ...props.modelValue
})

// Computed property for the date picker
const localItemDate = computed({
  get() {
    if (localItem.value.deadline) {
      return new Date(localItem.value.deadline)
    }
    if (localItem.value.date) {
      return localItem.value.date
    }
    return null
  },
  set(value) {
    if (value) {
      localItem.value.deadline = value.toISOString().split('T')[0]
      localItem.value.date = value // For backward compatibility
    } else {
      localItem.value.deadline = null
      localItem.value.date = null
    }
  }
})

const contentTypeOptions = [
  { value: 'Reels', text: 'Reels' },
  { value: 'Инфографика', text: 'Инфографика' },
  { value: 'Текст', text: 'Текст' },
  { value: 'Сторис', text: 'Сторис' }
]

const formattedDate = computed(() => {
  if (!localItem.value.deadline) return ''
  const date = new Date(localItem.value.deadline)
  return date.toLocaleDateString('ru-RU')
})

// Watch for external changes and update local copy
watch(() => props.modelValue, (newValue) => {
  if (newValue) {
    localItem.value = {
      ...localItem.value,
      ...newValue
    }
  }
}, { deep: true })

// Debounced update function
let updateTimeout = null
const debouncedUpdate = () => {
  clearTimeout(updateTimeout)
  updateTimeout = setTimeout(() => {
    emitUpdate()
  }, 500) // 500ms delay
}

// Immediate update for posted status
const updatePostedStatus = () => {
  // Update backward compatibility fields
  localItem.value.done = localItem.value.posted
  emitUpdate()
}

const onDateChange = (value) => {
  if (value) {
    localItem.value.deadline = value.toISOString().split('T')[0]
    localItem.value.date = value // For backward compatibility
  } else {
    localItem.value.deadline = null
    localItem.value.date = null
  }
  debouncedUpdate()
}

const emitUpdate = () => {
  // Sync backward compatibility fields
  localItem.value.text = localItem.value.title
  localItem.value.done = localItem.value.posted
  localItem.value.types = localItem.value.tags

  emit('update:modelValue', { ...localItem.value })
}

// Watch for changes in tags and emit update
watch(() => localItem.value.tags, () => {
  localItem.value.types = localItem.value.tags // Keep backward compatibility
}, { deep: true })

// Set default deadline to today for new items
if (!localItem.value.id && !localItem.value.deadline) {
  const today = new Date().toISOString().split('T')[0]
  localItem.value.deadline = today
  localItem.value.date = new Date() // For backward compatibility
}
</script>

<style scoped>

.item{
  padding: 5px;
  cursor: pointer;
}

.content-type {
  gap: 5px;
}

.content-type >>> .btn-secondary,
.content-type ::v-deep .btn-secondary {
  background-color: #4a2c40 !important;
  border-color: #4a2c40 !important;
  color: white !important;
  font-size: 12px;
}

.content-type :deep(.btn-check:checked + .btn-secondary),
.content-type :deep(.btn-check:active + .btn-secondary),
.content-type :deep(.btn-secondary:active),
.content-type :deep(.btn-secondary.active) {
  background-color: #9a7890!important;
}

.custom-datepicker :deep(.dp__input) {
  border: none !important;
}

.custom-datepicker :deep(.dp__input_wrap) {
  border: 1px solid #ced4da !important;
  border-radius: 0.25rem !important;
}
</style>
