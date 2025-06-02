<template>
  <BModal v-model="show" title="Автоматическое расписание" @hide="$emit('cancel')">
    <div>
      <label class="form-label">Стартовая дата:</label>
      <Datepicker
          v-model="localStartDate"
          :format="'dd.MM.yyyy'"
          :enable-time-picker="false"
          placeholder="Дата старта"
          class="custom-datepicker form-control-sm"
      />

      <label class="form-label">Дни публикации:</label>
      <BFormCheckboxGroup
          v-model="localSelectedDays"
          :options="weekdays"
          class="mb-3"
          stacked
      />
    </div>

    <template #footer>
      <BButton variant="secondary" @click="emit('update:modelValue', false)">Отмена</BButton>
      <BButton variant="primary" @click="handleApply">Применить</BButton>
    </template>
  </BModal>
</template>

<script setup>
import { ref, watch } from 'vue'
import {BButton, BFormCheckboxGroup, BModal} from "bootstrap-vue-next";
import Datepicker from '@vuepic/vue-datepicker'
import '@vuepic/vue-datepicker/dist/main.css'

const props = defineProps({
  modelValue: Boolean,
})

const emit = defineEmits(['update:modelValue', 'apply', 'cancel'])

const show = ref(props.modelValue)
watch(() => props.modelValue, (val) => (show.value = val))
watch(show, (val) => emit('update:modelValue', val))

const localStartDate = ref(null)
const localSelectedDays = ref([])

const weekdays = [
  { value: 1, text: 'Пн' },
  { value: 2, text: 'Вт' },
  { value: 3, text: 'Ср' },
  { value: 4, text: 'Чт' },
  { value: 5, text: 'Пт' },
  { value: 6, text: 'Сб' },
  { value: 0, text: 'Вс' },
]

function handleApply() {
  const today = new Date()
  if (!localStartDate.value) {
    alert("Выберите стартовую дату")
    return
  }
  if (localStartDate.value < today.setHours(0, 0, 0, 0)) {
    alert("Нельзя выбрать прошедшую дату")
    return
  }
  if (localSelectedDays.value.length === 0) {
    alert("Выберите дни публикаций")
    return
  }

  emit('apply', {
    startDate: new Date(localStartDate.value),
    days: [...localSelectedDays.value],
  })

  emit('update:modelValue', false) // <-- ВАЖНО! Закрываем модалку
}
</script>

<style scoped>
.custom-datepicker :deep(.dp__input) {
  border: none !important; 
}

.custom-datepicker :deep(.dp__input_wrap) {
  border: 1px solid #ced4da !important; 
  border-radius: 0.25rem !important;
}
</style>
