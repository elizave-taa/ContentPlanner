<template>
  <div class="manage-project">
    <!-- Кнопка "Назначить сотрудника" -->
    <BButton
        class="action-btn"
        @click="showAssignModal = true"
    >
      Назначить сотрудника
    </BButton>

    <!-- Кнопка "Редактировать проект" -->
    <BButton
        class="action-btn"
        @click="showEditModal = true"
    >
      Редактировать проект
    </BButton>
    <EditProjectModal v-model="showEditModal"></EditProjectModal>

    <!-- Кнопка "В архив" -->
    <BButton
        class="action-btn"
        @click="showArchiveModal = true"
    >
      В архив
    </BButton>

    <!-- Кнопка "Удалить проект" -->
    <BButton
        class="action-btn remove"
        @click="showDeleteModal = true"
    >
      Удалить проект
    </BButton>

    <!-- Модальное окно назначения сотрудника -->
    <BModal
        v-model="showAssignModal"
        title="Назначение сотрудника"
        hide-footer
        centered
    >
      <template #footer>
        <BButton @click="showAssignModal = false">Копировать код</BButton>
        <BButton @click="deleteProject">Закрыть</BButton>
      </template>

      <div class="modal-content">
        <p>Отправьте этот код сотруднику:</p>
        <div class="code-display">{{ uniqueCode }}</div>
        <p class="small-text">Код действителен в течение 24 часов</p>
      </div>
    </BModal>

    <!-- Модальное окно удаления проекта -->
    <BModal
        v-model="showDeleteModal"
        title="Удаление проекта"
    >
      <template #footer>
        <BButton @click="showDeleteModal = false">Отмена</BButton>
        <BButton variant="danger" @click="deleteProject">Удалить</BButton>
      </template>

      <p>Вы уверены, что хотите удалить проект?</p>
      <p class="text-danger">Внимание: проект будет удален безвозвратно!</p>
    </BModal>

    <!-- Модальное окно архивации проекта -->
    <BModal
        v-model="showArchiveModal"
        title="Архивация проекта"
    >
      <template #footer>
        <BButton @click="showArchiveModal = false">Отмена</BButton>
        <BButton @click="archiveProject">Архивировать</BButton>
      </template>

      <p>Вы можете восстановить его позже</p>
    </BModal>
  </div>
</template>

<script>
import { BButton, BModal } from 'bootstrap-vue-next'
import EditProjectModal from "./EditProjectModal.vue";

export default {
  name: 'ManageProject',
  components: {
    EditProjectModal,
    BButton,
    BModal
  },
  data() {
    return {
      showAssignModal: false,
      showDeleteModal: false,
      showArchiveModal: false,
      uniqueCode: this.generateCode(),
      showEditModal: false,
    }
  },
  methods: {
    generateCode() {
      // Генерация 6-значного кода
      return Math.floor(100000 + Math.random() * 900000)
    },
    copyCode() {
      navigator.clipboard.writeText(this.uniqueCode)
      this.$bvToast.toast('Код скопирован в буфер обмена', {
        title: 'Успешно',
        variant: 'success',
        autoHideDelay: 3000
      })
    },
    editProject() {
      // Логика редактирования проекта
      this.$emit('edit-project')
    },
    deleteProject() {
      // Логика удаления проекта
      this.showDeleteModal = false
      this.$emit('project-deleted')
      this.$bvToast.toast('Проект успешно удален', {
        title: 'Успешно',
        variant: 'success',
        autoHideDelay: 5000
      })
    },
    archiveProject() {
      // Логика архивации проекта
      this.showArchiveModal = false
      this.$emit('project-archived')
      this.$bvToast.toast('Проект перемещен в архив', {
        title: 'Успешно',
        variant: 'success',
        autoHideDelay: 5000
      })
    }
  }
}
</script>

<style scoped>
.manage-project {
  display: flex;
  gap: 10px;
  border-radius: 8px;
  width: 100%;
}

.action-btn {
  padding: 10px;
  border-radius: 15px;
  font-weight: 400;
  font-size: 14px;
}

.action-btn {
  background-color: #4a2c40!important;
  border-color: #4a2c40!important;
}

.action-btn:hover {
  background-color: #5a3a50!important;
  border-color: #5a3a50!important;
}

.action-btn.remove {
  background-color: #5e0017 !important;
  border-color: #c13243 !important;
}

.action-btn.remove :hover {
  background-color: #5e0017 !important;
  border-color: #c13243 !important;
}

.modal-content {
  padding: 15px;
}

.code-display {
  font-size: 24px;
  font-weight: bold;
  text-align: center;
  letter-spacing: 2px;
  padding: 15px;
  background-color: #f0f0f0;
  border-radius: 5px;
  border: 1px dashed #ccc;
}

.small-text {
  font-size: 0.8rem;
  color: #6c757d;
  text-align: center;
}
</style>