import { createRouter, createWebHistory } from 'vue-router'
import WelcomePage from '../AuthPage.vue'
import RegistrationPage from '../RegistrationPage.vue'
import ProjectsPage from '../ProjectsPage.vue'
import SchedulePage from '../SchedulePage.vue'

const routes = [
    {
        path: '/projects',
        name: 'projects',
        component: ProjectsPage
    },
    {
        path: '/',
        name: 'auth',
        component: WelcomePage,
    },
    {
        path: '/registration',
        name: 'registration',
        component: RegistrationPage,
    },
    {
        path: '/schedule',
        name: 'schedule',
        component: SchedulePage,
    }
]

const router = createRouter({
    history: createWebHistory(),
    routes
})

export default router