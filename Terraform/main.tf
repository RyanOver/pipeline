resource "google_secret_manager_secret" "secret" {
  secret_id = "api_key"
  replication {
    automatic = true
  }
}

resource "google_secret_manager_secret_version" "secret-version-data" {
  secret = google_secret_manager_secret.secret.name
  secret_data = var.api_key
}

resource "google_secret_manager_secret_iam_member" "secret-access" {

  secret_id = google_secret_manager_secret.secret.id
  role      = "roles/secretmanager.secretAccessor"
  member    = "serviceAccount:sa-pipeline-clrun@ryan-cicd.iam.gserviceaccount.com"
  depends_on = [google_secret_manager_secret.secret]
}


resource "google_cloud_run_service" "default" {
  name     = var.clrun_service
  location = var.location

  template {
    spec {
      containers {
        image = "northamerica-northeast1-docker.pkg.dev/${var.project}/${var.clrun_service}/v1"
        env {
          name = "SECRET_ENV_VAR"
      value_from {
            secret_key_ref {
              name = google_secret_manager_secret.secret.secret_id
              key = "1"
            }
          }
        }
      }
    }
  }
  depends_on = [google_secret_manager_secret_version.secret-version-data]
}

data "google_iam_policy" "noauth" {
  binding {
    role = "roles/run.invoker"
    members = [
      "allUsers",
    ]
  }
}

resource "google_cloud_run_service_iam_policy" "noauth" {
  location    = google_cloud_run_service.default.location
  project     = google_cloud_run_service.default.project
  service     = google_cloud_run_service.default.name

  policy_data = data.google_iam_policy.noauth.policy_data
}