<script setup>
import { dataFromProfile } from '@/api/datax'
import HomeView from '@/views/home/HomeView.vue'
import LoginHome from '@/views/auth/LoginHome.vue'
import { Toast } from 'primevue'

const profile = dataFromProfile()
</script>

<template>
  <Toast position="bottom-right" />
  <HomeView v-if="profile">
    <RouterView />
  </HomeView>
  <LoginHome v-else />
</template>
