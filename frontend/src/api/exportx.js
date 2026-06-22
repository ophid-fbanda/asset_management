import * as XLSX from 'xlsx'
import html2pdf from 'html2pdf.js/dist/html2pdf.bundle.min.js'
/**
 * @param {object[]} data - rows as plain objects (keys become column headers)
 * @param {string} filename - output base name (without extension)
 * @param {string} [sheetName='Report'] - first sheet tab name
 */
export function exportToExcel(data, filename='export', sheetName = 'Report') {
  if (!Array.isArray(data) || !data.length) return 'No data to export'
  try {
    const worksheet = XLSX.utils.json_to_sheet(data)
    const workbook = XLSX.utils.book_new()
    XLSX.utils.book_append_sheet(workbook, worksheet, sheetName)
    XLSX.writeFile(workbook, filename + '.xlsx')
    return null
  } catch (e) {
    console.error('Excel export failed:', e)
    return 'Excel export failed'
  }
}


export async function exportToPDF(element, filename='export', layout = 'landscape', fmt = 'a4') {
  if (!element) return 'No element to export'
  try {
    const opt = {
      margin: 0,
      filename: `${filename}.pdf`,
      image: { type: 'jpeg', quality: 0.98 },
      html2canvas: { scale: 2, useCORS: true },
      jsPDF: { unit: 'mm', format: fmt, orientation: layout },
    }
    await html2pdf().set(opt).from(element).save()
    return null
  } catch (e) {
    console.error('PDF export failed:', e)
    return 'PDF export failed'
  }
}
