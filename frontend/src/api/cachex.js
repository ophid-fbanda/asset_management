import { defineStore } from 'pinia'
import { reactive } from 'vue'

export const cachex = defineStore('cachex', () => {
  const cacheStore = reactive({})
  const cacheError = reactive({})
  const cacheBusy = reactive({})

  const writeCache = (key, value) => {
    cacheStore[key] = value
    cacheBusy[key] = false
    cacheError[key] = null
  }

  const clearCache = (key = null) => {
    if (key) {
      delete cacheStore[key]
      delete cacheBusy[key]
      delete cacheError[key]
    } else {
      Object.keys(cacheStore).forEach(clearCache)
    }
  }

  return {
    cacheStore,
    cacheBusy,
    cacheError,
    writeCache,
    clearCache,
  }
})
