# ---------------------------------------------------------------------------
# Remote state backend
# ---------------------------------------------------------------------------
#
# Bootstrap order:
#   1. Leave this block commented out and run `terraform init` to use local
#      state.
#   2. Run `terraform apply` to create your infrastructure (including, if you
#      manage it separately, the S3 bucket + DynamoDB table that will hold
#      remote state).
#   3. Once the state bucket exists, uncomment the backend block below, fill
#      in your bucket/table names, and run:
#         terraform init -migrate-state
#      This migrates your local state into the S3 backend.
#
# terraform {
#   backend "s3" {
#     bucket         = "REPLACE_WITH_YOUR_STATE_BUCKET_NAME"
#     key            = "portfolio-site/terraform.tfstate"
#     region         = "ap-south-1"
#     dynamodb_table = "REPLACE_WITH_YOUR_LOCK_TABLE_NAME"
#     encrypt        = true
#   }
# }
