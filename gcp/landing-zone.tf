# resources include folder structure, network, super users, and initial projects

resource "google_compute_network" "vpc_network" {
  name                    = "shared-vpc"
  auto_create_subnetworks = false
  mtu                     = 1460
}

resource "google_compute_subnetwork" "default" {
  name          = "default-subnet"
  ip_cidr_range = "10.0.1.0/24"
  region        = "us-west1"
  network       = google_compute_network.vpc_network.id
}
