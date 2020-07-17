provider "google" {
  version = "3.5.0"

  credentials = file("C:/Users/ka20089488/Documents/DEV/gcloud/gcdeveloper-admin.json")

  project = var.project
  region  = var.region
  zone    = "us-central1-c"
}

resource "google_compute_instance" "vm_instance" {

  depends_on = [google_storage_bucket.example_bucket]  

  name         = "terraform-instance"
  machine_type = "f1-micro"
  tags = ["web","dev","prod"]

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"
    }
  }

  network_interface {
    network = "k8snet"
    subnetwork = "subnet10--2"
    access_config {
        nat_ip = google_compute_address.vm_static_ip.address
    }
  }
}

resource "google_compute_address" "vm_static_ip" {
  name = "terraform-static-ip"
}

resource "google_storage_bucket" "example_bucket" {
  name     = "k8sworld_com"
  location = "US"

  website {
    main_page_suffix = "index.html"
    not_found_page   = "404.html"
  }
}
