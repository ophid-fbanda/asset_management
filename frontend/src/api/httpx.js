import axios from 'axios'

const API_BASE = import.meta.env.VITE_API_BASE_URL || '/ams_be/api/'

const http = axios.create({
  // Relative path → current host:port from the browser. Never hardcode localhost.
  // Dev: .env.development → /api/ (Vite proxy). Prod: .env.production → /ams_be/api/ (IIS).
  baseURL: API_BASE,
  withCredentials: true,
  timeout: 120000,
})

/** Absolute-from-root URL under the API base (e.g. file links in <img src>). */
export function httpApiUrl(path = '') {
  const base = API_BASE.endsWith('/') ? API_BASE : `${API_BASE}/`
  const rel = String(path).replace(/^\/+/, '')
  return `${base}${rel}`
}

function jsonHeaders() {
  return {
    'Content-Type': 'application/json',
    Accept: 'application/json',
  }
}

export async function httpGet(url, params = {}) {
  try {
    const response = await http.get(url, {
      params,
      headers: jsonHeaders(),
    })
    return {
      data: response.data,
      status: response.status,
    }
  } catch (error) {
    return {
      data: error?.response?.data ?? 'The server did not respond correctly',
      status: error?.response?.status ?? 0,
    }
  }
}

export async function httpPost(url, data = {}) {
  try {
    const response = await http.post(url, data, {
      headers: jsonHeaders(),
    })
    return {
      data: response.data,
      status: response.status,
    }
  } catch (error) {
    return {
      data: error?.response?.data ?? 'This might be a network problem',
      status: error?.response?.status ?? 0,
    }
  }
}

export async function httpMultiPost(url, data = {}) {
  const formData = new FormData()
  Object.keys(data).forEach((key) => {
    formData.append(key, data[key])
  })
  try {
    const response = await http.post(url, formData)
    return {
      data: response.data,
      status: response.status,
    }
  } catch (error) {
    return {
      data: error?.response?.data ?? 'This might be a network problem',
      status: error?.response?.status ?? 0,
    }
  }
}
