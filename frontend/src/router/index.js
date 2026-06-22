import { createRouter, createWebHistory } from 'vue-router'

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes: [
    {
      path: '/',
      name: 'home',
      component: () => import('@/views/home/HomeView.vue'),
    },
    {
      path: '/my-assets',
      name: 'my-assets',
      component: () => import('../my-assets/HomePage.vue'),
    },
    {
      path: '/reports',
      name: 'reports',
      component: () => import('../reports/HomePage.vue'),
    },
    {
      path: '/assets-admin',
      name: 'assets-admin',
      component: () => import('@/views/asset-admin/HomePage.vue'),
    },
    {
      path: '/supervisory',
      name: 'supervisory',
      component: () => import('@/views/supervisory/HomePage.vue'),
    },
    {
      path: '/management',
      name: 'management',
      component: () => import('@/views/management/HomePage.vue'),
    },
    {
      path: '/audits',
      name: 'audits',
      component: () => import('../audits/HomePage.vue'),
    },
    {
      path: '/users',
      name: 'users',
      component: () => import('../users-admin/HomePage.vue'),
    },
    {
      path: '/system',
      name: 'system',
      component: () => import('../system-admin/HomePage.vue'),
    },
  ],
})

export default router
