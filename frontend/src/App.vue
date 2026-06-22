<script setup>
import { dataFromProfile } from '@/api/datax'
import HomeView from '@/views/home/HomeView.vue'
import LoginHome from '@/views/auth/LoginHome.vue'

const profile = dataFromProfile()
</script>

<template>
  <HomeView v-if="profile">
    <RouterView />
  </HomeView>
  <LoginHome v-else />
</template>
