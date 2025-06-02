<script>
import GeneralNavBar from "./GeneralNavBar.vue";
import ProjectCard from "./ProjectCard.vue";
import EditProjectModal from "./EditProjectModal.vue";
import AddExistingProject from "./AddExistingProject.vue";
import {
  BButton,
  BFormCheckboxGroup,
  BModal,
  BRow,
  BCol, BFormCheckbox
} from "bootstrap-vue-next";
import { createProject, fetchProjects } from './services/api';
import { ref } from 'vue';

export default {
  components: {
    BFormCheckbox,
    BModal,
    BButton,
    GeneralNavBar,
    ProjectCard,
    EditProjectModal,
    BFormCheckboxGroup,
    BRow,
    BCol, AddExistingProject
  },
  data() {
    return {
      showExistingModal: false,
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
      projects: []
    }
  },
  async created() {
    this.projects = await fetchProjects();
    console.log(this.projects)
  },
  methods: {
    getTags(project) {
      return Object.keys(project.socialLinks).filter(key => project.socialLinks[key]);
    },
    async saveProject(projectData) {
      this.showCreationModal = false;
      try {
        const createdProject = await createProject(projectData);
        this.projects.push(createdProject);
        console.log('Project created successfully:', createdProject);
      } catch (error) {
        console.error('Error creating project:', error);
      }
    },
    handleCodeSubmit(code) {
      this.submittedCode = code;
      console.log('Получен код:', code);
    }
  }
}
</script>

<template>
  <GeneralNavBar />
  <div class="app-container">
    <div>
    <div class="filter-panel">
      <h5 class="filter">Фильтры:</h5>

      <BFormCheckbox 
        class="filter-checkboxes">
        Архив
      </BFormCheckbox>  

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
    </div>
    <div class="buttons">
      <BButton @click="showCreationModal = true" class="add-project-card">
              <div class="add-project-content">
                <span>Создать проект</span>
              </div>
      </BButton>
      <EditProjectModal v-model="showCreationModal" @save-project="saveProject" />
      <BButton  class="add-project-card" @click="showExistingModal = true">
              <div class="add-project-content">
                <span>Добавить сущетсвующий</span>
              </div>
      </BButton>
      <AddExistingProject v-model="showExistingModal"
      @code-submitted="handleCodeSubmit"></AddExistingProject>
    </div>
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
              :title="project.name"
              :tags="getTags(project)"
              :date="project.created_at"
              :id="project.id"
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

.add-project-card{
  margin: 0 30px 10px 30px;
  background-color: #4a2c40!important;
  border-radius: 18px!important;
}

.buttons{
  display: flex;
  flex-direction: column;
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
  margin-bottom: 20px;
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
.archive {
  padding-bottom: 7px;
}

</style>
