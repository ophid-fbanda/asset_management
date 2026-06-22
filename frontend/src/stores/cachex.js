import { defineStore } from 'pinia'
import { reactive } from 'vue'
import { pull } from '@/api/httpx'

export const cachex = defineStore('cachex', () => {
  const store = reactive({})
  const keyError = reactive({})
  const keyBusy = reactive({})

  async function loadKey(key) {
    if (keyBusy[key]) return

    keyBusy[key] = true
    keyError[key] = null

    try {
      const response = await pull(key)

      if (response.status === 200) {
        delete store[key]
        store[key] = response.data
      } else {
        if (response.status === 401 || response.status === 403) {
          clearKey('user')
        }
        keyError[key] = response.data
      }
    } catch (err) {
      keyError[key] = err
    } finally {
      keyBusy[key] = false
    }
  }

  const readKey = async (key) => {
    if (!(key in store) && !keyBusy[key]) {
      await loadKey(key)
    }

    return store[key]
  }

  const writeKey = (key, value) => {
    store[key] = value
    keyBusy[key] = false
    keyError[key] = null
  }

  const clearKey = (key) => {
    delete store[key]
    delete keyBusy[key]
    delete keyError[key]
  }

  const clearKeys = () => {
    Object.keys(store).forEach(clearKey)
  }

  return {
    store,
    keyBusy,
    keyError,
    readKey,
    writeKey,
    loadKey,
    clearKey,
    clearKeys,
  }
})
