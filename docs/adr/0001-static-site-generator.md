# ADR-0001: Static site generator

- **Status:** Accepted
- **Date:** 2026-10-15

## Context

The site is a personal portfolio: one home page with several sections, a handful of case
study pages written in Markdown, and a 404 page. It will be hosted as static files on
S3 behind CloudFront (Phase 3), deployed by GitHub Actions (Phase 4).

Requirements that drive the choice:

- Output must be **plain static files**. No server runtime, no Lambda@Edge rendering.
- Content authored in **Markdown** with typed frontmatter (e.g. `draft`, tags, dates).
- **Near-zero client JavaScript**, so Lighthouse 95+ is easy to hold.
- The owner is a backend engineer, and the frontend is not the learning focus. The code
  should be small, readable and low-maintenance.
- Reusable layout/components (head/SEO tags, cards) without copy-paste.

Options considered:

| Option | Pros | Cons |
| --- | --- | --- |
| **Plain HTML/CSS** | Zero tooling; total control; nothing to upgrade | No Markdown pipeline; head/SEO tags and layout duplicated per page; sitemap by hand; drafts by hand |
| **Hugo** | Very fast single binary; mature; Markdown-first | Go templates are terse and unfamiliar; weaker type-safety for frontmatter; component reuse is clumsier |
| **Next.js static export** | Huge ecosystem; React components | Ships a React runtime by default (more JS); `output: 'export'` has caveats (no image optimisation, some features unsupported); heavier than needed for a content site |
| **Astro** | Static-first, ships zero JS by default; content collections with Zod schemas give typed frontmatter; HTML-like `.astro` components; official sitemap integration | Node toolchain and npm dependencies to keep updated; smaller ecosystem than Next.js; major versions arrive roughly yearly |

## Decision

Use **Astro** (pinned to 7.3.8) in static output mode, with no SSR adapter, TypeScript
strict, content collections for experience/projects/case studies, and `@astrojs/sitemap`.

## Consequences

- `astro build` writes plain HTML/CSS/assets to `site/dist/`, ready for S3.
- Frontmatter is validated at build time. A typo in a case study fails the build instead
  of rendering wrong.
- Drafts are filtered in code (`draft: true` shown only in dev), with no extra plugin.
- A Node toolchain is needed locally and in CI (Node 24 LTS via `.nvmrc`).
- Astro major upgrades will need occasional attention. Dependencies are pinned exactly.
- **Hosting implication:** Astro emits directory-style pages (`/case-studies/foo/` →
  `case-studies/foo/index.html`). With a private S3 bucket behind CloudFront (OAC), only
  the root `/` gets a default object, and S3 does no index resolution for sub-paths.
  Phase 3 must therefore add:
  - a **CloudFront Function** on viewer request that rewrites `/path/` and extension-less
    `/path` to `/path/index.html`;
  - **custom error responses** mapping `403` and `404` from S3 to `/404.html` with status
    `404`.

  The alternative, `build.format: 'file'` (`foo.html`), was rejected. It still needs a
  rewrite for clean URLs, so it saves nothing.
