<script>
  import ContentPlan from './ContentPlan.vue'
  import ContentPlanItem from "./ContentPlanItem.vue";
  import GeneralNavBar from "./GeneralNavBar.vue";
  import ProjectInfo from "./ProjectInfo.vue";
  import ManageProject from "./ManageProject.vue";
  import AIHelper from "./AIHelper.vue";

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
    data() {
      return {
        project: {
          name: 'Проект Красота',
          url: 'https://example.com',
          comments: 'Проект ориентирован на молодую аудиторию. Важно учесть стиль и вовлеченность.',
          socialLinks: {
            telegram: 'https://t.me/example',
            instagram: '',
            vk: 'https://vk.com/example',
            youtube: 'https://youtube.com/example',
            tiktok: '',
            yandex: 'https://zen.yandex.ru/example'
          },
          photoMaterials: [
            { title: 'Фотосессия с мероприятия', url: 'https://example.com/photo1' },
            { title: 'Бэкстейдж', url: 'https://example.com/photo2' }
          ],
          mapLinks: [
            { url: 'https://yandex.ru/maps/?z=10&ll=37.62,55.75' }
          ],
          designLinks: [],
          references: [
            { url: 'https://instagram.com/creative' }
          ],
        },
      }
    },
    methods: {
      saveProject(project) {
        this.project = project
      },
      deleteProject() {
        console.log("deleteProject not implemented")
      },
      archiveProject() {
        console.log("archiveProject not implemented")
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
