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

data "google_secret_manager_secret_version" "vpn_secret" { 
  secret = "my-secret"
  version = "latest"
}

output "vpc" {
  value = google_compute_network.game_server_vpc.name
}
output "internal_ip" {
  value = google_compute_instance.asia_ne_instance.network_interface[0].network_ip
}

output "public_ip" {
  value = google_compute_instance.asia_ne_instance.network_interface[0].access_config[0].nat_ip
}

output "vm_subnet" {
  value = google_compute_subnetwork.game_client_asia_ne1_subnet.ip_cidr_range
}

output "website_url" {
  value = "https://storage.googleapis.com/${google_storage_bucket.bucket.name}/index.html"
}