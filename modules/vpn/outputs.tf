output "network_name" {
  value = var.create ? google_compute_network.vpn_network[0].name : null
}

output "subnet_name" {
  value = var.create ? google_compute_subnetwork.vpn_subnet[0].name : null
}

output "gateway_id" {
  value = var.create ? google_compute_vpn_gateway.vpn_gateway[0].id : null
}

output "vpn_enabled" {
  value = var.create
}
