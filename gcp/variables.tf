variable "buidler-credentials" {
   file-path = "string" # typically username.json. File contains GCP service account key
}
variable "project" {}
variable "region" {}
variable "zone" {}
variable "api-gateway" {
  display-name = string
  api-id = string
  managed_service = string
  labels = string
  project = string
}
