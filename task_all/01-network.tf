resource "google_compute_network" "game_server_vpc" {
  name = "game-server-vpc"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "eu_subnet" {
  name ="eu-central2-subnet"
  network = google_compute_network.game_server_vpc.id
  ip_cidr_range = "10.151.1.0/24"
  region = "europe-central2"
}

resource "google_compute_firewall" "game_server_vpc_custom_rule" {
  network = google_compute_network.game_server_vpc.name
  name    = "game-server-vpc-custom"
  priority = 65534

  source_ranges = ["10.151.1.0/24"]

  allow {
    protocol = "all"
  }
}

resource "google_compute_firewall" "game_server_vpc_ssh_rule" {
  network = google_compute_network.game_server_vpc.name
  name    = "game-server-vpc-ssh"
  priority = 65534

  source_ranges = ["0.0.0.0/0"]

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
}

resource "google_compute_firewall" "game_server_vpc_icmp_rule" {
  name    = "game-server-vpc-icmp"
  network = google_compute_network.game_server_vpc.name

  allow {
    protocol = "icmp"
  }

  source_ranges = ["0.0.0.0/0"]
  priority = 65534
}

resource "google_compute_firewall" "game_server_vpc_http_rule" {
  name    = "game-server-vpc-http"
  network = google_compute_network.game_server_vpc.name

  allow {
    protocol = "tcp"
    ports = ["80"]
  }

  source_ranges = ["172.16.1.0/24", "172.17.1.0/24", "192.168.1.0/24"]
  priority = 65534
}

resource "google_compute_network" "game_client_vpc" {
  name = "game-client-vpc"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "game_client_us_cent1_subnet" {
  name ="us-cent1-subnet"
  network = google_compute_network.game_client_vpc.id
  ip_cidr_range = "172.16.1.0/24"
  region = "us-central1"
}

resource "google_compute_subnetwork" "game_client_south_am_east1_subnet" {
  name ="south-am-east1-subnet"
  network = google_compute_network.game_client_vpc.id
  ip_cidr_range = "172.17.1.0/24"
  region = "southamerica-east1"
}

resource "google_compute_subnetwork" "game_client_asia_ne1_subnet" {
  name ="asia-ne1-subnet"
  network = google_compute_network.game_client_vpc.id
  ip_cidr_range = "192.168.1.0/24"
  region = "asia-northeast1"
}

resource "google_compute_firewall" "game_client_vpc_custom_rule" {
  network = google_compute_network.game_client_vpc.name
  name    = "game-client-vpc-custom"
  priority = 65534
  source_ranges = ["172.16.1.0/24", "172.17.1.0/24", "192.168.1.0/24"]

  allow {
    protocol = "all"
  }
}

resource "google_compute_firewall" "game_client_vpc_ssh_rule" {
  network = google_compute_network.game_client_vpc.name
  name    = "game-client-vpc-ssh"
  priority = 65534
  source_ranges = ["0.0.0.0/0"]

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
}

resource "google_compute_firewall" "game_client_vpc_icmp_rule" {
  name    = "game-client-vpc-icmp"
  network = google_compute_network.game_client_vpc.name
  allow {
    protocol = "icmp"
  }

  source_ranges = ["0.0.0.0/0"]
  priority = 65534
}

resource "google_compute_firewall" "game_client_vpc_rdp_rule" {
  name    = "game-client-vpc-rdp"
  network = google_compute_network.game_client_vpc.name
  allow {
    protocol = "tcp"
    ports = ["3389"]
  }

  source_ranges = ["0.0.0.0/0"]
  priority = 65534
}