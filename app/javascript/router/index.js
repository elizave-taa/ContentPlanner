import { createRouter, createWebHistory } from 'vue-router'
import WelcomePage from '../AuthPage.vue'
import RegistrationPage from '../RegistrationPage.vue'
import ProjectsPage from '../ProjectsPage.vue'
import SchedulePage from '../SchedulePage.vue'
import ProjectPage from '../ProjectPage.vue'

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
    },
    {
        path: '/project/:id',
        name: 'project',
        component: ProjectPage,
        props: true
    },
    {
        path: '/:pathMatch(.*)*',
        name: 'NotFound',
        redirect: '/projects'
    }
]

const router = createRouter({
    history: createWebHistory(),
    routes
})

// Navigation guard for authentication
router.beforeEach((to, from, next) => {
    const publicPages = ['auth', 'registration'];
    const isPublic = publicPages.includes(to.name);
    const user = localStorage.getItem('user');
    if (!isPublic && !user) {
        next({ name: 'auth' });
    } else {
        next();
    }
});

export default router
