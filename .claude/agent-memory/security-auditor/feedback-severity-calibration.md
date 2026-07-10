---
name: feedback-severity-calibration
description: User wants Terraform audit severity calibrated to the actual site (low-traffic static portfolio), not generic checklist maximalism — don't inflate optional hardening into CRITICAL/HIGH
metadata:
  type: feedback
---

When auditing this repo's `terraform/` directory, calibrate severity to the real risk profile of a low-traffic static HTML/CSS portfolio site, not a generic cloud-security checklist applied uniformly.

**Why:** the user explicitly instructed (2026-07-10 audit request) not to invent issues that don't apply to a static-site-only setup — e.g. missing WAF should be at most a LOW/optional hardening note, never CRITICAL, given the site's traffic and threat profile. They want concrete, file:line-referenced findings with exact fixes, not maximal checklist coverage regardless of applicability.

**How to apply:**
- Don't flag checklist items (e.g. OIDC trust policy scoping, IAM least privilege) as findings when the relevant resources simply don't exist yet in `terraform/` — note them as N/A/out of scope instead of inventing a finding.
- Reserve CRITICAL/HIGH for things with real exploitable impact (public bucket, wildcard principal, hardcoded creds, HTTP allowed to origin/viewer).
- Things like missing versioning, missing explicit SSE config (when AWS default SSE-S3 already applies), missing access logging, or missing WAF belong at LOW/MEDIUM as defense-in-depth notes, not blockers.
- Always give exact code fixes, not general advice. See [[portfolio-site-terraform-baseline]] for the current state of this specific project's terraform/ files.
