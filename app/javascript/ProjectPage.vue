<script>
import ContentPlan from './ContentPlan.vue'
import ContentPlanItem from "./ContentPlanItem.vue";
import GeneralNavBar from "./GeneralNavBar.vue";
export default {
  name: "ProjectPage",
  components: {GeneralNavBar, ContentPlanItem, ContentPlan},
};
</script>

<template>
  <div class="page-wrapper">
    <general-nav-bar></general-nav-bar>
    <div class="main-container">
      <content-plan></content-plan>
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
  flex: 1;
  width: 100%;
  max-width: 1200px;
  margin: 0 auto;
}
</style>

<style>
html, body {
  height: 100%;
  margin: 0;
  padding: 0;
}
</style>
