data "google_secret_manager_secret_version" "vpn_secret" { 
  secret = "my-secret"
  version = "latest"
}

resource "google_compute_vpn_gateway" "eu_tgw" {
  name    = "eu-tgw"
  network = google_compute_network.game_server_vpc.id
  region = "europe-central2"
}

resource "google_compute_address" "eu_static_ip" {
  name = "eu-static-ip"
  region = "europe-central2"
}

resource "google_compute_forwarding_rule" "eu_fr_exp" {
  name        = "eu-fr-esp"
  ip_protocol = "ESP"
  ip_address  = google_compute_address.eu_static_ip.address
  target      = google_compute_vpn_gateway.eu_tgw.id
  region = "europe-central2"
}

resource "google_compute_forwarding_rule" "eu_fr_udp500" {
  name        = "eu-fr-udp500"
  ip_protocol = "UDP"
  port_range  = "500"
  ip_address  = google_compute_address.eu_static_ip.address
  target      = google_compute_vpn_gateway.eu_tgw.id
  region = "europe-central2"
}

resource "google_compute_forwarding_rule" "eu_fr_udp4500" {
  name        = "eu-fr-udp4500"
  ip_protocol = "UDP"
  port_range  = "4500"
  ip_address  = google_compute_address.eu_static_ip.address
  target      = google_compute_vpn_gateway.eu_tgw.id
  region = "europe-central2"
}

resource "google_compute_vpn_tunnel" "eu_to_asia_tunnel" {
  name          = "eu-to-asia-tunnel"
  peer_ip       = google_compute_address.asia_static_ip.address
  shared_secret = data.google_secret_manager_secret_version.vpn_secret.secret
  local_traffic_selector = ["10.151.1.0/24"]
  remote_traffic_selector = ["192.168.1.0/24"]
  ike_version = 2

  target_vpn_gateway = google_compute_vpn_gateway.eu_tgw.id
  
  depends_on = [
    google_compute_forwarding_rule.eu_fr_exp,
    google_compute_forwarding_rule.eu_fr_udp500,
    google_compute_forwarding_rule.eu_fr_udp4500,
  ]
}

resource "google_compute_vpn_gateway" "asia_tgw" {
  name    = "asia-tgw"
  network = google_compute_network.game_client_vpc.id
  region = "asia-northeast1"

}

resource "google_compute_address" "asia_static_ip" {
  name = "asia-static-ip"
  region = "asia-northeast1"

}

resource "google_compute_forwarding_rule" "asia_fr_esp_b" {
  name        = "asia-fr-esp"
  ip_protocol = "ESP"
  ip_address  = google_compute_address.asia_static_ip.address
  target      = google_compute_vpn_gateway.asia_tgw.id
  region = "asia-northeast1"

}

resource "google_compute_forwarding_rule" "asia_fr_udp500_b" {
  name        = "asia-fr-udp500"
  ip_protocol = "UDP"
  port_range  = "500"
  ip_address  = google_compute_address.asia_static_ip.address
  target      = google_compute_vpn_gateway.asia_tgw.id
  region = "asia-northeast1"
}

resource "google_compute_forwarding_rule" "asia_fr_udp4500_b" {
  name        = "asia-fr-udp4500"
  ip_protocol = "UDP"
  port_range  = "4500"
  ip_address  = google_compute_address.asia_static_ip.address
  target      = google_compute_vpn_gateway.asia_tgw.id
  region = "asia-northeast1"
}

resource "google_compute_vpn_tunnel" "asia_to_eu_tunnel" {
  name = "asia-to-eu-tunnel"
  peer_ip = google_compute_address.eu_static_ip.address
  shared_secret = data.google_secret_manager_secret_version.vpn_secret.secret
  local_traffic_selector = ["192.168.1.0/24"]
  remote_traffic_selector = ["10.151.1.0/24"]

  ike_version = 2
  target_vpn_gateway = google_compute_vpn_gateway.asia_tgw.id

  depends_on = [ 
    google_compute_forwarding_rule.asia_fr_esp_b,
    google_compute_forwarding_rule.asia_fr_udp500_b,
    google_compute_forwarding_rule.asia_fr_udp4500_b
  ]
}