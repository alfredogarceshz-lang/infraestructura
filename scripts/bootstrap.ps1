param(
  [Parameter(Mandatory = $true)]
  [string]$ProjectId,

  [Parameter(Mandatory = $true)]
  [string]$Region,

  [Parameter(Mandatory = $true)]
  [string]$StateBucket
)

Write-Host "Enabling required APIs in $ProjectId..."
gcloud services enable \
  iam.googleapis.com \
  cloudresourcemanager.googleapis.com \
  serviceusage.googleapis.com \
  compute.googleapis.com \
  storage.googleapis.com \
  secretmanager.googleapis.com \
  bigquery.googleapis.com \
  composer.googleapis.com \
  dataproc.googleapis.com \
  dataplex.googleapis.com \
  --project $ProjectId

Write-Host "Creating Terraform state bucket $StateBucket..."
gsutil mb -p $ProjectId -l $Region gs://$StateBucket
gsutil versioning set on gs://$StateBucket

Write-Host "Bootstrap base completed. Configure WIF and GitHub OIDC next."
