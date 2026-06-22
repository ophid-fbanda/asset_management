import './assets/main.css'

import PrimeVue from 'primevue/config'
import { createApp } from 'vue'
import { createPinia } from 'pinia'

import App from './App.vue'
import router from './router'
import { OphidPreset } from './themes/ophid'

const app = createApp(App)

app.use(createPinia())
app.use(router)
app.use(PrimeVue, {
  theme: {
    preset: OphidPreset,
    options: {
      darkModeSelector: '.p-dark',
    },
  },
})

app.mount('#app')
