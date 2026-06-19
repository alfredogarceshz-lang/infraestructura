# WIF + GitHub OIDC bootstrap (manual)

1. Create Workload Identity Pool.
2. Create OIDC provider linked to token.actions.githubusercontent.com.
3. Create CI service account per environment.
4. Grant least-privilege roles to CI service account.
5. Grant iam.workloadIdentityUser binding from principalSet to CI service account.
6. Store values as GitHub repository variables/secrets:
   - TFSTATE_BUCKET (variable)
   - GCP_WORKLOAD_IDENTITY_PROVIDER (secret)
   - GCP_SERVICE_ACCOUNT (secret)

Recommended role baseline for CI:
- roles/storage.admin (state bucket scope)
- roles/iam.serviceAccountTokenCreator (if impersonation chain needed)
- roles/bigquery.admin (if BigQuery managed by Terraform)
- roles/secretmanager.admin (if secrets managed by Terraform)
