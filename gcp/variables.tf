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