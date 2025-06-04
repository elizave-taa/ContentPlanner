<script>
import { BContainer, BDropdown, BDropdownItem, BButton } from "bootstrap-vue-next"
import Notifications from "./Notifications.vue"
import { ref } from 'vue'

export default {
  components: {
    Notifications,
    BDropdown,
    BDropdownItem,
    BContainer,
    BButton
  },
  setup() {
    const notificationButton = ref(null)
    const notifications = ref(null)
    const unreadCount = ref(3)

    const showNotifications = () => {
      notifications.value.show()
      unreadCount.value = 0 // Сбрасываем счетчик при открытии уведомлений
    }

    return {
      notificationButton,
      notifications,
      unreadCount,
      showNotifications
    }
  },
  methods: {
    showDropdown(refName) {
      this.$refs[refName].show()
    },
    hideDropdown(refName) {
      this.$refs[refName].hide()
    },
    logout() {
      console.log('Выход из системы')
    }
  }
}
</script>

<template>
  <div class="global-header">
    <BContainer class="main-1">
      <div class="nav-item">
        <router-link class="logout-btn" to="/schedule">Расписание</router-link>
      </div>
      <div class="nav-item">
        <router-link class="logout-btn" to="/projects">Проекты</router-link>
      </div>

      <div class="notification-icon" ref="notificationButton" @click="showNotifications">
        <img src="/images/notifications.svg" alt="Уведомления">
        <span class="badge" v-if="unreadCount > 0">{{ unreadCount }}</span>
      </div>

      <Notifications :button-ref="notificationButton" ref="notifications" />

      <!-- Кнопка выхода -->
      <div class="nav-item">
        <router-link class="logout-btn" to="/logout">Выход</router-link>
      </div>
    </BContainer>
  </div>
</template>

<style scoped>
.global-header {
  padding: 6px 0;
  background-color: #4a2c40;
  position: relative;
  z-index: 10;
}
.main-1 {
  display: flex;
  align-items: center;
  width: 100%;
  margin: 0 auto;
  position: relative;
}
.nav-item, .nav-dropdown {
  color: white;
  padding: 8px 12px;
  font-size: 15px;
  font-weight: 200;
  cursor: pointer;
  line-height: 15px;
  margin-right: 5px;
}
.nav-dropdown >>> .dropdown-toggle {
  background: none !important;
  border: none !important;
  box-shadow: none !important;
  color: white !important;
  padding: 0 !important;
  font-weight: 200 !important;
  font-size: 15px !important;
}
.dropdown-text {
  display: inline-block;
}
.custom-caret {
  display: inline-block;
  width: 0;
  height: 0;
  margin-left: 8px;
  vertical-align: middle;
  border-top: 4px solid white;
  border-right: 4px solid transparent;
  border-left: 4px solid transparent;
  transition: transform 0.2s;
}
.nav-dropdown:hover .custom-caret {
  transform: rotate(180deg);
}
.nav-dropdown >>> .dropdown-menu {
  display: block;
  opacity: 0;
  visibility: hidden;
  transition: opacity 0.2s, visibility 0.2s;
  background-color: #5a3a50;
  border: none;
  margin-top: 0;
}
.nav-dropdown >>> .show .dropdown-menu,
.nav-dropdown:hover >>> .dropdown-menu {
  opacity: 1;
  visibility: visible;
}
.nav-dropdown >>> .dropdown-item {
  color: white !important;
  padding: 8px 16px;
}
.nav-dropdown >>> .dropdown-item:hover {
  background-color: rgba(255, 255, 255, 0.1);
}

.logout-btn {
  color: white !important;
  text-decoration: none;
  padding: 8px 16px;
  font-size: 15px;
  font-weight: 200;
  cursor: pointer;
  background: none !important;
  border: none !important;
}
.logout-btn:hover {
  text-decoration: underline;
}

.notification-icon {
  position: relative;
  margin-left: auto;
  cursor: pointer;
  padding: 8px 12px;
}

.badge {
  position: absolute;
  top: 4px;
  right: 4px;
  background-color: #ff4757;
  color: white;
  border-radius: 50%;
  width: 16px;
  height: 16px;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 10px;
  font-weight: bold;
}
.notification-icon {
  position: relative;
  margin-left: auto;
  cursor: pointer;
  padding: 8px 12px;
}
.badge {
  position: absolute;
  top: 4px;
  right: 4px;
  background-color: #ff4757;
  color: white;
  border-radius: 50%;
  width: 16px;
  height: 16px;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 10px;
  font-weight: bold;
}
</style>
