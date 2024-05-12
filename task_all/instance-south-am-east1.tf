resource "google_compute_instance" "south_am_east1_instance" {
  boot_disk {
    auto_delete = true
    device_name = "south-am-east1-instance"

    initialize_params {
      image = "projects/debian-cloud/global/images/debian-12-bookworm-v20240415"
      size  = 10
      type  = "pd-balanced"
    }

    mode = "READ_WRITE"
  }

  can_ip_forward      = false
  deletion_protection = false
  enable_display      = false

  labels = {
    goog-ec-src = "vm_add-tf"
  }

  machine_type = "e2-micro"
  name         = "south-am-east1-instance"

  network_interface {

    queue_count = 0
    stack_type  = "IPV4_ONLY"
    subnetwork  = google_compute_subnetwork.game_client_south_am_east1_subnet.name
  }

  scheduling {
    automatic_restart   = true
    on_host_maintenance = "MIGRATE"
    preemptible         = false
    provisioning_model  = "STANDARD"
  }

  service_account {
    email  = "715004262141-compute@developer.gserviceaccount.com"
    scopes = ["https://www.googleapis.com/auth/devstorage.read_only", "https://www.googleapis.com/auth/logging.write", "https://www.googleapis.com/auth/monitoring.write", "https://www.googleapis.com/auth/service.management.readonly", "https://www.googleapis.com/auth/servicecontrol", "https://www.googleapis.com/auth/trace.append"]
  }

  shielded_instance_config {
    enable_integrity_monitoring = true
    enable_secure_boot          = false
    enable_vtpm                 = true
  }

  zone = "southamerica-east1-b"
}
