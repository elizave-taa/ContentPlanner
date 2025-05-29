<script>
import { defineComponent } from "vue";
import { BIconPaperclip, BIconX } from 'bootstrap-icons-vue'
import {
  BBadge,
  BForm,
  BFormGroup,
  BFormInput,
  BFormCheckboxGroup,
  BModal,
  BButton,
  BFormTextarea, BFormFile,
} from "bootstrap-vue-next";
import DynamicLinksSection from "./DynamicLinksSection.vue";

export default defineComponent({
  components: {
    BFormFile, BIconPaperclip, BIconX, BFormTextarea, DynamicLinksSection, BBadge,
    BFormCheckboxGroup, BFormInput, BFormGroup, BForm, BModal, BButton
  },
  props: {
    projectToEdit: {
      type: Object,
      default: null
    }
  },
  data() {
    return {
      showModal: false,
      uploadedFiles: [],
      project: this.getDefaultProject(),
      socialOptions: [
        { text: 'Телеграм', value: 'telegram' },
        { text: 'Инстаграм', value: 'instagram' },
        { text: 'ВКонтакте', value: 'vk' },
        { text: 'YouTube', value: 'youtube'},
        { text: 'Tik Tok', value: 'tiktok'},
        { text: 'Яндекс Дзен', value: 'yandex'}
      ],
    }
  },
  computed: {
    selectedSocialNetworks() {
      return this.socialOptions.filter(option =>
          this.project.socialNetworks?.includes(option.value)
      );
    }
  },
  created() {
    // Автоматически загружаем тестовый проект при создании компонента
    if (!this.projectToEdit) {
      this.loadTestProject();
    }
  },
  watch: {
    projectToEdit: {
      immediate: true,
      handler(newVal) {
        if (newVal) {
          this.project = JSON.parse(JSON.stringify(newVal));
          if (newVal.files && newVal.files.length) {
            this.uploadedFiles = [...newVal.files];
          }
          this.showModal = true;
        }
      }
    }
  },
  methods: {
    getDefaultProject() {
      return {
        name: '',
        socialLinks: {
          telegram: '',
          instagram: '',
          vk: '',
          youtube: '',
          tiktok: '',
          yandex: ''
        },
        url: '',
        mapLinks: [],
        photoMaterials: [],
        references: [],
        designLinks: [],
        comments: '',
        files: [],
        socialNetworks: []
      };
    },

    // Загрузка тестового проекта
    loadTestProject() {
      this.project = {
        id: 1,
        name: 'Пример проекта',
        socialLinks: {
          telegram: 'https://t.me/example',
          instagram: 'https://instagram.com/example',
          vk: '',
          youtube: '',
          tiktok: '',
          yandex: ''
        },
        url: 'https://example.com',
        mapLinks: [
          { url: 'https://maps.google.com/?q=example' }
        ],
        photoMaterials: [
          { title: 'Главное фото', url: 'https://drive.google.com/photo1' }
        ],
        references: [
          { url: 'https://instagram.com/reference' }
        ],
        designLinks: [
          { url: 'https://figma.com/design' }
        ],
        comments: 'Это пример заполненного проекта для демонстрации',
        files: [],
        socialNetworks: ['telegram', 'instagram']
      };
      this.showModal = true;
    },

    truncateFileName(name) {
      const maxLength = 20;
      if (name.length > maxLength) {
        return `${name.substring(0, maxLength)}...${name.split('.').pop()}`;
      }
      return name;
    },
    handleFileUpload(event) {
      const newFiles = Array.from(event.target.files);
      this.uploadedFiles = [...this.uploadedFiles, ...newFiles];
      const dataTransfer = new DataTransfer();
      this.uploadedFiles.forEach(file => dataTransfer.items.add(file));
      this.project.files = dataTransfer.files;
    },
    formatFileNames(files) {
      return files.length ? `${files.length} файлов выбрано` : 'Выберите файлы'
    },
    formatFileSize(bytes) {
      if (bytes === 0) return '0 Bytes'
      const k = 1024
      const sizes = ['Bytes', 'KB', 'MB', 'GB']
      const i = Math.floor(Math.log(bytes) / Math.log(k))
      return parseFloat((bytes / Math.pow(k, i)).toFixed(2)) + ' ' + sizes[i]
    },
    openFile(file) {
      const fileURL = URL.createObjectURL(file)
      window.open(fileURL, '_blank')
    },
    removeFile(index) {
      this.uploadedFiles.splice(index, 1)
      const dataTransfer = new DataTransfer()
      this.uploadedFiles.forEach(file => dataTransfer.items.add(file))
      this.project.files = dataTransfer.files
    },
    saveProject() {
      this.project.files = this.uploadedFiles;
      this.$emit('project-saved', this.project);
      this.closeModal();
    },
    deleteProject() {
      this.$emit('project-deleted', this.project.id);
      this.closeModal();
    },
    closeModal() {
      this.showModal = false;
      this.project = this.getDefaultProject();
      this.uploadedFiles = [];
      this.$emit('modal-closed');
    }
  }
})
</script>

<template>
  <BModal
      v-model="showModal"
      :title="projectToEdit ? 'Редактирование проекта' : 'Создание проекта'"
      size="xl"
      modal-class="custom-modal"
      header-class="custom-modal-header"
      body-class="custom-modal-body"
      footer-class="custom-modal-footer"
  >
    <div class="projects-panel">
      <div class="left-container">
        <BForm>
          <BFormGroup label-for="project-name">
            <template #label>
              <span class="required-field-label">
                Название проекта
                <img
                    src="/images/necessarily.png"
                    alt="Обязательное поле"
                    class="required-icon"
                    title="Обязательное поле для заполнения"
                >
              </span>
            </template>
            <BFormInput id="project-name" v-model="project.name" required />
          </BFormGroup>

          <BFormGroup label-for="site-url">
            <template #label>
              <span> Ссылка на сайт </span>
            </template>
            <BFormInput id="site-url" v-model="project.url" required />
          </BFormGroup>

          <BFormGroup label="Дополнительные комментарии:" label-for="project-comments">
            <BFormTextarea
                id="project-comments"
                v-model="project.comments"
                rows="3"
            ></BFormTextarea>
          </BFormGroup>

          <BFormGroup>
            <template #label>
              <span class="required-field-label">
                Социальные сети
                <img
                    src="/images/necessarily.png"
                    alt="Обязательное поле"
                    class="required-icon"
                    title="Обязательное поле для заполнения"
                >
              </span>
            </template>

            <BFormCheckboxGroup
                v-model="project.socialNetworks"
                :options="socialOptions"
                stacked
                value-field="value"
                text-field="text"
            ></BFormCheckboxGroup>

            <div v-for="network in selectedSocialNetworks" :key="network.value" class="mt-3">
              <BFormGroup>
                <BFormInput
                    :id="`social-${network.value}`"
                    v-model="project.socialLinks[network.value]"
                    type="url"
                    :placeholder="`Введите ссылку на ${network.text}`"
                    class="small-input"
                />
              </BFormGroup>
            </div>
          </BFormGroup>
        </BForm>
      </div>
      <div class="right-container">
        <BForm>
          <DynamicLinksSection
              title="Материалы с фотографиями"
              v-model="project.photoMaterials"
              with-titles
          />

          <DynamicLinksSection
              title="Ссылки на карты"
              v-model="project.mapLinks"
          />

          <DynamicLinksSection
              title="Дизайн постов и сторис"
              v-model="project.designLinks"
          />

          <DynamicLinksSection
              title="Профили референсы"
              v-model="project.references"
          />

          <BFormGroup label="Дополнительные материалы:">
            <BFormFile
                v-model="project.files"
                multiple
                :file-name-formatter="formatFileNames"
                @change="handleFileUpload"
                class="mb-3"
            />

            <div v-if="uploadedFiles.length > 0" class="file-preview-container">
              <div class="file-grid">
                <div v-for="(file, index) in uploadedFiles" :key="index" class="file-item">
                  <div class="file-icon" @click="openFile(file)">
                    <BIconPaperclip class="clip-icon"/>
                  </div>
                  <div class="file-info">
                    <span class="file-name" :title="file.name">{{ truncateFileName(file.name) }}</span>
                    <span class="file-size">{{ formatFileSize(file.size) }}</span>
                  </div>
                  <BButton
                      @click="removeFile(index)"
                      variant="link"
                      class="remove-file-btn"
                  >
                    <BIconX class="text-danger"/>
                  </BButton>
                </div>
              </div>
            </div>
          </BFormGroup>
        </BForm>
      </div>
    </div>

    <template #modal-footer>
      <div class="w-100 d-flex justify-content-between">
        <BButton
            v-if="projectToEdit"
            variant="danger"
            @click="deleteProject"
        >
          Удалить проект
        </BButton>
        <div></div>
        <div>
          <BButton
              variant="secondary"
              @click="closeModal"
              class="mr-2"
          >
            Отмена
          </BButton>
          <BButton
              variant="primary"
              @click="saveProject"
          >
            {{ projectToEdit ? 'Сохранить изменения' : 'Создать проект' }}
          </BButton>
        </div>
      </div>
    </template>
  </BModal>
</template>

<style>
.small-input {
  padding: 0.25rem 0.5rem;
  font-size: 0.875rem;
  height: calc(1.2em + 0.5rem + 2px);
  line-height: 1.5;
}
.custom-modal .modal-content {
  background-color: #f8f9fa !important;
  border: none !important;
  border-radius: 18px !important;
}

.custom-modal-header {
  background-color: #4a2c40 !important;
  color: white !important;
  border-bottom: none !important;
  padding: 1.5rem !important;
  border-top-left-radius: 16px !important;
  border-top-right-radius: 16px !important;
}

.custom-modal-body {
  padding: 2rem !important;
  background-color: #f8f9fa !important;
}

.custom-modal-footer {
  border-top: none !important;
  padding: 1.5rem !important;
  background-color: #f8f9fa !important;
  border-bottom-left-radius: 16px !important;
  border-bottom-right-radius: 16px !important;
}

.required-field-label {
  display: flex;
  align-items: center;
  gap: 8px;
}

.required-icon {
  width: 16px;
  height: 16px;
}
.social-link-input {
  margin-top: 10px;
}
</style>

<style scoped>
.projects-panel {
  display: flex;
  justify-content: space-around;
}
.left-container {
  width: 40%;
}
.right-container {
  width: 40%;
}
.file-preview-container {
  border: 1px solid #dee2e6;
  border-radius: 4px;
  padding: 8px;
}

.file-grid {
  display: flex;
  flex-wrap: wrap;
  gap: 8px;
}

.file-item {
  display: flex;
  align-items: center;
  padding: 6px 10px;
  border: 1px solid #eee;
  border-radius: 4px;
  width: calc(50% - 12px);
  min-width: 200px;
  box-sizing: border-box;
  background-color: #f8f9fa;
}

.file-icon {
  cursor: pointer;
  margin-right: 8px;
  color: #6c757d;
  flex-shrink: 0;
}

.file-icon:hover {
  color: #0d6efd;
}

.clip-icon {
  font-size: 1.2rem;
}

.file-info {
  flex-grow: 1;
  display: flex;
  flex-direction: column;
  overflow: hidden;
}

.file-name {
  font-weight: 500;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}

.file-size {
  font-size: 0.8rem;
  color: #6c757d;
}

.remove-file-btn {
  padding: 0;
  margin-left: 8px;
  flex-shrink: 0;
}
</style>