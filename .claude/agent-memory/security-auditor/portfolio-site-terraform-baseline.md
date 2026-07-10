---
name: portfolio-site-terraform-baseline
description: Snapshot of terraform/ (S3 + CloudFront static site) security posture as of 2026-07-10 — what's already correct vs. known gaps, so future audits don't re-flag settled items or re-derive scope
metadata:
  type: project
---

Repo's `terraform/` directory (providers.tf, variables.tf, main.tf, outputs.tf, backend.tf) provisions a private S3 bucket served through CloudFront with OAC, for the static HTML/CSS portfolio site described in the root CLAUDE.md.

**Already correctly implemented (do not re-flag as findings unless code changes):**
- `aws_s3_bucket_public_access_block` — all four block-public settings true (main.tf ~L18-25)
- `aws_s3_bucket_ownership_controls` set to `BucketOwnerEnforced` (disables ACLs entirely)
- Bucket policy scoped to `cloudfront.amazonaws.com` service principal + `AWS:SourceArn` condition tied to the specific distribution ARN (least privilege, no wildcard principal)
- CloudFront uses OAC (`aws_cloudfront_origin_access_control`), not legacy OAI
- `viewer_protocol_policy = "redirect-to-https"` on default_cache_behavior (HTTP->HTTPS enforced)
- Provider pinned (`hashicorp/aws ~> 5.0`, `required_version >= 1.5`), lock file present
- No hardcoded secrets/ARNs/account IDs anywhere in the five .tf files
- `*.tfstate` is gitignored, so even though the backend is local-by-default, state isn't at risk of being committed

**Known gaps as of 2026-07-10 (raised in the 2026-07-10 audit, re-check on next review to see if addressed):**
- No `aws_s3_bucket_versioning` resource
- No explicit `aws_s3_bucket_server_side_encryption_configuration` (relies on AWS's automatic default SSE-S3, not declared in IaC)
- No CloudFront `response_headers_policy_id` / custom response headers policy — no CSP, X-Frame-Options, etc.
- No CloudFront `logging_config` block (no access logging)
- `backend.tf` remote S3 backend is intentionally commented out with a documented bootstrap procedure (local state until the state bucket exists, then `terraform init -migrate-state`). This is a deliberate bootstrap pattern, not an oversight — but flag it as a reminder if a `.github/workflows/` CI file appears that runs `terraform apply`, since ephemeral runners need a remote backend to persist state across runs.
- `variable "domain_name"` is declared but unused in main.tf — no ACM cert / custom domain / aliases wired up yet, distribution relies on `cloudfront_default_certificate = true`. Not a security defect on its own, but means `minimum_protocol_version` can't be pinned to TLSv1.2_2021 until a custom domain + ACM cert are added.
- No `.github/workflows/` directory exists yet despite CLAUDE.md describing GitHub Actions automation — so this audit's OIDC trust policy checklist items are currently N/A (no IAM/OIDC resources exist anywhere in the repo). Check again once CI is wired up.

**Why this matters:** future audits of this same terraform/ directory should diff against this snapshot rather than re-deriving the whole checklist from scratch, and should watch for the CI/backend gap becoming live (i.e., a workflow file appearing) as the trigger to escalate the local-state finding.
