import axios from 'axios'

const http = axios.create({
  //baseURL: import.meta.env.VITE_API_BASE_URL
  baseURL: 'http://localhost:8080/api/',
  withCredentials: true,
  timeout: 120000,
})

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
