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
      <BButton variant="secondary" @click="cancel">Отмена</BButton>
      <BButton variant="primary" @click="handleApply">Применить</BButton>
    </template>
  </BModal>
</template>

<script setup>
import { ref, watch } from 'vue'
import { BButton, BFormCheckboxGroup, BModal } from 'bootstrap-vue-next'
import Datepicker from '@vuepic/vue-datepicker'
import '@vuepic/vue-datepicker/dist/main.css'

// Принимаем projectId как prop
const props = defineProps({
  modelValue: Boolean,
  projectId:  { type: Number, required: true }
})

const emit = defineEmits(['update:modelValue','cancel','apply'])

const show = ref(props.modelValue)
watch(() => props.modelValue, v => (show.value = v))
watch(show, v => emit('update:modelValue', v))

const localStartDate   = ref(null)
const localSelectedDays = ref([])

// Числовые чекбоксы
const weekdays = [
  { value: 1, text: 'Понедельник' },
  { value: 2, text: 'Вторник' },
  { value: 3, text: 'Среда' },
  { value: 4, text: 'Четверг' },
  { value: 5, text: 'Пятница' },
  { value: 6, text: 'Суббота' },
  { value: 0, text: 'Воскресенье' }
]

// Для конвертации числа дня недели в строку
const weekdayMap = {
  0: 'sunday',
  1: 'monday',
  2: 'tuesday',
  3: 'wednesday',
  4: 'thursday',
  5: 'friday',
  6: 'saturday'
}

function cancel() {
  emit('update:modelValue', false)
  emit('cancel')
}

async function handleApply() {
  const today = new Date()
  // убираем время
  const start = new Date(localStartDate.value)
  start.setHours(0,0,0,0)

  if (!localStartDate.value) {
    return alert("Выберите стартовую дату")
  }
  if (start < new Date(today.setHours(0,0,0,0))) {
    return alert("Нельзя выбрать прошедшую дату")
  }
  if (localSelectedDays.value.length === 0) {
    return alert("Выберите дни публикаций")
  }

  // Строим массив строковых weekday-ов
  const weekdaysStr = localSelectedDays.value.map(d => weekdayMap[d])

  emit('apply', {
    startDate: start,
    days:      weekdaysStr
  })
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
