<script>
import GeneralNavBar from "./GeneralNavBar.vue";
import ProjectCard from "./ProjectCard.vue";
import { BFormCheckboxGroup } from "bootstrap-vue-next";

export default {
  components: {
    GeneralNavBar,
    ProjectCard,
    BFormCheckboxGroup
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
      ]
    }
  }
}
</script>

<template>
  <GeneralNavBar></GeneralNavBar>
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
      ></BFormCheckboxGroup>

      <h6 class="titles">Соц. сети</h6>
      <BFormCheckboxGroup
          v-model="selected2"
          :options="options2"
          value-field="item"
          text-field="name"
          stacked
          class="filter-checkboxes"
      ></BFormCheckboxGroup>
    </div>
    <div class="projects-panel">
      <ProjectCard></ProjectCard>
    </div>
  </div>
</template>

<style scoped>
.app-container {
  background-color: #e3c3d4;
  min-height: 100vh;
  display: flex;
  align-items: flex-start; /* Выравнивание по верху */
  padding-bottom: 30px; /* Добавляем отступ снизу */
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
</style>