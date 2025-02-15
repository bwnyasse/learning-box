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
            },
          },
        }),
      },
    },
    plugins: [require('@tailwindcss/typography')],
  }