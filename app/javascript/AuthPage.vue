<script xmlns="http://www.w3.org/1999/html">
import {BContainer} from "bootstrap-vue-next";
import LoginForm from './LoginForm.vue';
export default {
  name: "AuthPage",
  components: {LoginForm, BContainer},
};
</script>

<template>
  <div class="app">
    <BContainer class="blur-card">
      <div class="form">
        <div class ="container">
          <label class="welcome-description"><h4>Добро пожаловать в <b>ContentPlanner</b></h4> - приложение,
            которое структурирует ваше контент сопровождение.
          </label>
          <LoginForm></LoginForm></div>
      </div>
      <img class="illustration" src="/images/illustration.png">
    </BContainer>
  </div>
</template>

<style scoped>
.app {
  background-color: #e3c3d4;
  background-size: cover;
  background-position: center;
  width: 100%;
  height: 100vh;
  display: flex;
  justify-content: center;
  align-items: center;
  padding: 20px;
}
.container {
  width: 75%;
}
.blur-card {
  background: rgba(255, 255, 255, 0.3);
  backdrop-filter: blur(25px);
  border-radius: 24px;
  width: 90%;
  max-width: 800px;
  box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);
  display: flex;
  justify-content: space-between;
  padding-right: 0;
}
.illustration {
  width: 40%;
}
.welcome-description {
  margin-bottom: 20px;
  color: #4a2c40;
}
.form {
  width: 60%;
  align-self: center;
}
</style>