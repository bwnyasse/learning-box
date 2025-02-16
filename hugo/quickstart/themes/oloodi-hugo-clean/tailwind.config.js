/** @type {import('tailwindcss').Config} */
module.exports = {
  content: ["./layouts/**/*.html"],
  darkMode: 'class',
  theme: {
    extend: {
      colors: {
        primary: '#00c38e',
        secondary: '#9fff24',
        dark: '#2d3436',
        'text-secondary': '#636e72',
      },
      fontFamily: {
        poppins: ['Poppins', 'sans-serif'],
        raleway: ['Raleway', 'sans-serif'],
      },
      typography: (theme) => ({
        DEFAULT: {
          css: {
            color: theme('colors.gray.900'),
            a: {
              color: theme('colors.primary'),
              '&:hover': {
                color: theme('colors.primary/80'),
              },
            },
            // Add these code-related styles
            'code::before': {
              content: '""',
            },
            'code::after': {
              content: '""',
            },
            'code': {
              color: theme('colors.pink.600'),
              backgroundColor: theme('colors.gray.100'),
              fontWeight: '400',
              borderRadius: '0.25rem',
              padding: '0.2em 0.4em',
              fontSize: '0.875em',
            },
            'pre': {
              backgroundColor: theme('colors.gray.900'),
              color: theme('colors.gray.100'),
              padding: theme('spacing.4'),
              borderRadius: theme('borderRadius.lg'),
              overflow: 'auto',
            },
            'pre code': {
              backgroundColor: 'transparent',
              color: 'inherit',
              fontSize: '0.875em',
              padding: '0',
              fontWeight: '400',
            },
          },
        },
        dark: {
          css: {
            color: theme('colors.gray.100'),
            a: { color: theme('colors.primary') },
            h1: { color: theme('colors.gray.100') },
            h2: { color: theme('colors.gray.100') },
            h3: { color: theme('colors.gray.100') },
            h4: { color: theme('colors.gray.100') },
            p: { color: theme('colors.gray.300') },
            strong: { color: theme('colors.gray.100') },
            blockquote: { color: theme('colors.gray.300') },
            // Add dark mode code styles
            'code': {
              color: theme('colors.pink.400'),
              backgroundColor: theme('colors.gray.800'),
            },
            'pre': {
              backgroundColor: theme('colors.gray.900'),
              color: theme('colors.gray.100'),
            },
            'pre code': {
              backgroundColor: 'transparent',
              color: 'inherit',
            },
          },
        },
      }),
    },
  },
  plugins: [require('@tailwindcss/typography')],
}