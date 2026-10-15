// @ts-check
import { defineConfig } from 'astro/config';

export default defineConfig({
  // Absolute base URL. Used for canonical URLs, Open Graph URLs and the sitemap.
  site: 'https://sudheerkancharla.dev',
  // Plain static files only, no server runtime. This is Astro's default; stated explicitly.
  output: 'static',
  // Pages are emitted as /path/index.html and linked as /path/.
  // CloudFront needs an index-rewrite function for this (see infra/README.md).
  trailingSlash: 'always',
  build: { format: 'directory' },
});
