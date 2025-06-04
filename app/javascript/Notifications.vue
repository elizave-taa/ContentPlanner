<script setup>
import { ref, computed, onMounted, onBeforeUnmount, watch } from 'vue'
import { BToast, BButton } from 'bootstrap-vue-next'

const props = defineProps({
  buttonRef: {
    type: Object,
    default: null
  },
  notifications: {
    type: Array,
    default: () => []
  }
})

const emit = defineEmits(['marked-as-read', 'refresh-requested'])

const visible = ref(false)
const toastPosition = ref({ right: '180px', top: '40px' })
const toastRef = ref(null)

const filteredNotifications = computed(() => {
  return props.notifications.filter(item => !item.posted)
})

const overdueCount = computed(() => {
  return filteredNotifications.value.filter(item => item.overdue).length
})

const todayCount = computed(() => {
  return filteredNotifications.value.filter(item => item.due_today && !item.overdue).length
})

const updatePosition = () => {
  if (props.buttonRef?.value) {
    const rect = props.buttonRef.value.getBoundingClientRect()
    toastPosition.value = {
      right: `${window.innerWidth - rect.right}px`,
      top: `${rect.bottom + window.scrollY}px`
    }
  } else {
    toastPosition.value = {
      right: '180px',
      top: '50px'
    }
  }
}

const show = () => {
  updatePosition()
  visible.value = true
  // Emit that notifications have been viewed
  emit('marked-as-read')
}

const hide = () => {
  visible.value = false
}

const refreshNotifications = () => {
  emit('refresh-requested')
}

const handleResize = () => {
  if (visible.value) updatePosition()
}

const handleClickOutside = (event) => {
  const toastEl = toastRef.value?.$el || toastRef.value
  if (visible.value && toastEl && !toastEl.contains(event.target)) {
    hide()
  }
}

const formatDate = (dateString) => {
  const date = new Date(dateString)
  const today = new Date()
  const yesterday = new Date(today)
  yesterday.setDate(yesterday.getDate() - 1)

  if (date.toDateString() === today.toDateString()) {
    return 'Сегодня'
  } else if (date.toDateString() === yesterday.toDateString()) {
    return 'Вчера'
  } else if (date < today) {
    const diffTime = Math.abs(today - date)
    const diffDays = Math.ceil(diffTime / (1000 * 60 * 60 * 24)) - 1
    return `${diffDays} дн. назад`
  } else {
    return date.toLocaleDateString('ru-RU', {day: '2-digit', month: '2-digit'})
  }
}

const getItemClass = (item) => {
  if (item.overdue) return 'notification-item overdue'
  if (item.due_today) return 'notification-item due-today'
  return 'notification-item'
}

onMounted(() => {
  window.addEventListener('resize', handleResize)
  document.addEventListener('click', handleClickOutside)
})

onBeforeUnmount(() => {
  window.removeEventListener('resize', handleResize)
  document.removeEventListener('click', handleClickOutside)
})

// Watch for notifications changes to update position if needed
watch(() => props.notifications, () => {
  if (visible.value) {
    updatePosition()
  }
}, { deep: true })

defineExpose({ show, hide })
</script>

<template>
  <Teleport to="body">
    <BToast
        ref="toastRef"
        v-model:visible="visible"
        title="Уведомления"
        :style="{
        position: 'fixed',
        right: toastPosition.right,
        top: toastPosition.top,
        'margin-top': '10px'
      }"
        no-auto-hide
        no-close-button
        solid
        variant="light"
        class="notifications-toast"
    >
      <template #header>
        <div class="d-flex justify-content-between align-items-center w-100">
          <strong>Уведомления</strong>
          <div class="d-flex align-items-center gap-2">
            <BButton
              size="sm"
              variant="outline-secondary"
              @click="refreshNotifications"
              title="Обновить"
            >
              <svg width="14" height="14" viewBox="0 0 16 16" fill="currentColor">
                <path d="M8 3a5 5 0 1 0 4.546 2.914.5.5 0 0 1 .908-.417A6 6 0 1 1 8 2v1z"/>
                <path d="M8 4.466V.534a.25.25 0 0 1 .41-.192l2.36 1.966c.12.1.12.284 0 .384L8.41 4.658A.25.25 0 0 1 8 4.466z"/>
              </svg>
            </BButton>
            <button type="button" class="btn-close" @click="hide" aria-label="Close"></button>
          </div>
        </div>
      </template>

      <div v-if="filteredNotifications.length" class="notifications-body">
        <div v-if="overdueCount > 0" class="notification-summary overdue-summary">
          <strong>Просрочено: {{ overdueCount }}</strong>
        </div>
        <div v-if="todayCount > 0" class="notification-summary today-summary">
          <strong>На сегодня: {{ todayCount }}</strong>
        </div>

                 <div
             v-for="(note, index) in filteredNotifications"
             :key="note.id"
             :class="[getItemClass(note), { 'has-border': index < filteredNotifications.length - 1 }]"
         >
           <div class="d-flex justify-content-between align-items-start">
             <div class="flex-grow-1">
               <p class="mb-1">
                 <span class="date-badge" :class="{ overdue: note.overdue, 'due-today': note.due_today }">
                   {{ formatDate(note.deadline) }}
                 </span>
                 <strong>{{ note.project_name }}</strong>
               </p>
               <p class="mb-0 text-muted">{{ note.platform_name }}: "{{ note.title }}"</p>
             </div>
             <div class="notification-status">
               <span v-if="note.overdue" class="status-badge overdue">Просрочено</span>
               <span v-else-if="note.due_today" class="status-badge today">Сегодня</span>
             </div>
           </div>
         </div>
      </div>
      <div v-else class="text-muted px-2 py-3 text-center">
        <svg width="48" height="48" viewBox="0 0 16 16" fill="currentColor" class="mb-2 opacity-50">
          <path d="M8 16A8 8 0 1 0 8 0a8 8 0 0 0 0 16zm.93-9.412-1 4.705c-.07.34.029.533.304.533.194 0 .487-.07.686-.246l-.088.416c-.287.346-.92.598-1.465.598-.703 0-1.002-.422-.808-1.319l.738-3.468c.064-.293.006-.399-.287-.47l-.451-.081.082-.381 2.29-.287zM8 5.5a1 1 0 1 1 0-2 1 1 0 0 1 0 2z"/>
        </svg>
        <div>На сегодня уведомлений нет</div>
      </div>
    </BToast>
  </Teleport>
</template>

<style scoped>
.notifications-toast {
  max-height: 70vh;
  overflow-y: auto;
  width: 380px;
  z-index: 1100;
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.15);
  border: 1px solid #eee;
}

.notifications-body {
  max-height: 400px;
  overflow-y: auto;
}

.notification-summary {
  padding: 0.5rem;
  margin-bottom: 0.5rem;
  border-radius: 0.25rem;
  font-size: 0.9rem;
}

.overdue-summary {
  background-color: #ffebee;
  color: #c62828;
  border-left: 4px solid #e53935;
}

.today-summary {
  background-color: #e3f2fd;
  color: #1565c0;
  border-left: 4px solid #2196f3;
}

.notification-item {
  padding: 0.75rem 0;
  transition: background-color 0.2s ease;
}

.notification-item:hover {
  background-color: rgba(0, 0, 0, 0.02);
}

.notification-item.overdue {
  border-left: 3px solid #e53935;
  padding-left: 1rem;
  background-color: rgba(255, 235, 238, 0.3);
}

.notification-item.due-today {
  border-left: 3px solid #2196f3;
  padding-left: 1rem;
  background-color: rgba(227, 242, 253, 0.3);
}

.date-badge {
  display: inline-block;
  padding: 0.1rem 0.4rem;
  border-radius: 0.25rem;
  font-size: 0.75rem;
  font-weight: 500;
  background-color: #f8f9fa;
  color: #6c757d;
  margin-right: 0.5rem;
}

.date-badge.overdue {
  background-color: #ffcdd2;
  color: #c62828;
}

.date-badge.due-today {
  background-color: #bbdefb;
  color: #1565c0;
}

.status-badge {
  padding: 0.2rem 0.5rem;
  border-radius: 0.25rem;
  font-size: 0.7rem;
  font-weight: 600;
  text-transform: uppercase;
}

.status-badge.overdue {
  background-color: #ffcdd2;
  color: #c62828;
}

.status-badge.today {
  background-color: #bbdefb;
  color: #1565c0;
}

.notification-item.has-border {
  border-bottom: 1px solid rgba(0, 0, 0, 0.1);
  padding-bottom: 0.75rem;
}

/* Стили скролла */
.notifications-body::-webkit-scrollbar {
  width: 6px;
}

.notifications-body::-webkit-scrollbar-track {
  background: #f1f1f1;
}

.notifications-body::-webkit-scrollbar-thumb {
  background: #888;
  border-radius: 3px;
}

.notifications-body::-webkit-scrollbar-thumb:hover {
  background: #555;
}

.btn-close {
  background: none;
  border: none;
  font-size: 1rem;
  opacity: 0.5;
  cursor: pointer;
}

.btn-close:hover {
  opacity: 0.8;
}
</style>
