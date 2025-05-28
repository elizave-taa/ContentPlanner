<template>
  <div class="item">
    <div class="d-flex justify-content-between align-items-center flex-wrap">

      <div class="d-flex align-items-center flex-grow-1 me-2">
        <BFormCheckbox
            v-model="localItem.done"
            switch
            class="me-2"
        />

        <div v-if="editMode" class="flex-grow-1">
          <BFormInput
              v-model="localItem.text"
              :placeholder="`Публикация #${postNumber}`"
              size="sm"
              class="mb-0"
          />
        </div>

        <span
            v-else
            :style="{ textDecoration: localItem.done ? 'line-through' : 'none' }"
            class="text-sm"
        >
    {{ postNumber }}. {{ localItem.text }}
  </span>
      </div>

      <div class="d-flex flex-wrap align-items-center">
        <BBadge
            v-for="(type, i) in localItem.types"
            :key="i"
            variant="secondary"
            class="me-1 mb-1"
        >
          {{ type }}
        </BBadge>

        <small v-if="localItem.date" class="text-muted ms-2">
          {{ formattedDate }}
        </small>
      </div>
    </div>

    <!-- Режим редактирования -->
    <div v-if="editMode" class="d-flex align-items-center flex-wrap gap-2 mt-2">

      <!-- Типы публикации как кнопки -->
      <BFormCheckboxGroup
          v-model="localItem.types"
          :options="contentTypeOptions"
          buttons
          size="sm"
          class="content-type"
      />

      <!-- Календарь -->
      <Datepicker
          v-model="localItem.date"
          :format="'dd.MM.yyyy'"
          :enable-time-picker="false"
          placeholder="Дата"
          class="form-control form-control-sm"
          style="max-width: 160px;"
      />

      <BButton variant="danger" size="sm" @click="$emit('remove')">
        Удалить
      </BButton>
    </div>
  </div>
</template>

<script setup>
import { computed } from 'vue'
import {
  BFormCheckbox,
  BFormSelect,
  BCard,
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

const localItem = computed({
  get: () => props.modelValue,
  set: (val) => emit('update:modelValue', val)
})

const contentTypeOptions = [
  { value: 'Reels', text: 'Reels' },
  { value: 'Инфографика', text: 'Инфографика' },
  { value: 'Текст', text: 'Текст' },
  { value: 'Сторис', text: 'Сторис' }
]

const formattedDate = computed(() => {
  if (!localItem.value.date) return ''
  const date = new Date(localItem.value.date)
  return date.toLocaleDateString('ru-RU')
})
</script>

<style scoped>
.item{
  padding: 5px;
  cursor: pointer;
}

.content-type >>> .btn-secondary,
.content-type ::v-deep .btn-secondary {
  background-color: #4a2c40 !important;
  border-color: #4a2c40 !important;
  color: white !important;
}

.content-type :deep(.btn-check:checked + .btn-secondary),
.content-type :deep(.btn-check:active + .btn-secondary),
.content-type :deep(.btn-secondary:active),
.content-type :deep(.btn-secondary.active) {
  background-color: #9a7890!important;
}
</style>
