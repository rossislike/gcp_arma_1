resource "google_compute_network_peering" "info_to_client_peer" {
  name         = "info-to-client-peer"
  network      = google_compute_network.game_server_vpc.self_link
  peer_network = google_compute_network.game_client_vpc.self_link
}

resource "google_compute_network_peering" "client_to_info_peer" {
  name         = "client-to-info-peer"
  network      = google_compute_network.game_client_vpc.self_link
  peer_network = google_compute_network.game_server_vpc.self_link
}