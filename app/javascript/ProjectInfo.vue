<template>
  <div class="project-preview p-4 bg-white rounded shadow">
    <h2 class="mb-3">{{ project.name || 'Без названия' }}</h2>

    <div v-if="project.url" class="mb-3">
      <strong>Сайт:</strong>
      <a :href="project.url" target="_blank">{{ project.url }}</a>
    </div>

    <div v-if="hasSocialLinks" class="mb-3">
      <strong>Социальные сети:</strong>
      <div class="d-flex flex-wrap gap-2 mt-1">
        <BBadge
            v-for="(link, key) in project.socialLinks"
            v-if="link"
            :key="key"
            variant="info"
            class="text-truncate"
        >
          <a :href="link" target="_blank" class="text-white text-decoration-none">
            {{ getSocialName(key) }}
          </a>
        </BBadge>
      </div>
    </div>

    <div v-if="project.comments" class="mb-3">
      <strong>Комментарии:</strong>
      <p>{{ project.comments }}</p>
    </div>

    <div v-for="(section, key) in sections" :key="key" class="mb-3">
      <strong>{{ section.title }}:</strong>
      <ul v-if="project[key]?.length" class="mb-0">
        <li v-for="(item, index) in project[key]" :key="index">
          <a :href="item.url" target="_blank">{{ item.title || item.url }}</a>
        </li>
      </ul>
      <p v-else class="text-muted">Нет данных</p>
    </div>

    <div v-if="uploadedFiles?.length" class="mb-3">
      <strong>Загруженные файлы:</strong>
      <ul>
        <li
            v-for="(file, index) in uploadedFiles"
            :key="index"
        >
          <a :href="getFileUrl(file)" target="_blank">{{ file.name }}</a>
          <span class="text-muted ms-2">({{ formatFileSize(file.size) }})</span>
        </li>
      </ul>
    </div>
  </div>
</template>

<script>
import { defineComponent } from 'vue'
import { BBadge } from 'bootstrap-vue-next'

export default defineComponent({
  name: 'ProjectPreview',
  components: { BBadge },
  props: {
    project: {
      type: Object,
      required: true,
    },
    uploadedFiles: {
      type: Array,
      default: () => [],
    },
  },
  computed: {
    hasSocialLinks() {
      return Object.values(this.project.socialLinks || {}).some(Boolean)
    },
    sections() {
      return {
        photoMaterials: { title: 'Материалы с фотографиями' },
        mapLinks: { title: 'Ссылки на карты' },
        designLinks: { title: 'Дизайн постов и сторис' },
        references: { title: 'Профили-референсы' },
      }
    }
  },
  methods: {
    getSocialName(key) {
      const map = {
        telegram: 'Telegram',
        instagram: 'Instagram',
        vk: 'ВКонтакте',
        youtube: 'YouTube',
        tiktok: 'TikTok',
        yandex: 'Дзен'
      }
      return map[key] || key
    },
    getFileUrl(file) {
      return URL.createObjectURL(file)
    },
    formatFileSize(bytes) {
      if (!bytes) return '0 B'
      const sizes = ['B', 'KB', 'MB', 'GB']
      const i = Math.floor(Math.log(bytes) / Math.log(1024))
      return `${(bytes / Math.pow(1024, i)).toFixed(1)} ${sizes[i]}`
    }
  }
})
</script>

<style scoped>
.project-preview a {
  word-break: break-word;
}
</style>
