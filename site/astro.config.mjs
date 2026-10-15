// @ts-check
import { defineConfig } from 'astro/config';
import sitemap from '@astrojs/sitemap';
import { site } from './src/site.config.ts';

export default defineConfig({
  // Absolute base URL. Used for canonical URLs, Open Graph URLs and the sitemap.
  site: site.url,
  // Plain static files only, no server runtime. This is Astro's default; stated explicitly.
  output: 'static',
  // Pages are emitted as /path/index.html and linked as /path/.
  // CloudFront needs an index-rewrite function for this (see infra/README.md).
  trailingSlash: 'always',
  build: { format: 'directory' },
  // Writes sitemap-index.xml + sitemap-0.xml listing every built page.
  integrations: [sitemap()],
});
