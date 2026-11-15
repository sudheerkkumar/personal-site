# CLAUDE.md

Context and conventions for Claude Code sessions in this repo.

## Project

Personal portfolio site for Sudheer Kancharla (Senior Backend Engineer & Tech Lead,
distributed systems, Seville). Domain: `sudheerkancharla.dev`.

The owner is a backend engineer. **Frontend is not the learning focus.** Keep frontend
code minimal, readable and boring. The learning focus is AWS infra, Terraform, CI/CD,
observability and system design docs.

## Hard rules

- **Never use the `gh` CLI. Never run `git push`.** Commit locally only; the owner pushes.
  (Also enforced by deny rules in `.claude/settings.json`; keep that file unchanged.)
- Do not change git or SSH configuration. This repo uses `core.sshCommand` from the
  owner's personal include config.
- Ask before adding any npm dependency beyond `astro` and `@astrojs/sitemap`.
- Show a plan and wait for approval before larger changes.
- One focused commit per step, Conventional Commits (`feat:`, `fix:`, `docs:`, `chore:`,
  `build:`, `ci:`, scoped where useful, e.g. `feat(site):`).
- Briefly explain non-obvious choices.

## Stack

- Node 24 LTS (`.nvmrc`). Use `nvm use` before running npm commands.
- Astro, static output only (no SSR adapter), TypeScript strict.
- Plain CSS with custom properties in `site/src/styles/global.css`. No Tailwind, no UI
  framework, no React.
- Near-zero client JS: only two small inline scripts, the theme toggle and the cursor
  spotlight (mouse/trackpad only, disabled for reduced motion). Ask before adding more.
- Content via Astro content collections (`site/src/content.config.ts`).

## Layout

- `site/`: Astro project. Run `npm run dev | build | preview` from here.
- `site/src/site.config.ts`: single source of truth for name, URLs, socials, SEO.
- `infra/`: Terraform (Phase 3). `docs/adr/`: ADRs (Status, Context, Decision,
  Consequences). `docs/architecture/`: C4 diagrams.

## Conventions

- Case studies follow the fixed structure in `docs/case-study-template.md`:
  Context → Problem → Constraints → Options considered → Decision → Trade-offs →
  Outcome → What I'd do differently.
- `draft: true` content shows in `npm run dev` and is excluded from `npm run build`.
  If no case study is published, the Case Studies section and nav link are hidden.
- Output must stay deployable as plain static files to S3. Pages are directory-style
  (`/foo/` → `foo/index.html`), so CloudFront needs an index-rewrite function (see
  `infra/README.md`).
- Quality bar: semantic HTML, keyboard accessible, WCAG AA contrast, Lighthouse 95+.
