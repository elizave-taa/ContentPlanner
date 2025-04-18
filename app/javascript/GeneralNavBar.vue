<template>
  <div class="global-header">
    <BContainer class="main-1">
      <div class="nav-item">
        <span class="dropdown-text">Расписание</span>
      </div>
      <BDropdown
          class="nav-dropdown"
          ref="projectsDropdown"
          @mouseenter="showDropdown('projectsDropdown')"
          @mouseleave="hideDropdown('projectsDropdown')"
          no-caret
      >
        <template #button-content>
          <span class="dropdown-text">Мои проекты</span>
          <span class="custom-caret"></span>
        </template>
        <BDropdownItem>Проект 1</BDropdownItem>
        <BDropdownItem>Проект 2</BDropdownItem>
      </BDropdown>

      <!-- Специалисты (со стрелкой) -->
      <BDropdown
          class="nav-dropdown"
          ref="specialistsDropdown"
          @mouseenter="showDropdown('specialistsDropdown')"
          @mouseleave="hideDropdown('specialistsDropdown')"
          no-caret
      >
        <template #button-content>
          <span class="dropdown-text">Специалисты</span>
          <span class="custom-caret"></span>
        </template>
        <BDropdownItem>Специалист 1</BDropdownItem>
        <BDropdownItem>Специалист 2</BDropdownItem>
      </BDropdown>
    </BContainer>
  </div>
</template>

<style scoped>
.global-header {
  padding: 6px 0;
  background-color: #4a2c40;
  position: relative;
  z-index: 10;
}
.main-1 {
  display: flex;
  align-items: center;
  width: 100%;
  margin: 0 auto;
}
.nav-item, .nav-dropdown {
  color: white;
  padding: 8px 12px;
  font-size: 15px;
  font-weight: 200;
  cursor: pointer;
  line-height: 15px;
  margin-right: 40px;
}
.nav-dropdown >>> .dropdown-toggle {
  background: none !important;
  border: none !important;
  box-shadow: none !important;
  color: white !important;
  padding: 0 !important;
  font-weight: 200 !important;
  font-size: 15px !important;
}
.dropdown-text {
  display: inline-block;
}
.custom-caret {
  display: inline-block;
  width: 0;
  height: 0;
  margin-left: 8px;
  vertical-align: middle;
  border-top: 4px solid white;
  border-right: 4px solid transparent;
  border-left: 4px solid transparent;
  transition: transform 0.2s;
}
.nav-dropdown:hover .custom-caret {
  transform: rotate(180deg);
}
.nav-dropdown >>> .dropdown-menu {
  display: block;
  opacity: 0;
  visibility: hidden;
  transition: opacity 0.2s, visibility 0.2s;
  background-color: #5a3a50;
  border: none;
  margin-top: 0;
}
.nav-dropdown >>> .show .dropdown-menu,
.nav-dropdown:hover >>> .dropdown-menu {
  opacity: 1;
  visibility: visible;
}
.nav-dropdown >>> .dropdown-item {
  color: white !important;
  padding: 8px 16px;
}
.nav-dropdown >>> .dropdown-item:hover {
  background-color: rgba(255, 255, 255, 0.1);
}
</style>

<script>
import {BContainer, BDropdown, BDropdownItem} from "bootstrap-vue-next";

export default {
  components: {BDropdown, BDropdownItem, BContainer},
  methods: {
    showDropdown(refName) {
      this.$refs[refName].show();
    },
    hideDropdown(refName) {
      this.$refs[refName].hide();
    }
  }
}
</script>