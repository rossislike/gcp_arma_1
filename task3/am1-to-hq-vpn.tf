

resource "google_compute_vpn_tunnel" "hq_to_am1_tunnel" {
  name          = "hq-to-am1-tunnel"
  peer_ip       = google_compute_address.vpc_b_static_ip_am1.address
  shared_secret = var.vpn_secret
  local_traffic_selector = [var.vpc_a["cidr"]]

  target_vpn_gateway = google_compute_vpn_gateway.target_gateway_a.id
  
  depends_on = [
    google_compute_forwarding_rule.fr_esp_a,
    google_compute_forwarding_rule.fr_udp500_a,
    google_compute_forwarding_rule.fr_udp4500_a,
  ]
}

resource "google_compute_route" "hq_to_am1_route" {
  name       = "hq-to-am1-route"
  network    = google_compute_network.vpc_a.name
  dest_range = var.vpc_b["cidr1"]
  priority   = 1000

  next_hop_vpn_tunnel = google_compute_vpn_tunnel.hq_to_am1_tunnel.id
}

resource "google_compute_vpn_gateway" "target_gateway_am1_to_hq" {
  name    = "vpn-am1-to-hq"
  network = google_compute_network.vpc_b.id
  region = var.vpc_b["region1"]
  provider = google.gcp-service-project
}

resource "google_compute_address" "vpc_b_static_ip_am1" {
  name = "vpc-b-static-ip-am1"
  region = var.vpc_b["region1"]
  provider = google.gcp-service-project
}

resource "google_compute_forwarding_rule" "fr_esp_am1" {
  name        = "fr-esp-am1"
  ip_protocol = "ESP"
  ip_address  = google_compute_address.vpc_b_static_ip_am1.address
  target      = google_compute_vpn_gateway.target_gateway_am1_to_hq.id
  region = var.vpc_b["region1"]
  provider = google.gcp-service-project
}

resource "google_compute_forwarding_rule" "fr_udp500_am1" {
  name        = "fr-udp500-am1"
  ip_protocol = "UDP"
  port_range  = "500"
  ip_address  = google_compute_address.vpc_b_static_ip_am1.address
  target      = google_compute_vpn_gateway.target_gateway_am1_to_hq.id
  region = var.vpc_b["region1"]
  provider = google.gcp-service-project
}

resource "google_compute_forwarding_rule" "fr_udp4500_am1" {
  name        = "fr-udp4500-am1"
  ip_protocol = "UDP"
  port_range  = "4500"
  ip_address  = google_compute_address.vpc_b_static_ip_am1.address
  target      = google_compute_vpn_gateway.target_gateway_am1_to_hq.id
  region = var.vpc_b["region1"]
  provider = google.gcp-service-project
}

resource "google_compute_vpn_tunnel" "am1_to_hq_tunnel" {
  name = "am1-to-hq-tunnel"
  peer_ip = google_compute_address.vpc_a_static_ip.address
  shared_secret = var.vpn_secret
  local_traffic_selector = [var.vpc_b["cidr1"]]
  provider = google.gcp-service-project

  target_vpn_gateway = google_compute_vpn_gateway.target_gateway_am1_to_hq.id

  depends_on = [ 
    google_compute_forwarding_rule.fr_esp_am1,
    google_compute_forwarding_rule.fr_udp500_am1,
    google_compute_forwarding_rule.fr_udp4500_am1
   ]
}

resource "google_compute_route" "am1_to_hq_route" {
  name       = "am1-to-hq-route"
  network    = google_compute_network.vpc_b.name
  dest_range = var.vpc_a["cidr"]
  priority   = 1000
  provider = google.gcp-service-project

  next_hop_vpn_tunnel = google_compute_vpn_tunnel.am1_to_hq_tunnel.id
}