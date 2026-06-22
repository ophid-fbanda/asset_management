//================================================//
//             RESET ALL KEYS TO NULL             //
//================================================//
// Blanks every key on a reactive object, keeping any listed in `except`.
export const objectReset = (obj, except = []) => {
  for (const key of Object.keys(obj)) {
    if (!except.includes(key)) {
      obj[key] = null
    }
  }
}


//================================================//
//          RESET THEN SET A SINGLE KEY           //
//================================================//
// Clears the object, then sets one key — enforces mutually exclusive state
// (e.g. ui.busy / ui.error / ui.success never coexist).
export const objectResetSet = (obj, k, v) => {
  objectReset(obj)
  obj[k] = v
}


//================================================//
//               SET A SINGLE KEY                 //
//================================================//
export const objectSet = (obj, k, v) => {
  obj[k] = v
}


//================================================//
//      FIND THE FIRST EMPTY KEY (WORKER)         //
//================================================//
// Shared worker for the two completeness checks below: returns the first key
// whose value is falsy (skipping `except`), or null when none are. objectComplete
// wants the yes/no verdict; emptyObjectKey wants the offending key. Same scan,
// two public contracts — keep them separate so callers ask for exactly what they need.
const firstEmptyKey = (obj, except = []) => {
  for (const key of Object.keys(obj)) {
    if (!except.includes(key) && !obj[key]) {
      return key
    }
  }
  return null
}


//================================================//
//        IS EVERY REQUIRED KEY FILLED?           //
//================================================//
// Yes/no gate — true when no key is empty (skipping `except`).
export const objectComplete = (obj, except = []) => firstEmptyKey(obj, except) === null


//================================================//
//         WHICH KEY IS STILL EMPTY?              //
//================================================//
// Returns the first empty key (skipping `except`), or null when complete.
export const emptyObjectKey = (obj, except = []) => firstEmptyKey(obj, except)


//================================================//
//     DERIVE TABLE COLUMNS FROM ROW SHAPE        //
//================================================//
// Builds { field, header } columns from the first row, hiding id/*_id and any
// `except` keys. header is the field upper-cased with underscores as spaces.
export const objectHeaders = (arr = [], except = []) => {
  if (!Array.isArray(arr)) return []
  if (!arr.length) return []

  return Object.keys(arr[0])
    .filter((k) => !except.includes(k) && k !== 'id' && !k.endsWith('_id'))
    .map((k) => ({
      field: k,
      header: k.replace(/_/g, ' ').toUpperCase(),
    }))
}


//================================================//
//      FULL-TEXT FILTER ACROSS ROW VALUES        //
//================================================//
// Case-insensitive search over every value in each row (skipping `exception`
// keys and blanks). Empty keyword returns the array unchanged.
export const arraySearch = (array = [], keyword = '', exception = []) => {
  if (!Array.isArray(array)) return []

  const query = String(keyword ?? '').trim().toLowerCase()
  if (!query) return array

  return array.filter((row) => {
    if (!row || typeof row !== 'object') return false

    return Object.entries(row).some(([key, value]) => {
      if (exception.includes(key)) return false
      if (value === null || value === undefined || value === '') return false

      let text
      if (typeof value === 'number' || typeof value === 'bigint') {
        text = String(value)
      } else if (typeof value === 'boolean') {
        text = value ? 'true' : 'false'
      } else {
        text = String(value)
      }

      return text.toLowerCase().includes(query)
    })
  })
}


//================================================//
//      FIND ONE ROW BY KEY=VALUE (PRUNED)        //
//================================================//
// Returns the first row where row[key] === value, with `except` keys stripped,
// or null when nothing matches.
export const objectLookup = (array = [], key, value, except = []) => {
  if (!Array.isArray(array)) return null
  if (typeof key !== 'string' || !key) return null
  if(value == null || value === '') return null

  const obj = array.find(item => item?.[key] === value)

  if (!obj) return null

  const excluded = new Set(except)

  return Object.fromEntries(
    Object.entries(obj).filter(([k]) => !excluded.has(k))
  )
}


//================================================//
//     FILTER ROWS WHOSE KEY IS IN A LIST         //
//================================================//
// Keeps rows where row[key] is one of `values`, with `except` keys stripped.
// Powers cascading selects (e.g. brands narrowed to the chosen asset type).
export const arrayFilter = (array = [], key, values = [], except = []) => {
  if (!Array.isArray(array)) return []
  if (typeof key !== 'string' || !key) return []
  if (!Array.isArray(values) || !values.length) return []

  const allowed = new Set(values)
  const excluded = new Set(except)

  return array
    .filter((item) => item && allowed.has(item[key]))
    .map((item) =>
      Object.fromEntries(
        Object.entries(item).filter(([k]) => !excluded.has(k)),
      ),
    )
}


//================================================//
//        FIRST ROW'S id (DEFAULT SELECT)         //
//================================================//
// Convenience for defaulting a select to the first option's id.
export const objectFirstId = (arr = []) => {
  if (!Array.isArray(arr) || !arr.length) return null
  return arr[0].id
}


//================================================//
//     LOOK UP ONE CELL BY ANOTHER COLUMN         //
//================================================//
// Finds the row where row[column] === value and returns its returnColumn,
// or null. Used to resolve ids to display names.
export const columnLookup = (array = [], column, value, returnColumn) => {
  if (!Array.isArray(array)) return null

  const row = array.find((item) => item?.[column] === value)
  return row?.[returnColumn] ?? null
}
