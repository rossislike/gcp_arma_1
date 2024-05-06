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

resource "google_compute_vpn_tunnel" "tunnel1" {
  name          = "tunnel1"
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

resource "google_compute_route" "route1" {
  name       = "route1"
  network    = google_compute_network.vpc_a.name
  dest_range = var.vpc_b["cidr3"]
  priority   = 1000

  next_hop_vpn_tunnel = google_compute_vpn_tunnel.tunnel1.id
}

resource "google_compute_vpn_gateway" "target_gateway_b" {
  name    = "vpn-b"
  network = google_compute_network.vpc_b.id
  region = var.vpc_b["region3"]
}

resource "google_compute_address" "vpc_b_static_ip" {
  name = "vpc-b-static-ip"
  region = var.vpc_b["region3"]
}

resource "google_compute_forwarding_rule" "fr_esp_b" {
  name        = "fr-esp"
  ip_protocol = "ESP"
  ip_address  = google_compute_address.vpc_b_static_ip.address
  target      = google_compute_vpn_gateway.target_gateway_b.id
  region = var.vpc_b["region3"]
}

resource "google_compute_forwarding_rule" "fr_udp500_b" {
  name        = "fr-udp500"
  ip_protocol = "UDP"
  port_range  = "500"
  ip_address  = google_compute_address.vpc_b_static_ip.address
  target      = google_compute_vpn_gateway.target_gateway_b.id
  region = var.vpc_b["region3"]
}

resource "google_compute_forwarding_rule" "fr_udp4500_b" {
  name        = "fr-udp4500"
  ip_protocol = "UDP"
  port_range  = "4500"
  ip_address  = google_compute_address.vpc_b_static_ip.address
  target      = google_compute_vpn_gateway.target_gateway_b.id
  region = var.vpc_b["region3"]
}

resource "google_compute_vpn_tunnel" "tunnel2" {
  name = "tunnel2"
  peer_ip = google_compute_address.vpc_a_static_ip.address
  shared_secret = var.vpn_secret
  local_traffic_selector = [var.vpc_b["cidr3"]]

  target_vpn_gateway = google_compute_vpn_gateway.target_gateway_b.id

  depends_on = [ 
    google_compute_forwarding_rule.fr_esp_b,
    google_compute_forwarding_rule.fr_udp500_b,
    google_compute_forwarding_rule.fr_udp4500_b
   ]
}

resource "google_compute_route" "route2" {
  name       = "route2"
  network    = google_compute_network.vpc_b.name
  dest_range = var.vpc_a["cidr"]
  priority   = 1000

  next_hop_vpn_tunnel = google_compute_vpn_tunnel.tunnel2.id
}