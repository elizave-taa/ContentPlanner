<template>
  <div class="project-preview p-4">
    <div class="cover-container mb-3">
      <div
          class="cover-content"
          :style="{
          backgroundImage: coverFile
            ? `linear-gradient(to top, rgba(0,0,0,0.6), rgba(0,0,0,0)), url(${coverUrl})`
            : 'none',
          backgroundColor: coverFile ? 'transparent' : defaultColor
        }"
      >
        <div class="cover-actions">
          <label class="icon-button me-2" title="Заменить обложку">
            <svg width="16" height="16" viewBox="0 0 16 16" fill="currentColor" class="me-1">
              <path d="M12.146.146a.5.5 0 0 1 .708 0l3 3a.5.5 0 0 1 0 .708l-10 10a.5.5 0 0 1-.168.11l-5 2a.5.5 0 0 1-.65-.65l2-5a.5.5 0 0 1 .11-.168l10-10zM11.207 2.5L13.5 4.793 14.793 3.5 12.5 1.207 11.207 2.5zm1.586 3L10.5 3.207 4 9.707V10h.5a.5.5 0 0 1 .5.5v.5h.5a.5.5 0 0 1 .5.5v.5h.293l6.5-6.5zm-9.761 5.175l-.106.106-1.528 3.821 3.821-1.528.106-.106A.5.5 0 0 1 5 12.5V12h-.5a.5.5 0 0 1-.5-.5V11h-.5a.5.5 0 0 1-.468-.325z"/>
            </svg>
            <input type="file" accept="image/*" @change="onCoverChange" hidden />
          </label>
          <label class="icon-button" @click="removeCover" title="Удалить обложку">
            <svg width="16" height="16" viewBox="0 0 16 16" fill="currentColor" class="me-1">
              <path d="M5.5 5.5A.5.5 0 0 1 6 6v6a.5.5 0 0 1-1 0V6a.5.5 0 0 1 .5-.5zm2.5 0a.5.5 0 0 1 .5.5v6a.5.5 0 0 1-1 0V6a.5.5 0 0 1 .5-.5zm3 .5a.5.5 0 0 0-1 0v6a.5.5 0 0 0 1 0V6z"/>
              <path fill-rule="evenodd" d="M14.5 3a1 1 0 0 1-1 1H13v9a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V4h-.5a1 1 0 0 1-1-1V2a1 1 0 0 1 1-1H6a1 1 0 0 1 1-1h2a1 1 0 0 1 1 1h3.5a1 1 0 0 1 1 1v1zM4.118 4L4 4.059V13a1 1 0 0 0 1 1h6a1 1 0 0 0 1-1V4.059L11.882 4H4.118zM2.5 3V2h11v1h-11z"/>
            </svg>
          </label>
        </div>
        <h2 class="project-title">{{ project.name || 'Без названия' }}</h2>
      </div>
    </div>

    <!-- Основная информация -->
    <div v-if="project.url" class="mb-3">
      <strong>Сайт: </strong>
      <a :href="project.url" target="_blank">{{ project.url }}</a>
    </div>

    <div v-if="hasSocialLinks" class="mb-3">
      <strong>Социальные сети:</strong>
      <div class="d-flex flex-wrap gap-2 mt-1">
        <BBadge
            v-for="(link, key) in socialLinks"
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
        <li v-for="(item, index) in project[key]" :key="index" :style="item._destroy ? 'display: none;' : ''">
          <a :href="item.url" target="_blank">{{ item.title || item.url }}</a>
        </li>
      </ul>
      <p v-else class="text-muted">Нет данных</p>
    </div>

    <div class="mb-3" v-if="project.specialists?.length">
      <strong>Назначенные специалисты:</strong>
      <ul class="mb-0">
        <li v-for="(person, index) in project.specialists" :key="index">
          {{ person.name }} <span class="text-muted">({{ person.role }})</span>
        </li>
      </ul>
    </div>

    <div v-if="project.files?.length" class="mb-3">
      <strong>Загруженные файлы:</strong>
      <ul>
        <li v-for="(file, index) in project.files" :key="index" :style="file._destroy ? 'display: none;' : ''">
          <a :href="getFileUrl(file.data)" target="_blank">{{ file.name }}</a>
          <span class="text-muted ms-2">({{ formatFileSize(file.data.size) }})</span>
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
  },
  data() {
    return {
      defaultColor: '#513947', // Фирменный цвет
      defaultCover: '', // можно оставить пустым, если цвет
      coverFile: null,
    }
  },
  computed: {
    socialLinks() {
      return Object.fromEntries(
        Object.entries(this.project.socialLinks || {}).filter(([_, value]) => value)
      );
    },
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
    },
    coverUrl() {
      if (this.coverFile) return URL.createObjectURL(this.coverFile)
      return this.project.coverUrl || this.defaultCover
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
        yandex: 'Дзен',
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
    },
    onCoverChange(event) {
      const file = event.target.files[0]
      if (file) this.coverFile = file
    },
    removeCover() {
      this.coverFile = null
    },
  },
})
</script>

<style scoped>
.project-preview {
  border: none !important;
  background: rgba(255, 255, 255, 0.5) !important;
  border-radius: 18px !important;
  width: 95% !important;
}

.project-preview a {
  word-break: break-word;
}

.cover-container {
  border-radius: 18px;
  overflow: hidden;
}

.cover-content {
  position: relative;
  height: 200px;
  background-size: cover;
  background-position: center;
  border-radius: 18px;
  display: flex;
  align-items: flex-end;
  justify-content: left;
  padding: 20px;
  color: white;
  text-align: center;
  transition: background-image 0.3s ease;
}

.project-title {
  font-size: 2rem;
  font-weight: 400;
  text-align: left;
}

.cover-actions {
  position: absolute;
  top: 10px;
  right: 10px;
  display: flex;
  gap: 8px;
  z-index: 2;
}

.icon-button {
  border: none;
  border-radius: 8px;
  padding: 4px 6px;
  cursor: pointer;
  font-size: 16px;
  transition: background 0.2s ease-in-out;
}
.icon-button:hover {
  background: rgb(154, 120, 144);
}
</style>
