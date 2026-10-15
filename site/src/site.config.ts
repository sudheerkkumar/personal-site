// Single source of truth for identity, URLs, social links and SEO defaults.
// astro.config.mjs imports `site.url` from here too.

export const site = {
  name: 'Sudheer Kancharla',
  title: 'Senior Software Engineer · Backend & Distributed Systems',
  // One-line positioning statement shown in the hero.
  tagline:
    'I design and build reliable, scalable backend systems, and I help teams make sound architecture decisions.',
  location: 'Seville, Spain',

  url: 'https://sudheerkancharla.dev',
  locale: 'en',

  // TODO: replace with your real public email address.
  email: 'you@example.com',

  links: {
    // TODO: replace with your LinkedIn profile URL.
    linkedin: 'https://www.linkedin.com/in/TODO/',
    github: 'https://github.com/sudheerkkumar',
    cv: '/cv.pdf',
  },

  seo: {
    // Default meta description; pages can override it.
    description:
      'Sudheer Kancharla, Senior Software Engineer in Seville, Spain, focused on backend, distributed systems, cloud architecture and system design.',
    // Default social preview image (1200x630), relative to the site root.
    ogImage: '/og-image.png',
    ogImageAlt: 'Sudheer Kancharla, Senior Software Engineer',
  },
} as const;
