

module.exports = {
  content: [
    "./src/**/*.{js,jsx,ts,tsx}",
  ],
  theme: {
    extend: {
      filter: { // Enable filter utilities
        'monk-gold': 'invert(72%) sepia(65%) saturate(400%) hue-rotate(3deg) brightness(90%) contrast(90%)',
        'monk-gold-hover': 'invert(60%) sepia(70%) saturate(500%) hue-rotate(3deg) brightness(100%) contrast(100%)'
      },
      colors: {
        // Primary colors
        'monk-blue': '#0F172A',      // Dark navy
        'monk-gold': '#D4AF37',      // Metallic gold
        
        // Secondary colors
        'monk-light-blue': '#1E293B', // Medium navy
        'monk-cream': '#F5F5F5',      // Off-white
        
        // Accent colors
        'monk-teal': '#2DD4BF',       // Bright teal from heymonk.app
        'monk-orange': '#F59E0B',     // Warm orange
        
        // Utility colors
        'monk-gray': '#64748B',       // Medium gray
        'monk-dark-gray': '#334155',   // Dark gray
        'monk-red': '#DC2626',        // Proper red color
      },
      fontFamily: {
        sans: ['Inter', 'system-ui', '-apple-system', 'sans-serif'],
      },
      boxShadow: {
        'monk': '0 4px 6px -1px rgba(15, 23, 42, 0.1)',
        'monk-hover': '0 10px 15px -3px rgba(212, 175, 55, 0.1)',
      },
      gradientColorStops: {
        'monk-dark': '#0F172A',
        'monk-mid': '#1E293B',
        'monk-light': '#2D3748'
      }
    },
  },
  plugins: [require('daisyui'),],
} ; 