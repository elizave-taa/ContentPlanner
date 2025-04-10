import { createApp } from 'vue'
import App from './App.vue'
import { createBootstrap } from 'bootstrap-vue-next' // Измените эту строку

// Импортируем CSS Bootstrap
import 'bootstrap/dist/css/bootstrap.css'
import 'bootstrap-vue-next/dist/bootstrap-vue-next.css'

const app = createApp(App)

// Используем createBootstrap вместо BootstrapVueNext
app.use(createBootstrap()) // Вот так

app.mount('#app')