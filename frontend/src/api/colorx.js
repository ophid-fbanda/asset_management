//================================================//
//                 COLOR PALETTE                  //
//================================================//
const palette = {
  0: 'secondary',
  10: 'info',
  11: 'danger',
  40: 'warn',
  41: 'danger',
  50: 'success',
  51: 'danger',
}


//================================================//
//          RESOLVE A KEY TO ITS COLOR            //
//================================================//
// Returns the palette entry for key, or the fallback when it isn't mapped.
export const colorPalette = (key, fallback = 'secondary') => palette[key] ?? fallback
