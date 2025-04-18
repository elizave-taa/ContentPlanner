<script>
import { BButton, BForm, BFormGroup, BFormInput } from "bootstrap-vue-next";

export default {
  components: { BButton, BFormInput, BFormGroup, BForm },
  data() {
    return {
      form: {
        phone: '',
        username: '',
        password: '',
        email: '',
      },
    };
  },
};
</script>

<template>
  <BForm>
    <BFormGroup
        id="input-group-phone"
        label="Введите номер телефона:"
        label-for="input-phone"
        class="mb-3 custom-label"
    >
      <BFormInput
          id="input-phone"
          v-model="form.phone"
          type="tel"
          placeholder="Номер телефона"
          required
          :invalid-feedback="invalidFeedback"
          :state="state"
      />
    </BFormGroup>

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
          :invalid-feedback="invalidFeedback"
          :state="state"
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
          :invalid-feedback="invalidFeedback"
          :state="state"
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
          :invalid-feedback="invalidFeedback"
          :state="state"
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
</style>
