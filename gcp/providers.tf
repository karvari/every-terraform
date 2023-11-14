provider "google" {
  credentials = var.buidler-credentials
  project = var.project
  region  = var.region
  zone    = var.zone
}
