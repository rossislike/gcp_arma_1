# resource "google_compute_network_peering" "peering1" {
#   name         = "peering1"
#   network      = google_compute_network.vpc_a.self_link
#   peer_network = google_compute_network.vpc_b.self_link
# }

# resource "google_compute_network_peering" "peering2" {
#   name         = "peering2"
#   network      = google_compute_network.vpc_b.self_link
#   peer_network = google_compute_network.vpc_a.self_link
#   provider = google.gcp-service-project
# }

# resource "google_compute_network" "default" {
#   name                    = "foobar"
#   auto_create_subnetworks = "false"
# }

# resource "google_compute_network" "other" {
#   name                    = "other"
#   auto_create_subnetworks = "false"
# }