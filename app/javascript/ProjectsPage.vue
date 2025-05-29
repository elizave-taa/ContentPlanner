<script>
import GeneralNavBar from "./GeneralNavBar.vue";
import ProjectCard from "./ProjectCard.vue";
import ProjectCreationModal from "./ProjectCreationModal.vue";
import {
  BButton,
  BFormCheckboxGroup,
  BModal,
  BRow,
  BCol
} from "bootstrap-vue-next";

export default {
  components: {
    BModal,
    BButton,
    GeneralNavBar,
    ProjectCard,
    ProjectCreationModal,
    BFormCheckboxGroup,
    BRow,
    BCol
  },
  data() {
    return {
      selected1: [],
      options1: [
        { item: 'active', name: 'Активный' },
        { item: 'finished', name: 'Завершенный' },
      ],
      selected2: [],
      options2: [
        { item: 'vk', name: 'ВК' },
        { item: 'telegram', name: 'Telegram' },
        { item: 'instagram', name: 'Instagram' },
        { item: 'youtube', name: 'YouTube' },
        { item: 'yandex', name: 'Yandex' },
        { item: 'tiktok', name: 'Yandex' },
      ],
      selected3: [],
      specialists: [
        { item: '1', name: 'Специалист 1' },
        { item: '2', name: 'Специалист 2' },
      ],
      showModal: false,
      showCreationModal: false,
      projects: [
        {
          id: 1,
          title: 'Маркетинг в Telegram',
          tags: ['Telegram', 'Instagram', 'YouTube', 'VK'],
          date: '15.05.2025'
        },
        {
          id: 2,
          title: 'YouTube Кампания',
          tags: ['YouTube', 'VK'],
          date: '18.05.2025'
        },
        {
          id: 3,
          title: 'Запуск в Instagram',
          tags: ['Instagram'],
          date: '20.05.2025'
        },
        {
          id: 4,
          title: 'VK + Telegram Продвижение',
          tags: ['VK', 'Telegram'],
          date: '22.05.2025'
        },
        {
          id: 5,
          title: 'Полный медиа-пакет',
          tags: ['Telegram', 'YouTube', 'VK', 'Instagram'],
          date: '25.05.2025'
        }
      ]
    }
  },
}
</script>

<template>
  <GeneralNavBar />
  <div class="app-container">
    <div class="filter-panel">
      <h5 class="filter">Фильтры:</h5>

      <h6 class="titles">Статус проекта</h6>
      <BFormCheckboxGroup
          v-model="selected1"
          :options="options1"
          value-field="item"
          text-field="name"
          stacked
          class="filter-checkboxes"
      />

      <h6 class="titles">Соц. сети</h6>
      <BFormCheckboxGroup
          v-model="selected2"
          :options="options2"
          value-field="item"
          text-field="name"
          stacked
          class="filter-checkboxes"
      />

      <h6 class="titles">Специалисты</h6>
      <BFormCheckboxGroup
          v-model="selected3"
          :options="specialists"
          value-field="item"
          text-field="name"
          stacked
          class="filter-checkboxes"
      />

      <BButton @click="showCreationModal = true" class="create-btn">
        Добавить проект
      </BButton>
      <ProjectCreationModal v-model="showCreationModal" />
    </div>

    <div class="projects-panel">
      <BRow class="g-3">
        <BCol
            v-for="project in projects"
            :key="project.id"
            cols="12"
            md="6"
            lg="4"
        >
          <ProjectCard
              :title="project.title"
              :tags="project.tags"
              :date="project.date"
          />
        </BCol>
      </BRow>
    </div>
  </div>
</template>

<style scoped>
.app-container {
  background-color: #e3c3d4;
  min-height: 100vh;
  display: flex;
  align-items: flex-start;
  padding-bottom: 30px;
}

.filter-panel {
  background: rgba(255, 255, 255, 0.3);
  backdrop-filter: blur(25px);
  border-radius: 18px;
  width: 20%;
  min-width: 250px;
  box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);
  padding: 20px;
  margin: 30px;
  flex-shrink: 0;
  height: auto;
}

.projects-panel {
  margin: 30px 30px 30px 0;
  width: 70%;
  flex-grow: 1;
}

.filter-checkboxes {
  color: #4a2c40;
  font-weight: 400;
  margin-bottom: 20px;
}

.titles {
  color: #4a2c40;
  font-weight: 400;
  margin-top: 15px;
  margin-bottom: 10px;
}

.filter {
  color: #4a2c40;
  margin-bottom: 20px;
}

.create-btn {
  background-color: #4a2c40 !important;
  padding: 0.75rem;
  font-size: 1rem;
  font-weight: 400;
  border-radius: 8px;
  border: none;
  transition: all 0.3s ease;
  color: #ffffff !important;
  margin-bottom: 20px;
}

.create-btn:hover {
  background-color: rgb(129, 78, 109) !important;
  transform: translateY(-2px);
}
</style>
