locals {
  effective_batch_id = var.batch_id != null ? var.batch_id : "dp-sls-${var.environment}"
}

resource "google_dataproc_batch" "main" {
  count = var.create ? 1 : 0

  project  = var.project_id
  location = var.region
  batch_id = local.effective_batch_id
  labels   = var.labels

  pyspark_batch {
    main_python_file_uri = var.main_python_file_uri
    args                 = var.args
    python_file_uris     = var.python_file_uris
    jar_file_uris        = var.jar_file_uris
  }

  runtime_config {
    version         = var.version
    container_image = var.container_image
    properties      = var.properties
  }

  environment_config {
    execution_config {
      service_account = var.service_account_email
      subnetwork_uri  = var.subnetwork_uri
      ttl             = "${var.ttl_seconds}s"
    }
  }

  lifecycle {
    precondition {
      condition     = !var.create || (var.main_python_file_uri != null && var.main_python_file_uri != "")
      error_message = "main_python_file_uri es requerido cuando create=true para Dataproc Serverless batch."
    }
    precondition {
      condition     = !var.create || (var.service_account_email != null && var.service_account_email != "")
      error_message = "service_account_email es requerido cuando create=true para Dataproc Serverless batch."
    }
  }
}
