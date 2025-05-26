<script>
import { BButton, BForm, BFormGroup, BFormInput } from "bootstrap-vue-next";
import { useRouter } from 'vue-router';
import { register } from './services/api';

export default {
  components: { BButton, BFormInput, BFormGroup, BForm },
  setup() {
    const router = useRouter();
    return { router };
  },
  data() {
    return {
      form: {
        username: '',
        email: '',
        phone_number: '',
        password: '',
        password_confirmation: ''
      },
      error: null
    };
  },
  methods: {
    async handleRegister() {
      this.error = null;
      if (this.form.password !== this.form.password_confirmation) {
        this.error = 'Пароль и подтверждение не совпадают';
        return;
      }
      try {
        const response = await register(this.form);
        localStorage.setItem('user', JSON.stringify(response.user));
        this.router.push('/projects');
      } catch (error) {
        this.error = error.message;
      }
    }
  }
};
</script>

<template>
  <BForm @submit.prevent="handleRegister">
    <div v-if="error" class="alert alert-danger">{{ error }}</div>

    <BFormGroup
        id="input-group-username"
        label="Введите имя пользователя:"
        label-for="input-username"
        class="mb-3 custom-label"
    >
      <BFormInput
          id="input-username"
          v-model="form.username"
          type="text"
          placeholder="Имя пользователя"
          required
      />
    </BFormGroup>

    <BFormGroup
        id="input-group-email"
        label="Введите почту:"
        label-for="input-email"
        class="mb-3 custom-label"
    >
      <BFormInput
          id="input-email"
          v-model="form.email"
          type="email"
          placeholder="Email"
          required
      />
    </BFormGroup>

    <BFormGroup
        id="input-group-phone"
        label="Введите номер телефона:"
        label-for="input-phone"
        class="mb-3 custom-label"
    >
      <BFormInput
          id="input-phone"
          v-model="form.phone_number"
          type="tel"
          placeholder="Номер телефона"
          required
      />
    </BFormGroup>

    <BFormGroup
        id="input-group-password"
        label="Введите пароль:"
        label-for="input-password"
        class="mb-3 custom-label"
    >
      <BFormInput
          id="input-password"
          v-model="form.password"
          type="password"
          placeholder="Пароль"
          required
      />
    </BFormGroup>

    <BFormGroup
        id="input-group-password-confirmation"
        label="Подтвердите пароль:"
        label-for="input-password-confirmation"
        class="mb-3 custom-label"
    >
      <BFormInput
          id="input-password-confirmation"
          v-model="form.password_confirmation"
          type="password"
          placeholder="Подтвердите пароль"
          required
      />
    </BFormGroup>

    <BButton class="login-btn" type="submit" variant="primary">Зарегистрироваться</BButton>
  </BForm>
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
  color: #4a2c40 !important;
  text-align: left !important;
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
