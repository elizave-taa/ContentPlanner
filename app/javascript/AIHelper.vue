<template>
  <div class="ai-helper-container">
    <div class="ai-helper-header">
      <h3>AIHelper</h3>
      <div class="ai-icon">
        <svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
          <path d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm0 18c-4.41 0-8-3.59-8-8s3.59-8 8-8 8 3.59 8 8-3.59 8-8 8z" fill="currentColor"/>
          <path d="M12 6c-3.31 0-6 2.69-6 6s2.69 6 6 6 6-2.69 6-6-2.69-6-6-6zm0 10c-2.21 0-4-1.79-4-4s1.79-4 4-4 4 1.79 4 4-1.79 4-4 4z" fill="currentColor"/>
          <path d="M12 10c-1.1 0-2 .9-2 2s.9 2 2 2 2-.9 2-2-.9-2-2-2z" fill="currentColor"/>
        </svg>
      </div>
    </div>

    <BFormTextarea
        v-model="userInput"
        class="ai-textarea"
        placeholder="Кончились идеи? Спроси у ИИ..."
        rows="3"
        no-resize
    ></BFormTextarea>

    <BButton
        variant="primary"
        class="ai-button"
        :disabled="!userInput.trim()"
        @click="askAI"
    >
      Спросить
    </BButton>

    <div v-if="loading" class="ai-loading">
      <BSpinner small variant="primary"></BSpinner>
      <span>ИИ думает...</span>
    </div>

    <div v-if="response" class="ai-response">
      <h4>Ответ ИИ:</h4>
      <p>{{ response }}</p>
    </div>
  </div>
</template>

<script>
import { BFormTextarea, BButton, BSpinner } from 'bootstrap-vue-next'

export default {
  name: 'AIHelper',
  components: {
    BFormTextarea,
    BButton,
    BSpinner
  },
  data() {
    return {
      userInput: '',
      loading: false,
      response: null
    }
  },
  methods: {
    askAI() {
      if (!this.userInput.trim()) return

      this.loading = true
      this.response = null

      setTimeout(() => {
        this.response = `ИИ проанализировал ваш запрос "${this.userInput}" и предлагает следующие идеи:\n\n1. Провести конкурс среди подписчиков\n2. Создать серию сторис с закулисьем\n3. Запустить опрос о предпочтениях аудитории`
        this.loading = false
      }, 2000)
    }
  }
}
</script>

<style scoped>
.ai-helper-container {
  background-color: #fff;
  border-radius: 12px;
  padding: 20px;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
  margin-bottom: 20px;
  width: 95%;
}

.ai-helper-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  margin-bottom: 15px;
}

.ai-helper-header h3 {
  margin: 0;
  color: #4a2c40;
  font-weight: 600;
}

.ai-icon {
  color: #4a2c40;
}

.ai-textarea {
  width: 100%;
  margin-bottom: 15px;
  border: 1px solid #ddd;
  border-radius: 8px;
  padding: 12px;
  font-size: 14px;
}

.ai-textarea:focus {
  border-color: #4a2c40;
  box-shadow: 0 0 0 0.2rem rgba(74, 44, 64, 0.25);
}

.ai-textarea::placeholder {
  color: #999;
  font-style: italic;
}

.ai-button {
  width: 100%;
  background-color: #4a2c40!important;
  border: none;
  padding: 10px;
  font-weight: 500;
  border-radius: 8px;
}

.ai-button:hover {
  background-color: #5a3a50!important;
}

.ai-button:disabled {
  background-color: #cccccc;
  cursor: not-allowed;
}

.ai-loading {
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 10px;
  margin-top: 15px;
  color: #4a2c40;
}

.ai-response {
  margin-top: 20px;
  padding: 15px;
  background-color: #f9f9f9;
  border-radius: 8px;
  border-left: 4px solid #4a2c40;
}

.ai-response h4 {
  margin-top: 0;
  color: #4a2c40;
}

.ai-response p {
  white-space: pre-line;
  margin-bottom: 0;
}
</style>