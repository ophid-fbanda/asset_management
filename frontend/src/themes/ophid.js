import Aura from '@primeuix/themes/aura'
import { definePreset } from '@primeuix/themes'

const brand = {
  50: '#f3f5fb',
  100: '#e8eefa',
  200: '#cfd8ef',
  300: '#a8b6db',
  400: '#7a8fc4',
  500: '#5268a8',
  600: '#384884',
  700: '#2d3a6b',
  800: '#242f56',
  900: '#1b2442',
  950: '#11182c',
}

export const OphidPreset = definePreset(Aura, {
  semantic: {
    primary: brand,
    colorScheme: {
      light: {
        surface: {
          0: '#ffffff',
          50: '#f8fafd',
          100: '#eef2f8',
          200: '#e2e8f2',
          300: '#c9d2e3',
          400: '#94a0b8',
          500: '#64748b',
          600: '#475569',
          700: '#334155',
          800: '#1e293b',
          900: '#0f172a',
          950: '#020617',
        },
        highlight: {
          background: '{primary.100}',
          color: '{primary.700}',
          focusBackground: '{primary.200}',
          focusColor: '{primary.800}',
        },
      },
    },
  },
  components: {
    datatable: {
      headerCell: {
        padding: '0.85rem 1.05rem',
        gap: '0.4rem',
      },
      columnTitle: {
        fontWeight: '650',
      },
      bodyCell: {
        padding: '0.78rem 1.05rem',
      },
      footer: {
        background: '{primary.50}',
        borderColor: '{primary.200}',
        color: '{primary.700}',
        borderWidth: '1px 0 0 0',
        padding: '0.75rem 1.05rem',
      },
      footerCell: {
        background: '{primary.50}',
        borderColor: '{primary.200}',
        color: '{primary.700}',
        padding: '0.75rem 1.05rem',
      },
      sortIcon: {
        size: '0.75rem',
      },
      paginatorTop: {
        borderColor: '{primary.200}',
        borderWidth: '0 0 1px 0',
      },
      paginatorBottom: {
        borderColor: '{primary.200}',
        borderWidth: '1px 0 0 0',
      },
      colorScheme: {
        light: {
          root: {
            borderColor: '{primary.200}',
          },
          headerCell: {
            background: 'linear-gradient(180deg, #eef2fb 0%, #e4eaf8 100%)',
            hoverBackground: '{primary.200}',
            selectedBackground: '{primary.200}',
            color: '{primary.700}',
            hoverColor: '{primary.800}',
            selectedColor: '{primary.800}',
            borderColor: '{primary.200}',
          },
          row: {
            background: '{surface.0}',
            hoverBackground: '#f3f6fc',
            selectedBackground: '{primary.100}',
            color: '{surface.800}',
            hoverColor: '{surface.900}',
            selectedColor: '{primary.800}',
            stripedBackground: '#f7f9fd',
          },
          bodyCell: {
            borderColor: '#e8edf6',
            selectedBorderColor: '{primary.200}',
          },
          sortIcon: {
            color: '{primary.400}',
            hoverColor: '{primary.600}',
          },
        },
      },
    },
    paginator: {
      root: {
        padding: '0.7rem 1rem',
        gap: '0.35rem',
        borderRadius: '0',
      },
      navButton: {
        borderRadius: '0.25rem',
        width: '2.15rem',
        height: '2.15rem',
      },
      colorScheme: {
        light: {
          root: {
            background: 'linear-gradient(180deg, #f7f9fd 0%, #eef2fb 100%)',
            color: '{primary.700}',
          },
          navButton: {
            hoverBackground: '{primary.100}',
            selectedBackground: '{primary.600}',
            selectedColor: '#ffffff',
            color: '{primary.500}',
            hoverColor: '{primary.700}',
          },
        },
      },
    },
    tag: {
      root: {
        fontSize: '0.72rem',
        fontWeight: '650',
        padding: '0.22rem 0.65rem',
        borderRadius: '0.2rem',
      },
    },
  },
})
