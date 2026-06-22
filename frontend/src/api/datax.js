import { computed } from 'vue'
import { cachex } from '@/api/cachex'
import { httpGet, httpPost, httpMultiPost } from '@/api/httpx'

//================================================//
//                    PROFILE KEY                 //
//================================================//
export const PROFILE_KEY = 'whos-on-shift'
export const SEARCH_KEY = 'what-to-search'

//================================================//
//             OBSERVE STATUS CODE               //
//================================================//
function observe(status) {
  if ([401, 403].includes(status)) {
    cachex().clearCache(PROFILE_KEY)
  }
}

//================================================//
//             DATA FETCHING FROM SERVER          //
//================================================//
export async function dataFetch(url, params = {}) {
  const response = await httpGet(url, params)
  observe(response.status)
  return response
}


//================================================//
//  FETCH FROM SERVER AND SAVE TO CACHE (WORKER)  //
//================================================//
async function fetchToCache(key) {
  const cache = cachex()
  if (cache.cacheBusy[key]) return

  cache.cacheBusy[key] = true
  cache.cacheError[key] = null

  try {
    const response = await dataFetch(key)

    if (response.status === 200) {
      cache.writeCache(key, response.data)
    } else {
      cache.cacheError[key] = response.data
    }
  } catch (err) {
    cache.cacheError[key] = err
  } finally {
    cache.cacheBusy[key] = false
  }
}


//================================================//
//  FETCH AND STORE ONLY IF NOT ALREADY CACHED    //
//================================================//
export async function dataFetchToCache(key) {
  if (cachex().cacheStore[key]) return
  await fetchToCache(key)
}


//================================================//
//  FORCE RE-FETCH AND OVERWRITE THE CACHE        //
//================================================//
export async function dataRefreshCache(key) {
  await fetchToCache(key)
}


//================================================//
//  PATCH ONE (OR A FEW) ROWS INTO A CACHED LIST  //
//================================================//
// Fetches the authoritative row(s) from patchKey and upserts them into the
// list cached at dataKey, matching on idKey. A single object or an array are
// both accepted. Reactive, so the change shows up in place without reloading
// the whole bundle. Replace-only: this never removes rows (a row leaving a
// filtered list is a removal, handle that separately).
export async function dataPatchCache(patchKey, dataKey, idKey = 'entity_id') {
  const response = await dataFetch(patchKey)
  if (response.status !== 200) return

  const current = cachex().cacheStore[dataKey]
  if (!Array.isArray(current)) return

  const patches = Array.isArray(response.data) ? response.data : [response.data]
  const next = [...current]

  for (const patch of patches) {
    if (!patch) continue
    const index = next.findIndex((row) => row[idKey] === patch[idKey])
    if (index === -1) next.unshift(patch)
    else next[index] = patch
  }

  cachex().writeCache(dataKey, next)
}


//================================================//
//             SEND A SIMPLE POST REQUEST       //
//================================================//
export async function dataSend(url, data = {}) {
  const response = await httpPost(url, data)
  observe(response.status)
  return response
}


//================================================//
//             SEND A MULTIPART POST REQUEST     //
//================================================//
export async function dataUpload(url, data = {}) {
  const response = await httpMultiPost(url, data)
  observe(response.status)
  return response
}


//================================================//
//             READ DATA FROM CACHE             //
//================================================//
export function dataFromCache(key) {
  return computed(() => cachex().cacheStore[key])
}


//================================================//
//             WRITE DATA TO CACHE               //
//================================================//
export function dataToCache(key, value) {
  cachex().writeCache(key, value)
}



//================================================//
//             CLEAR DATA FROM CACHE             //
//================================================//
export function dataClearCache(key=null) {
  cachex().clearCache(key)
}


//================================================//
//           AUTO SIGN IN USING SESSION DATA      //
//================================================//
export async function dataAutoSignIn(url){
  const profile = await dataFetch(url)
  if (profile.status === 200) {
    dataToCache(PROFILE_KEY, profile.data)
  }
}


//================================================//
// PROFILE BUNDLE AS READ PROFILE CACHE USING PROFILE KEY      //
//================================================//

export function dataToProfile(data){
  dataToCache(PROFILE_KEY, data)
}

export function dataFromProfile(){
  return dataFromCache(PROFILE_KEY)
}

export function dataClearProfile(){
  dataClearCache(PROFILE_KEY)
}

export async function dataSignOut(url) {
  await dataSend(url)
  dataClearCache(PROFILE_KEY)
}


//================================================//
//   GENERATE A PROFILE-SCOPED UNIQUE IDENTIFIER  //
//================================================//
// prefix-profileId-yyMMddHHmmssSSS (the ms tail guards same-second collisions).
export function dataUnique(prefix) {
  const now = new Date()
  const pad = (value, size = 2) => String(value).padStart(size, '0')

  const stamp =
    String(now.getFullYear()).slice(-2) +
    pad(now.getMonth() + 1) +
    pad(now.getDate()) +
    pad(now.getHours()) +
    pad(now.getMinutes()) +
    pad(now.getSeconds()) +
    pad(now.getMilliseconds(), 3)

  const profileId = dataFromProfile().value?.profileId ?? 'X'
  return `${prefix}-${profileId}-${stamp}`
}




//================================================//
//      TWO-WAY CACHE BINDING (v-model READY)     //
//================================================//
// Writable computed bound to a cache key: get returns the cached value (or
// fallback), set writes it. Drop straight into v-model so inputs share state.
export function dataReadableWritable(key, fallback = '') {
  return computed({
    get: () => cachex().cacheStore[key] ?? fallback,
    set: (value) => cachex().writeCache(key, value),
  })
}


//================================================//
//             SEARCH QUERY BUNDLE               //
//================================================//
export function dataSearchModel() {
  return dataReadableWritable(SEARCH_KEY)
}

export function dataClearSearch() {
  dataClearCache(SEARCH_KEY)
}


