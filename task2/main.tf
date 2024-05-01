terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "5.25.0"
    }
  }
}

provider "google" {
  # Configuration options
  region = "us-central1"
  project = "my-second-project-416401"
  credentials = "${path.module}../my-second-project-416401-f024ec5b7771.json"
}


# resource "google_storage_bucket" "bucket1" {
#   name          = "copy_this_and_chewbacca_will_raw_wookie_you_no_diddy"
#   location      = "us-central1"
#   force_destroy = true

# }


resource "google_compute_network" "auto-vpc-tf" {
  name = "myvpc"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "sub-sg" {
  name ="sub-sg"
  network = google_compute_network.auto-vpc-tf.id
  ip_cidr_range = "10.151.1.0/24"
  region = "us-central1"
}


#resource "google_compute_network" "custom-vpc-tf" {
  #name = "custom-vpc-tf"
 #auto_create_subnetworks = false
#}

output "auto" {
  value = google_compute_network.auto-vpc-tf.id
}

#output "custom" {
#  value = google_compute_network.custom-vpc-tf.id
#}