resource "google_compute_network" "vpn_network" {
  count = var.create ? 1 : 0

  project                 = var.project_id
  name                    = var.network_name
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "vpn_subnet" {
  count = var.create ? 1 : 0

  project       = var.project_id
  name          = "${var.network_name}-subnet"
  ip_cidr_range = "10.0.0.0/24"
  region        = var.region
  network       = google_compute_network.vpn_network[0].id
}

resource "google_compute_vpn_gateway" "vpn_gateway" {
  count = var.create ? 1 : 0

  project = var.project_id
  name    = "${var.network_name}-gateway"
  network = google_compute_network.vpn_network[0].id
  region  = var.region
}
