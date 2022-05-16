data "google_iam_policy" "admin" {
  provider = google-beta
  binding {
    role = "roles/apigateway.viewer"
    members = [
      "user:jane@example.com",
    ]
  }
}

resource "google_api_gateway_api" "api" {
  provider = google-beta
  api_id = var.api-gateway.api-id
  display_name = var.api-gateway.display-name
}

resource "google_api_gateway_api_config" "api_cfg" {
  provider = google-beta
  api = google_api_gateway_api.api_cfg.api_id
  api_config_id = "cfg"

  openapi_documents {
    document {
      path = "spec.yaml"
      contents = filebase64("test-fixtures/apigateway/openapi.yaml")
    }
  }
  lifecycle {
    create_before_destroy = true
  }
}
resource "google_api_gateway_api_config_iam_policy" "policy" {
  provider = google-beta
  api = google_api_gateway_api_config.api_cfg.api
  api_config = google_api_gateway_api_config.api_cfg.api_config_id
  policy_data = data.google_iam_policy.admin.policy_data
}
resource "google_api_gateway_api_config_iam_binding" "binding" {
  provider = google-beta
  api = google_api_gateway_api_config.api_cfg.api
  api_config = google_api_gateway_api_config.api_cfg.api_config_id
  role = "roles/apigateway.viewer"
  members = [
    "user:jane@example.com",
  ]
}
resource "google_api_gateway_api_config_iam_member" "member" {
  provider = google-beta
  api = google_api_gateway_api_config.api_cfg.api
  api_config = google_api_gateway_api_config.api_cfg.api_config_id
  role = "roles/apigateway.viewer"
  member = "user:jane@example.com"
}
resource "google_api_gateway_api_iam_policy" "policy" {
  provider = google-beta
  project = google_api_gateway_api.api.project
  api = google_api_gateway_api.api.api_id
  policy_data = data.google_iam_policy.admin.policy_data
}
resource "google_api_gateway_api_iam_binding" "binding" {
  provider = google-beta
  project = google_api_gateway_api.api.project
  api = google_api_gateway_api.api.api_id
  role = "roles/apigateway.viewer"
  members = [
    "user:jane@example.com",
  ]
}
resource "google_api_gateway_api_iam_member" "member" {
  provider = google-beta
  project = google_api_gateway_api.api.project
  api = google_api_gateway_api.api.api_id
  role = "roles/apigateway.viewer"
  member = "user:jane@example.com"
}
resource "google_api_gateway_gateway" "api_gw" {
  provider = google-beta
  api_config = google_api_gateway_api_config.api_gw.id
  gateway_id = "api-gw"
}
resource "google_api_gateway_gateway_iam_policy" "policy" {
  provider = google-beta
  project = google_api_gateway_gateway.api_gw.project
  region = google_api_gateway_gateway.api_gw.region
  gateway = google_api_gateway_gateway.api_gw.gateway_id
  policy_data = data.google_iam_policy.admin.policy_data
}
resource "google_api_gateway_gateway_iam_binding" "binding" {
  provider = google-beta
  project = google_api_gateway_gateway.api_gw.project
  region = google_api_gateway_gateway.api_gw.region
  gateway = google_api_gateway_gateway.api_gw.gateway_id
  role = "roles/apigateway.viewer"
  members = [
    "user:jane@example.com",
  ]
}
resource "google_api_gateway_gateway_iam_member" "member" {
  provider = google-beta
  project = google_api_gateway_gateway.api_gw.project
  region = google_api_gateway_gateway.api_gw.region
  gateway = google_api_gateway_gateway.api_gw.gateway_id
  role = "roles/apigateway.viewer"
  member = "user:jane@example.com"
}