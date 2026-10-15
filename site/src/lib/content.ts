import { getCollection } from 'astro:content';

const byOrder = (a: { data: { order: number } }, b: { data: { order: number } }) =>
  a.data.order - b.data.order;

/**
 * Case studies visible in this build: everything in dev, non-drafts in production.
 * `import.meta.env.DEV` is true for `astro dev` and false for `astro build`.
 */
export async function getVisibleCaseStudies() {
  const entries = await getCollection('caseStudies', ({ data }) => import.meta.env.DEV || !data.draft);
  return entries.sort(byOrder);
}

export async function getExperience() {
  return (await getCollection('experience')).sort(byOrder);
}

export async function getProjects() {
  return (await getCollection('projects')).sort(byOrder);
}
