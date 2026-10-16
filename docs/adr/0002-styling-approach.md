# ADR-0002: Styling approach

- **Status:** Accepted
- **Date:** 2026-10-15

## Context

The site has a small surface: one page of sections, a case study layout, a 404 page,
and two colour themes (dark default, light). The owner wants CSS that is easy to read
and change without learning a framework, and as few dependencies as possible.

Options considered:

| Option | Pros | Cons |
| --- | --- | --- |
| **Plain CSS + custom properties** | No dependency or build step; standard CSS that will still work in 10 years; theming via variables is trivial; Astro scopes component `<style>` blocks automatically | Naming and consistency are on us; no ready-made design tokens |
| **Tailwind CSS** | Fast to prototype; consistent spacing/colour scale; purges unused CSS | Extra dependency and config; long class strings hurt readability for a non-frontend maintainer; another tool to upgrade |

## Decision

Use **plain CSS** with **custom properties** for design tokens (colours, spacing, font
sizes). They're defined once in `site/src/styles/global.css`. Component-specific rules
live in each `.astro` component's scoped `<style>` block.

Font: **Plus Jakarta Sans**, self-hosted as a single variable WOFF2 file (Latin subset,
~27 KB, SIL Open Font License) and preloaded. It was chosen by comparing candidates on the
real page. Self-hosting avoids third-party requests (privacy, GDPR) and an extra DNS/TLS
connection.

Theming: dark is the default. A `data-theme="light"` attribute on `<html>` swaps the
colour variables. A tiny inline script sets the attribute from `localStorage` before
first paint to avoid a flash of the wrong theme.

## Consequences

- Zero styling dependencies; the CSS shipped is only what we wrote.
- Changing a colour or spacing value happens in one place.
- Scoped component styles avoid global naming collisions without a methodology like BEM.
- We have to keep our own token scale disciplined (a small fixed set of variables).
