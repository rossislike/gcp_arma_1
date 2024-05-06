terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "5.25.0"
    }
  }
}

provider "google" {
  region = "us-central1"
  project = "my-second-project-416401"
  credentials = "${path.module}/../my-second-project-416401-f024ec5b7771.json"
}

resource "google_compute_network" "vpc_a" {
  name = var.vpc_a["name"]
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "subnet_a1" {
  name ="subnet10"
  network = google_compute_network.vpc_a.id
  ip_cidr_range = var.vpc_a["cidr"]
  region = "europe-central2"
}

resource "google_compute_firewall" "vpc_a_custom_rule" {
  network = google_compute_network.vpc_a.name
  name    = "${var.vpc_a["name"]}-custom"
  priority = 65534

  source_ranges = [var.vpc_a["cidr"]]

  allow {
    protocol = "all"
  }
}

resource "google_compute_firewall" "vpc_a_ssh_rule" {
  network = google_compute_network.vpc_a.name
  name    = "${var.vpc_a["name"]}-ssh"
  priority = 65534

  source_ranges = ["0.0.0.0/0"]

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
}

resource "google_compute_firewall" "vpc_a_icmp_rule" {
  name    = "${var.vpc_a["name"]}-icmp"
  network = google_compute_network.vpc_a.name

  allow {
    protocol = "icmp"
  }

  source_ranges = ["0.0.0.0/0"]
  priority = 65534
}

resource "google_compute_firewall" "vpc_a_http_rule" {
  name    = "${var.vpc_a["name"]}-http"
  network = google_compute_network.vpc_a.name

  allow {
    protocol = "tcp"
    ports = ["80"]
  }

  source_ranges = [var.vpc_b["cidr1"], var.vpc_b["cidr2"], var.vpc_b["cidr3"]]
  priority = 65534
}

resource "google_compute_network" "vpc_b" {
  name = var.vpc_b["name"]
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "subnet_b1" {
  name ="subnet172a"
  network = google_compute_network.vpc_b.id
  ip_cidr_range = var.vpc_b["cidr1"]
  region = "us-central1"
}

resource "google_compute_subnetwork" "subnet_b2" {
  name ="subnet172b"
  network = google_compute_network.vpc_b.id
  ip_cidr_range = var.vpc_b["cidr2"]
  region = "southamerica-east1"
}

resource "google_compute_subnetwork" "subnet_b3" {
  name ="subnet192"
  network = google_compute_network.vpc_b.id
  ip_cidr_range = var.vpc_b["cidr3"]
  region = "asia-northeast1"
}

resource "google_compute_firewall" "vpc_b_custom_rule" {
  network = google_compute_network.vpc_b.name
  name    = "${var.vpc_b["name"]}-custom"
  priority = 65534

  source_ranges = [var.vpc_b["cidr1"], var.vpc_b["cidr2"], var.vpc_b["cidr3"]]

  allow {
    protocol = "all"
  }
}

resource "google_compute_firewall" "vpc_b_ssh_rule" {
  network = google_compute_network.vpc_b.name
  name    = "${var.vpc_b["name"]}-ssh"
  priority = 65534

  source_ranges = ["0.0.0.0/0"]

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
}

resource "google_compute_firewall" "vpc_b_icmp_rule" {
  name    = "${var.vpc_b["name"]}-icmp"
  network = google_compute_network.vpc_b.name

  allow {
    protocol = "icmp"
  }

  source_ranges = ["0.0.0.0/0"]
  priority = 65534
}

resource "google_compute_firewall" "vpc_b_rdp_rule" {
  name    = "${var.vpc_b["name"]}-rdp"
  network = google_compute_network.vpc_b.name

  allow {
    protocol = "tcp"
    ports = ["3389"]
  }

  source_ranges = ["0.0.0.0/0"]
  priority = 65534
}




# output "auto" {
#   value = google_compute_network.my_compute_network.id
# }

# output "auto" {
#   # value = google_compute_network.gvpc.id
#   value = "http://${google_compute_instance.my_instance.network_interface[0].access_config[0].nat_ip}"
# }


#output "custom" {
#  value = google_compute_network.custom-vpc-tf.id
#}