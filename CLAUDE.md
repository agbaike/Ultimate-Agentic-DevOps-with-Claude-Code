# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this is

Static HTML/CSS portfolio website deployed to AWS using S3 and CloudFront, provisioned with Terraform, and automated via GitHub Actions.

## Architecture

Pure HTML5 and CSS3. No JavaScript. No build step. No framework.

## Running / previewing locally

There is no dev server, build, lint, or test tooling — just open the files directly or serve the directory statically:

```
python -m http.server 8000   # or any static file server
```

Then visit `http://localhost:8000/index.html`.

## Structure

- `index.html` — the entire single-page site (nav, hero, about, services, courses, books, community/trust stats, contact, footer). Sections are plain anchor-linked (`#home`, `#about`, `#services`, `#courses`, `#book`, `#community`, `#contact`).
- `style.css` — one stylesheet for the whole site, organized as sequential per-section blocks (`/* HERO SECTION */`, `/* SERVICES */`, `/* COURSES */`, etc.) each followed by its own `@media` responsive overrides. Follow this existing block-per-section + trailing-media-query convention when editing.
- `privacy.html`, `terms.html` — standalone static pages, same styling, linked from the footer.
- `images/` — all raster assets referenced by relative path.

## Commands

terraform init
terraform plan
terraform apply

## Conventions

- All infrastructure changes go through Terraform — never modify AWS resources manually
- No JavaScript in this project
- CSS uses mobile-first approach with breakpoints at 900px, 768px, and 600px

## Safety

Never put secrets in this file. No API keys, passwords, or AWS credentials.

## Known gap

`index.html` calls `goToSection('...')` and `toggleMenu()` in `onclick` attributes (nav logo, mobile hamburger menu), but there is no `<script>` tag or `.js` file anywhere in the repo defining these functions — the mobile menu toggle is currently non-functional dead markup, not a wired-up feature.
