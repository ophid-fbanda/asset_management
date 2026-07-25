//================================================//
//                 COLOR PALETTE                  //
//================================================//
// PrimeVue Tag severities (legacy / non-table uses).
const palette = {
  0: 'secondary',
  10: 'info',
  11: 'danger',
  40: 'warn',
  41: 'danger',
  50: 'success',
  51: 'danger',
}

// Soft status dots for list tables (approval / workflow states).
const tones = {
  0: '#94a3b8', // Pending
  10: '#384884', // Info / in progress
  11: '#ef4444', // Rejected (early)
  40: '#f59e0b', // Supervisor approved
  41: '#ef4444', // Supervisor rejected
  50: '#22c55e', // Manager approved
  51: '#ef4444', // Manager rejected
}


//================================================//
//          RESOLVE A KEY TO ITS COLOR            //
//================================================//
// Returns the palette entry for key, or the fallback when it isn't mapped.
export const colorPalette = (key, fallback = 'secondary') => palette[key] ?? fallback


//================================================//
//         RESOLVE A KEY TO A DOT TONE            //
//================================================//
export const colorTone = (key, fallback = '#94a3b8') => tones[key] ?? fallback
