<template>
  <div class="main">
    <div class="d-flex justify-content-between align-items-center mb-3">
      <BTabs v-model="activeTab" pills card class="custom-tabs">
        <BTab
            v-for="(plan, index) in plans"
            :key="plan.platform"
            :title="plan.platform"
        />
      </BTabs>

      <div class="d-flex align-items-left">
        <BButton @click="editMode = !editMode" size="sm" class="page-btn">
          <svg width="16" height="16" viewBox="0 0 16 16" fill="currentColor" class="me-1">
            <path d="M12.146.146a.5.5 0 0 1 .708 0l3 3a.5.5 0 0 1 0 .708l-10 10a.5.5 0 0 1-.168.11l-5 2a.5.5 0 0 1-.65-.65l2-5a.5.5 0 0 1 .11-.168l10-10zM11.207 2.5L13.5 4.793 14.793 3.5 12.5 1.207 11.207 2.5zm1.586 3L10.5 3.207 4 9.707V10h.5a.5.5 0 0 1 .5.5v.5h.5a.5.5 0 0 1 .5.5v.5h.293l6.5-6.5zm-9.761 5.175l-.106.106-1.528 3.821 3.821-1.528.106-.106A.5.5 0 0 1 5 12.5V12h-.5a.5.5 0 0 1-.5-.5V11h-.5a.5.5 0 0 1-.468-.325z"/>
          </svg>
          {{ editMode ? 'Готово' : 'Ред.' }}
        </BButton>
      </div>
    </div>

    <div v-for="(plan, index) in plans" :key="plan.platform" v-show="activeTab === index">
      <div class="p-3">
        <div v-if="plan.items.length === 0" class=" text-muted">
          Пока ещё ничего нет...
        </div>
        <draggable
            v-model="plan.items"
            group="posts"
            :move="handleDragMove"
            @end="onDragEnd"
            item-key="id"
            :disabled="!editMode"
        >
        <template #item="{element, index}">
          <ContentPlanItem
              :key="element.id"
              :modelValue="element"
              :editMode="editMode"
              :postNumber="index + 1"
              @remove="removeItem(index)"
          />
        </template>
        </draggable>
        <div class="add-item d-flex align-items-center mt-3">
          <BFormInput
              v-model="newItem[index]"
              placeholder="Новая публикация..."
              class="flex-grow-1 me-2"
              @keydown.enter.prevent="addItem(index)"
          />
          <BButton @click="addItem(index)" class="add-btn">+</BButton>
        </div>
      </div>
    </div>
    <div class="d-flex">
      <BButton size="sm" @click="scheduleModal = true" class="shedule-btn">
        Настроить расписание
      </BButton>

      <BButton size="sm" class="shedule-btn">
        Очистить Конентен-план
      </BButton>
    </div>

    <AutoScheduleModal
        :modelValue="scheduleModal"
        @apply="onScheduleApply"
        @update:modelValue="val => scheduleModal = val"
    />
  </div>
</template>

<script setup>
import { ref } from 'vue'
import {
  BTabs,
  BTab,
  BFormInput,
  BButton,
} from 'bootstrap-vue-next'
import ContentPlanItem from './ContentPlanItem.vue'
import AutoScheduleModal from "./AutoScheduleModal.vue";
import draggable from 'vuedraggable'
import 'bootstrap-icons/font/bootstrap-icons.css'
import { onMounted, onUnmounted } from 'vue'

const history = ref({
  Instagram: [],
  TikTok: [],
  VK: []
})

const plans = ref([
  { platform: 'Instagram', items: [] },
  { platform: 'TikTok', items: [] },
  { platform: 'VK', items: [] }
])

const newItem = ref(['', '', ''])
const editMode = ref(false)
const activeTab = ref(0)

const scheduleModal = ref(false)

function onScheduleApply({ startDate, days }) {
  alert("понеслась коза по кочкам");
}

function saveToHistory(platform) {
  const currentItems = [...plans.value.find(p => p.platform === platform).items]
  history.value[platform].push(currentItems)

  if (history.value[platform].length > 50) {
    history.value[platform].shift()
  }
}

function undoLastAction() {
  const currentPlatform = plans.value[activeTab.value].platform
  const platformHistory = history.value[currentPlatform]

  if (platformHistory.length > 0) {
    const previousState = platformHistory.pop()
    plans.value[activeTab.value].items = [...previousState]
  }
}

function handleKeyDown(e) {
  if (e.ctrlKey && e.key === 'z') {
    e.preventDefault()
    undoLastAction()
  }
}

onMounted(() => {
  window.addEventListener('keydown', handleKeyDown)
})

onUnmounted(() => {
  window.removeEventListener('keydown', handleKeyDown)
})

const addItem = (tabIndex) => {
  const text = newItem.value[tabIndex].trim()
  if (!text) return

  const platform = plans.value[tabIndex].platform
  saveToHistory(platform)

  plans.value[tabIndex].items.push({
    id: Date.now(),
    text,
    done: false,
    types: [],
    date: new Date()
  })
  newItem.value[tabIndex] = ''
}

const removeItem = (index) => {
  const platform = plans.value[activeTab.value].platform
  saveToHistory(platform)

  plans.value.forEach(plan => {
    plan.items.splice(index, 1)
  })
}

const handleDragMove = () => {
  if (!editMode.value) return false
}

const onDragEnd = () => {
  const platform = plans.value[activeTab.value].platform
  saveToHistory(platform)
}
</script>

<style scoped>
.add-btn {
  height: 38px;
  width: 38px;
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 0 !important;
  background-color: #4a2c40 !important;
}
.page-btn{
  background-color: #4a2c40 !important;
  padding: 10px;
  font-size: 12px;
  max-height: 40px;
  font-weight: 400;
  border-radius: 8px;
  border: none;
  transition: all 0.3s ease;
  color: #ffffff !important;
}
.shedule-btn{
  background-color: #4a2c40 !important;
  padding: 10px;
  font-size: 12px;
  max-height: 40px;
  font-weight: 400;
  border-radius: 8px;
  border: none;
  transition: all 0.3s ease;
  color: #ffffff !important;
  margin-left: 17px;
}
.main{
  border: none !important;
  background: rgba(255, 255, 255, 0.5) !important;
  border-radius: 18px !important;
  padding: 10px;
  height: auto;
  align-self: flex-start;
  width: 95%;
}
.custom-tabs :deep(.nav-link) {
  color: #4a2c40 !important;
  background-color: transparent !important;
  border-color: transparent !important;
}

.custom-tabs :deep(.nav-link.active) {
  color: white !important;
  background-color: #4a2c40 !important;
  border-color: #4a2c40 !important;
}
.add-item{
  display: flex;
}
</style>
