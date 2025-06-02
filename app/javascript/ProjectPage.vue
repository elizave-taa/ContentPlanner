<script>
  import ContentPlan from './ContentPlan.vue'
  import ContentPlanItem from "./ContentPlanItem.vue";
  import GeneralNavBar from "./GeneralNavBar.vue";
  import ProjectInfo from "./ProjectInfo.vue";
  import ManageProject from "./ManageProject.vue";
  import AIHelper from "./AIHelper.vue";
  import { archiveProject, deleteProject, fetchProject, updateProject } from './services/api';

  export default {
    name: "ProjectPage",
    components: {
      AIHelper,
      ManageProject,
      GeneralNavBar,
      ContentPlanItem,
      ContentPlan,
      ProjectInfo,
    },
    props: {
      id: {
        type: String,
        required: true
      }
    },
    data() {
      return {
        project: {
          
        },
      }
    },
    async created() {
      this.project = await fetchProject(this.id);
    },
    methods: {
      saveProject(project) {
        this.project = project
        updateProject(this.id, project)
      },
      async deleteProject() {
        try {
          await deleteProject(this.id);
          alert('Проект удален');
          this.$router.push('/projects');
        } catch (error) {
          alert('Ошибка при удалении проекта');
        }
      },
      async archiveProject() {
        try {
          this.project = await archiveProject(this.id, true);
          alert('Проект перемещен в архив');
          this.$router.push('/projects');
        } catch (error) {
          alert('Ошибка при перемещении в архив');
        }
      }
    }
  }
</script>

<template>
  <div class="page-wrapper">
    <general-nav-bar />

    <div class="main-container">
      <div class="column left-column">
        <content-plan />
        <a-i-helper />
      </div>

      <div class="column right-column">
        <manage-project :project="project" @save-project="saveProject" @delete-project="deleteProject" @archive-project="archiveProject" />
        <project-info :project="project"/>
      </div>
    </div>
  </div>
</template>


<style scoped>
.page-wrapper {
  display: flex;
  flex-direction: column;
  min-height: 100vh;
  background-color: #e3c3d4;
}

.main-container {
  display: flex;
  flex-direction: row;
  gap: 20px;
  max-width: 1300px;
  width: 100%;
  margin: 0 auto;
  padding: 30px;
}

.column {
  display: flex;
  flex-direction: column;
  gap: 20px;
  flex: 1;
}

.left-column,
.right-column {
  flex: 1;
}
</style>
