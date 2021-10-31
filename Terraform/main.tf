# resource "google_artifact_registry_repository" "repo" {

#   location = var.location
#   repository_id = var.repository_id
#   format = "DOCKER"
# }


resource "google_secret_manager_secret" "secret" {
  secret_id = "api_key"
  project = var.project
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
  provider = google-beta

  project = var.project
  name     = var.clrun_service
  location = var.location

  template {
    spec {
      service_account_name = "sa-pipeline-clrun@ryan-cicd.iam.gserviceaccount.com"
      containers {
        image = "northamerica-northeast1-docker.pkg.dev/${var.project}/${var.clrun_service}/v1"
        env {
          name = "OPENWEATHER_API_KEY"
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
  depends_on = [google_secret_manager_secret_version.secret-version-data, google_secret_manager_secret_iam_member.secret-access]
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