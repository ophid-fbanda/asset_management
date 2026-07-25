import { fileURLToPath, URL } from 'node:url'

import tailwindcss from '@tailwindcss/vite'
import vue from '@vitejs/plugin-vue'
import { PrimeVueResolver } from '@primevue/auto-import-resolver'
import { defineConfig } from 'vite'
import vueDevTools from 'vite-plugin-vue-devtools'
import Components from 'unplugin-vue-components/vite'

// https://vite.dev/config/
export default defineConfig({
  base: '/ams/',
  plugins: [
    vue(),
    vueDevTools(),
    tailwindcss(),
    Components({
      resolvers: [PrimeVueResolver()],
    }),
  ],
  resolve: {
    alias: {
      '@': fileURLToPath(new URL('./src', import.meta.url)),
    },
  },
  server: {
    proxy: {
      // Dev only. Production uses IIS: /ams_be/api → Spring /api
      '/api': {
        target: 'http://localhost:8080',
        changeOrigin: true,
      },
    },
  },
})
