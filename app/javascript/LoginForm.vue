<script>
import {BButton, BForm, BFormGroup, BFormInput} from "bootstrap-vue-next";
import { useRouter } from 'vue-router';
import { login } from './services/api';

export default {
  components: {BButton, BFormInput, BFormGroup, BForm},
  setup() {
    const router = useRouter();
    return { router };
  },
  data() {
    return {
      form: {
        email: '',
        password: '',
      },
      error: null
    }
  },
  methods: {
    async handleLogin() {
      try {
        this.error = null;
        const response = await login(this.form.email, this.form.password);
        localStorage.setItem('user', JSON.stringify(response.user));
        this.router.push('/projects');
      } catch (error) {
        this.error = error.message;
      }
    }
  }
}
</script>

<template>
  <BForm @submit.prevent="handleLogin">
    <div v-if="error" class="alert alert-danger">{{ error }}</div>
    <BFormGroup
        id="input-group-1"
        label="Введите email:"
        label-for="input-1"
        class="mb-3 custom-label"
    >
      <BFormInput
          id="input-1"
          v-model="form.email"
          type="email"
          placeholder="Email"
          required
      ></BFormInput>
    </BFormGroup>

    <BFormGroup
        id="input-group-2"
        label="Введите пароль:"
        label-for="input-2"
        class="mb-3 custom-label">
      <BFormInput
          id="input-2"
          type="password"
          v-model="form.password"
          placeholder="Пароль"
          required
      ></BFormInput>
    </BFormGroup>
    <BButton type="submit" class="login-btn" variant="primary">Войти</BButton>
  </BForm>
  <label class="registration"> Еще нет аккаунта? <router-link class="link" to="registration"><u class="link">Регистрация</u></router-link></label>
</template>

<style scoped>
.login-btn {
  background-color: rgba(255, 255, 255, 0.7) !important;
  width: 70%;
  padding: 0.75rem;
  font-size: 1rem;
  font-weight: 600;
  border-radius: 8px;
  border: none;
  transition: all 0.3s ease;
  color: #4a2c40 !important;
  margin-bottom: 20px;
}
.login-btn:hover {
  background-color: rgba(255, 255, 255, 0.8) !important;
  transform: translateY(-2px);
}
.custom-label label {
  color: #4a2c40!important;
  text-align: left!important;
}
.registration {
  color: #4a2c40;
  font-weight: lighter;
}
.link {
  color: #4a2c40;
  font-weight: lighter;
}
.link:hover {
  cursor: pointer;
}
.alert {
  margin-bottom: 1rem;
  padding: 0.75rem;
  border-radius: 4px;
}
.alert-danger {
  background-color: #f8d7da;
  border-color: #f5c6cb;
  color: #721c24;
}
</style>
