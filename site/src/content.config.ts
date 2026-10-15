// Content collections: typed Markdown content validated at build time.
// A frontmatter field that doesn't match the schema fails the build.
import { defineCollection } from 'astro:content';
import { glob } from 'astro/loaders';
import { z } from 'astro/zod';

const experience = defineCollection({
  loader: glob({ pattern: '**/*.md', base: './src/content/experience' }),
  schema: z.object({
    role: z.string(),
    company: z.string(),
    companyUrl: z.url().optional(),
    // Free text (e.g. "2022 to present") rather than dates, to keep display simple.
    period: z.string(),
    // Sort key: lower numbers appear first (most recent role = 1).
    order: z.number(),
    tags: z.array(z.string()).default([]),
  }),
});

const projects = defineCollection({
  loader: glob({ pattern: '**/*.md', base: './src/content/projects' }),
  schema: z.object({
    title: z.string(),
    description: z.string(),
    tech: z.array(z.string()).default([]),
    links: z.array(z.object({ label: z.string(), href: z.string() })).default([]),
    order: z.number(),
  }),
});

const caseStudies = defineCollection({
  // Files starting with "_" are ignored, so scratch files can live alongside.
  loader: glob({ pattern: '**/[^_]*.md', base: './src/content/case-studies' }),
  schema: z.object({
    title: z.string(),
    // One-sentence summary: used on the card and as the page's meta description.
    summary: z.string(),
    tags: z.array(z.string()).default([]),
    order: z.number(),
    // Drafts render in `npm run dev` only and are excluded from production builds.
    draft: z.boolean().default(false),
  }),
});

export const collections = { experience, projects, caseStudies };
