resource "google_service_account" "sa" {
  for_each = toset(var.service_accounts)

  project      = var.project_id
  account_id   = each.value
  display_name = each.value
}

locals {
  sa_role_pairs = flatten([
    for sa_name, roles in var.project_roles : [
      for role in roles : {
        key    = "${sa_name}-${replace(role, "/", "-")}"
        sa     = sa_name
        role   = role
        member = "serviceAccount:${sa_name}@${var.project_id}.iam.gserviceaccount.com"
      }
    ]
  ])

  sa_role_map = { for item in local.sa_role_pairs : item.key => item }
}

# Bind least-privilege roles per service account at project scope.
resource "google_project_iam_member" "sa_roles" {
  for_each = local.sa_role_map

  project = var.project_id
  role    = each.value.role
  member  = each.value.member

  depends_on = [google_service_account.sa]
}
