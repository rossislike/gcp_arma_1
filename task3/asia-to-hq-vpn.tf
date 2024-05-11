resource "google_compute_vpn_gateway" "target_gateway_a" {
  name    = "vpn-a"
  network = google_compute_network.vpc_a.id
  region = var.vpc_a["region"]
}

resource "google_compute_address" "vpc_a_static_ip" {
  name = "vpc-a-static-ip"
  region = var.vpc_a["region"]
}

resource "google_compute_forwarding_rule" "fr_esp_a" {
  name        = "fr-esp"
  ip_protocol = "ESP"
  ip_address  = google_compute_address.vpc_a_static_ip.address
  target      = google_compute_vpn_gateway.target_gateway_a.id
  region = var.vpc_a["region"]
}

resource "google_compute_forwarding_rule" "fr_udp500_a" {
  name        = "fr-udp500"
  ip_protocol = "UDP"
  port_range  = "500"
  ip_address  = google_compute_address.vpc_a_static_ip.address
  target      = google_compute_vpn_gateway.target_gateway_a.id
  region = var.vpc_a["region"]
}

resource "google_compute_forwarding_rule" "fr_udp4500_a" {
  name        = "fr-udp4500"
  ip_protocol = "UDP"
  port_range  = "4500"
  ip_address  = google_compute_address.vpc_a_static_ip.address
  target      = google_compute_vpn_gateway.target_gateway_a.id
  region = var.vpc_a["region"]
}

resource "google_compute_vpn_tunnel" "hq_to_asia_tunnel" {
  name          = "hq-to-asia-tunnel"
  peer_ip       = google_compute_address.vpc_b_static_ip.address
  shared_secret = var.vpn_secret
  local_traffic_selector = [var.vpc_a["cidr"]]

  target_vpn_gateway = google_compute_vpn_gateway.target_gateway_a.id
  
  depends_on = [
    google_compute_forwarding_rule.fr_esp_a,
    google_compute_forwarding_rule.fr_udp500_a,
    google_compute_forwarding_rule.fr_udp4500_a,
  ]
}

resource "google_compute_route" "hq_to_asia_route" {
  name       = "hq-to-asia-route"
  network    = google_compute_network.vpc_a.name
  dest_range = var.vpc_b["cidr3"]
  priority   = 1000

  next_hop_vpn_tunnel = google_compute_vpn_tunnel.hq_to_asia_tunnel.id
}

resource "google_compute_vpn_gateway" "target_gateway_b" {
  name    = "vpn-b"
  network = google_compute_network.vpc_b.id
  region = var.vpc_b["region3"]
  provider = google.gcp-service-project
}

resource "google_compute_address" "vpc_b_static_ip" {
  name = "vpc-b-static-ip"
  region = var.vpc_b["region3"]
  provider = google.gcp-service-project
}

resource "google_compute_forwarding_rule" "fr_esp_b" {
  name        = "fr-esp"
  ip_protocol = "ESP"
  ip_address  = google_compute_address.vpc_b_static_ip.address
  target      = google_compute_vpn_gateway.target_gateway_b.id
  region = var.vpc_b["region3"]
  provider = google.gcp-service-project
}

resource "google_compute_forwarding_rule" "fr_udp500_b" {
  name        = "fr-udp500"
  ip_protocol = "UDP"
  port_range  = "500"
  ip_address  = google_compute_address.vpc_b_static_ip.address
  target      = google_compute_vpn_gateway.target_gateway_b.id
  region = var.vpc_b["region3"]
  provider = google.gcp-service-project
}

resource "google_compute_forwarding_rule" "fr_udp4500_b" {
  name        = "fr-udp4500"
  ip_protocol = "UDP"
  port_range  = "4500"
  ip_address  = google_compute_address.vpc_b_static_ip.address
  target      = google_compute_vpn_gateway.target_gateway_b.id
  region = var.vpc_b["region3"]
  provider = google.gcp-service-project
}

resource "google_compute_vpn_tunnel" "asia_to_hq_tunnel" {
  name = "asia-to-hq-tunnel"
  peer_ip = google_compute_address.vpc_a_static_ip.address
  shared_secret = var.vpn_secret
  local_traffic_selector = [var.vpc_b["cidr3"]]
  provider = google.gcp-service-project

  target_vpn_gateway = google_compute_vpn_gateway.target_gateway_b.id

  depends_on = [ 
    google_compute_forwarding_rule.fr_esp_b,
    google_compute_forwarding_rule.fr_udp500_b,
    google_compute_forwarding_rule.fr_udp4500_b
  ]
}

resource "google_compute_route" "asia_to_hq_route" {
  name       = "asia-to-hq-route"
  network    = google_compute_network.vpc_b.name
  dest_range = var.vpc_a["cidr"]
  priority   = 1000
  provider = google.gcp-service-project

  next_hop_vpn_tunnel = google_compute_vpn_tunnel.asia_to_hq_tunnel.id
}