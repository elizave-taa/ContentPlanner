import { createApp } from 'vue'
import App from './App.vue'
import { createBootstrap } from 'bootstrap-vue-next'
import router from './router' // Импортируем роутер

// Стили Bootstrap
import 'bootstrap/dist/css/bootstrap.css'
import 'bootstrap-vue-next/dist/bootstrap-vue-next.css'

const app = createApp(App)

// Подключаем роутер
app.use(router)

// Подключаем BootstrapVueNext
app.use(createBootstrap())

app.mount('#app')
