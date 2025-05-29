<script setup>
import { ref, computed, onMounted, onBeforeUnmount } from 'vue'
import { BToast } from 'bootstrap-vue-next'

const props = defineProps({
  buttonRef: {
    type: Object,
    default: null
  }
})

const visible = ref(false)
const toastPosition = ref({ right: '20px', top: '80px' })

const toastRef = ref(null)

const notifications = ref([
  {
    project: 'Проект Мяу',
    section: '1',
    topic: 'Открытие сезона',
    date: new Date().toISOString().split('T')[0]
  },
  {
    project: 'Проект Я',
    section: '4',
    topic: 'Открытие сезона',
    date: new Date().toISOString().split('T')[0]
  },
  {
    project: 'Проект ',
    section: '11',
    topic: 'Открытие Хочу',
    date: new Date().toISOString().split('T')[0]
  },
  {
    project: 'Проект ',
    section: '11',
    topic: 'Открытие лазанью',
    date: new Date().toISOString().split('T')[0]
  }
])

const filteredNotifications = computed(() => {
  const today = new Date().toISOString().split('T')[0]
  return notifications.value.filter(note => note.date === today)
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
      right: '20px',
      top: '80px'
    }
  }
}

const show = () => {
  updatePosition()
  visible.value = true
}

const hide = () => {
  visible.value = false
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

onMounted(() => {
  window.addEventListener('resize', handleResize)
  document.addEventListener('click', handleClickOutside)
})

onBeforeUnmount(() => {
  window.removeEventListener('resize', handleResize)
  document.removeEventListener('click', handleClickOutside)
})

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
      <div v-if="filteredNotifications.length" class="notifications-body">
        <div
            v-for="(note, index) in filteredNotifications"
            :key="index"
            class="notification-item"
        >
          <p class="mb-1"><strong>Сегодня публикация:</strong> {{ note.project }}</p>
          <p class="mb-0 text-muted">Пункт из КП: "{{ note.section }}", тема: "{{ note.topic }}"</p>
          <hr v-if="index < filteredNotifications.length - 1" />
        </div>
      </div>
      <div v-else class="text-muted px-2">На сегодня уведомлений нет</div>
    </BToast>
  </Teleport>
</template>

<style scoped>
.notifications-toast {
  max-height: 60vh;
  overflow-y: auto;
  width: 350px;
  z-index: 1100;
  box-shadow: 0 2px 10px rgba(0, 0, 0, 0.15);
  border: 1px solid #eee;
}

.notifications-body {
  padding: 0.75rem;
  max-height: 240px; /* ограничим высоту, чтобы скроллилось при 3+ уведомлениях */
  overflow-y: auto;
}

.notification-item {
  padding: 0.5rem 0;
}

.notification-item hr {
  margin: 0.5rem 0;
  opacity: 0.5;
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
</style>
