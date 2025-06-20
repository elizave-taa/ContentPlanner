<template>
  <div class="main">
    <div class="d-flex justify-content-between align-items-center mb-3">
      <BTabs v-model="activeTab" pills card class="custom-tabs">
        <BTab v-for="(plan, index) in plans" :key="index" :title="getPlatformDisplayName(plan.platform)"/>
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
        <div v-if="plan.items.length === 0" class="text-muted">
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
              @update:modelValue="updateItem"
              @remove="removeItem(element.id)"
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
      <div class="d-flex">
        <BButton size="sm" @click="scheduleModal = true" class="shedule-btn">
          Настроить расписание
        </BButton>
      </div>
    </div>

    <AutoScheduleModal
        :modelValue="scheduleModal"
        :projectId="projectId"
        @apply="onScheduleApply"
        @update:modelValue="val => scheduleModal = val"
    />
  </div>
</template>

<script>
import { BTabs, BTab, BFormInput, BButton } from 'bootstrap-vue-next'
import ContentPlanItem from './ContentPlanItem.vue'
import AutoScheduleModal from './AutoScheduleModal.vue'
import draggable from 'vuedraggable'
import 'bootstrap-icons/font/bootstrap-icons.css'
import {
  fetchContentPlanItems,
  createContentPlanItem,
  updateContentPlanItem,
  deleteContentPlanItem,
  toggleContentPlanItemPosted,
  upsertSchedule
} from './services/api'

export default {
  name: 'ContentPlanner',
  components: {
    BTabs,
    BTab,
    BFormInput,
    BButton,
    ContentPlanItem,
    AutoScheduleModal,
    draggable,
  },
  props: {
    projectId: {
      type: [String, Number],
      required: true,
    },
    projectSocialLinks: {
      type: Object,
      required: true,
    },
  },
  data() {
    return {
      plans: [],             // [ { platform: 'telegram', items: [] }, ... ]
      newItem: [],           // e.g. ['', '', ...]
      editMode: false,
      activeTab: 0,
      scheduleModal: false,
      platformMapping: {
        'telegram': 'telegram',
        'instagram': 'instagram',
        'vk': 'vkontakte',
        'youtube': 'youtube',
        'tiktok': 'tiktok',
        'yandex': 'yandex_zen'
      },
      reverseMapping: {
        'telegram': 'telegram',
        'instagram': 'instagram',
        'vkontakte': 'vk',
        'youtube': 'youtube',
        'tiktok': 'tiktok',
        'yandex_zen': 'yandex'
      }
    }
  },
  async created() {
    await this.initializePlans()
    await this.loadContentPlanItems()
  },
  watch: {
    projectSocialLinks: {
      deep: true,
      async handler() {
        await this.initializePlans()
        await this.loadContentPlanItems()
      }
    }
  },
  methods: {
    async initializePlans() {
      // Build plans array from projectSocialLinks
      this.plans = Object.keys(this.projectSocialLinks || {})
        .filter((key) => this.projectSocialLinks[key])
        .map((key) => ({
          platform: this.platformMapping[key] || key,
          items: []
        }))

      // newItem array length should match number of platforms
      this.newItem = this.plans.map(() => '')
    },

    async loadContentPlanItems() {
      try {
        const items = await fetchContentPlanItems(this.projectId)

        // Group items by platform and sort by deadline
        this.plans.forEach(plan => {
          plan.items = items
            .filter(item => item.platform === plan.platform)
            .map(item => this.transformApiItemToFrontend(item))
            .sort((a, b) => {
              // Sort by deadline, then by created date
              if (!a.deadline && !b.deadline) return new Date(a.created_at) - new Date(b.created_at)
              if (!a.deadline) return 1
              if (!b.deadline) return -1
              return new Date(a.deadline) - new Date(b.deadline)
            })
        })
      } catch (error) {
        console.error('Error loading content plan items:', error)
      }
    },

    transformApiItemToFrontend(apiItem) {
      return {
        id: apiItem.id,
        title: apiItem.title,
        text: apiItem.title, // For backward compatibility
        posted: apiItem.posted,
        done: apiItem.posted, // For backward compatibility
        deadline: apiItem.deadline,
        date: apiItem.deadline ? new Date(apiItem.deadline) : null, // For backward compatibility
        platform: apiItem.platform,
        tags: apiItem.tags || [],
        types: apiItem.tags || [], // For backward compatibility
        created_at: apiItem.created_at,
        updated_at: apiItem.updated_at
      }
    },

    transformFrontendItemToApi(frontendItem) {
      return {
        id: frontendItem.id,
        title: frontendItem.title || frontendItem.text,
        posted: frontendItem.posted || frontendItem.done || false,
        deadline: frontendItem.deadline || (frontendItem.date ? frontendItem.date.toISOString().split('T')[0] : null),
        platform: frontendItem.platform,
        tags: frontendItem.tags || frontendItem.types || []
      }
    },

    getPlatformDisplayName(platform) {
      const displayNames = {
        'telegram': 'Telegram',
        'instagram': 'Instagram',
        'vkontakte': 'ВКонтакте',
        'youtube': 'YouTube',
        'tiktok': 'TikTok',
        'yandex_zen': 'Яндекс Дзен'
      }
      return displayNames[platform] || platform
    },

    getTodayDate() {
      return new Date().toISOString().split('T')[0]
    },

    async addItem(tabIndex) {
      const text = this.newItem[tabIndex].trim()
      if (!text) return

      const platform = this.plans[tabIndex].platform

      try {
        const newItemData = {
          title: text,
          posted: false,
          deadline: this.getTodayDate(), // Set today as default deadline
          platform: platform,
          tags: []
        }

        const createdItem = await createContentPlanItem(this.projectId, newItemData)
        const frontendItem = this.transformApiItemToFrontend(createdItem)

        this.plans[tabIndex].items.push(frontendItem)
        this.sortPlanItems(tabIndex)
        this.newItem[tabIndex] = ''
      } catch (error) {
        console.error('Error creating content plan item:', error)
        alert('Ошибка при создании публикации')
      }
    },

    async updateItem(updatedItem) {
      try {
        const apiData = this.transformFrontendItemToApi(updatedItem)
        const responseItem = await updateContentPlanItem(updatedItem.id, apiData)

        // Find and update the item in the plans
        this.plans.forEach((plan, planIndex) => {
          const itemIndex = plan.items.findIndex(item => item.id === updatedItem.id)
          if (itemIndex !== -1) {
            plan.items[itemIndex] = this.transformApiItemToFrontend(responseItem)
            this.sortPlanItems(planIndex)
          }
        })
      } catch (error) {
        console.error('Error updating content plan item:', error)
        alert('Ошибка при обновлении публикации')
      }
    },

    async removeItem(itemId) {
      try {
        await deleteContentPlanItem(itemId)

        // Remove from frontend
        this.plans.forEach(plan => {
          const index = plan.items.findIndex(item => item.id === itemId)
          if (index !== -1) {
            plan.items.splice(index, 1)
          }
        })
      } catch (error) {
        console.error('Error deleting content plan item:', error)
        alert('Ошибка при удалении публикации')
      }
    },

    async toggleItemPosted(itemId) {
      try {
        const responseItem = await toggleContentPlanItemPosted(itemId)

        // Update in frontend
        this.plans.forEach(plan => {
          const item = plan.items.find(item => item.id === itemId)
          if (item) {
            item.posted = responseItem.posted
            item.done = responseItem.posted // For backward compatibility
          }
        })
      } catch (error) {
        console.error('Error toggling posted status:', error)
        alert('Ошибка при изменении статуса публикации')
      }
    },

    sortPlanItems(tabIndex) {
      this.plans[tabIndex].items.sort((a, b) => {
        // Sort by deadline, then by created date
        if (!a.deadline && !b.deadline) return new Date(a.created_at) - new Date(b.created_at)
        if (!a.deadline) return 1
        if (!b.deadline) return -1
        return new Date(a.deadline) - new Date(b.deadline)
      })
    },

    async onScheduleApply({ startDate, days }) {
      try {
        const scheduleData = {
          startDate: new Date(startDate),
          weekdays: days
        }
        await upsertSchedule(this.projectId, scheduleData)
        this.scheduleModal = false
        this.loadContentPlanItems()
      } catch (error) {
        console.error('Error applying schedule:', error)
        alert('Ошибка при применении расписания')
      }
    },

    handleDragMove() {
      if (!this.editMode) return false
    },

    onDragEnd() {
      // Auto-sort after drag ends
      this.sortPlanItems(this.activeTab)
    },

    async clearPlan(index) {
      if (!confirm('Вы уверены, что хотите очистить контент-план для этой платформы?')) return

      try {
        // Delete all items for this platform
        const itemsToDelete = this.plans[index].items.slice()
        for (const item of itemsToDelete) {
          await deleteContentPlanItem(item.id)
        }

        this.plans[index].items = []
      } catch (error) {
        console.error('Error clearing content plan:', error)
        alert('Ошибка при очистке контент-плана')
      }
    },
  },
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
