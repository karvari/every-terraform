data "google_access_approval_folder_service_account" "service_account" {
  folder_id = "my-folder"
}
data "google_access_approval_organization_service_account" "service_account" {
  organization_id = "my-organization"
}
data "google_access_approval_project_service_account" "service_account" {
  project_id = "my-project"
}
