// Single source of truth for identity, URLs, social links and SEO defaults.
// astro.config.mjs imports `site.url` from here too.

export const site = {
  name: 'Sudheer Kancharla',
  title: 'Senior Backend Engineer · Tech Lead',
  // One-line positioning statement shown in the hero.
  tagline:
    'I design, build and run reliable distributed backend systems, and lead the teams that build them.',
  location: 'Seville, Spain',

  url: 'https://sudheerkancharla.dev',
  locale: 'en',

  email: 'sudheer.k.kancharla@gmail.com',

  links: {
    linkedin: 'https://www.linkedin.com/in/sudheerkumark/',
    github: 'https://github.com/sudheerkkumar',
    cv: '/cv.pdf',
  },

  seo: {
    // Default meta description; pages can override it.
    description:
      'Sudheer Kancharla, Senior Backend Engineer and Tech Lead in Seville, Spain. 10+ years building distributed systems in Kotlin and Java on AWS.',
    // Default social preview image (1200x630), relative to the site root.
    ogImage: '/og-image.png',
    ogImageAlt: 'Sudheer Kancharla, Senior Backend Engineer and Tech Lead',
  },
} as const;
