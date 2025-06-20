<script setup>
import { BBadge, BButton, BCard } from "bootstrap-vue-next";
import { format } from 'date-fns';
import { ru } from 'date-fns/locale';

const props = defineProps({
  project: {
    type: Object,
    required: true,
  },
});

const getTags = (project) => {
  return Object.keys(project.socialLinks).filter(key => project.socialLinks[key]).map(key => ({
    name: key,
    variant: getVariant(key)
  }));
}

// Функция для определения Bootstrap variant
const getVariant = (tag) => {
  switch (tag.toLowerCase()) {
    case 'tiktok':
      return 'dark'
    case 'vk':
      return 'primary'
    case 'youtube':
      return 'danger'
    case 'instagram':
      return 'warning'
    case 'telegram':
      return 'info'
    case 'yandex':
      return 'warning'
    default:
      return 'secondary'
  }
}

// Функция форматирования даты
const formatDate = (date) => {
  return format(new Date(date), 'd MMMM yyyy', { locale: ru });
}
</script>

<template>
  <router-link :to="{ name: 'project', params: { id: project.id } }" class="card-link">
    <div class="card-wrapper">
      <BCard tag="article" class="blur-card">
        <div class="card-image-container">
          <img :src="project.coverUrl || '/images/illustration.png'" alt="Card image" class="card-image" />
          <div class="image-gradient"></div>
          <div class="card-title">{{ project.name }} {{ project.is_archived ? '(В архиве)' : '' }}</div>
        </div>

        <div class="card-body">
          <div class="badges-container">
            <BBadge
                v-for="(tag, i) in getTags(project)"
                :key="i"
                :variant="tag.variant"
            >
              {{ tag.name }}
            </BBadge>
          </div>
          <div v-if="project.next_content_plan_item != null" class="publication-date">Публикация: {{ formatDate(project.next_content_plan_item.deadline) }}</div>
          <div v-if="project.next_content_plan_item == null" class="publication-date">Публикаций пока нет</div>
        </div>
      </BCard>
    </div>
  </router-link>
</template>

<style scoped>
.card-wrapper {
  max-width: 300px;
  max-height: 400px;
  transition: transform 0.3s ease;
}

.card-wrapper:hover {
  transform: scale(1.05);
  z-index: 1;
}

.card-image-container {
  position: relative;
  height: 140px;
  width: 100%;
  overflow: hidden;
}

.blur-card {
  border: none !important;
  background: rgba(255, 255, 255, 0.5) !important;
  border-radius: 18px !important;
  height: 100%;
}

.card-image {
  width: 100%;
  height: 100%;
  object-fit: cover;
  display: block;
}
.card-link {
  text-decoration: none;
  color: inherit;
  display: inline-block;
  width: 100%;
}
.image-gradient {
  position: absolute;
  bottom: 0;
  left: 0;
  right: 0;
  height: 70%;
  background: linear-gradient(to top, rgb(81, 57, 71), transparent);
}

.card-title {
  position: absolute;
  bottom: 15px;
  left: 15px;
  color: white;
  font-size: 25px;
  font-weight: 500;
  line-height: 25px;
  z-index: 2;
}

.card-body {
  padding: 1rem;
}

.badges-container {
  margin-bottom: 15px;
  display: flex;
  flex-wrap: wrap;
  gap: 5px;
}

.publication-date {
  font-size: 0.8rem;
  color: #6c757d;
}
</style>