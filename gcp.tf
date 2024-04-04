## VPC
## -------------------------
resource "google_compute_network" "vpc-network" {
  project                 = "inft-1209-lab5"
  name                    = "cheng-network"
  auto_create_subnetworks = "false"
  routing_mode            = "REGIONAL"
}

resource "google_compute_subnetwork" "public-subnet" {
  project                 = "inft-1209-lab5"
  name                    = "cheng-pub-subnet"
  ip_cidr_range           = var.gcp_public_subnet_cidr
  network                 = google_compute_network.vpc-network.id
  region                  = "us-central1"
}

resource "google_compute_subnetwork" "private-subnet" {
  project                 = "inft-1209-lab5"
  name                    = "cheng-pri-subnet"
  ip_cidr_range           = var.gcp_private_subnet_cidr
  network                 = google_compute_network.vpc-network.id
  region                  = "us-central1"
}

## Firewall Rule
## -------------------------
resource "google_compute_firewall" "allow-icmp" {
  name                    = "lab5-allow-http"
  network                 = google_compute_network.vpc-network.name
  allow {
    protocol              = "icmp"
  }
  priority                = 65534
  description             = "Allow ICMP."
  source_ranges           = ["0.0.0.0/0"]
}

resource "google_compute_firewall" "allow-http" {
  name                    = "lab5-allow-http"
  network                 = google_compute_network.vpc-network.name
  allow {
    protocol              = "tcp"
    ports                 = ["80"]
  }
  priority              = 100
  description           = "Allow HTTP Port 8080 traffic for web servers."
  source_ranges         = ["0.0.0.0/0"]
}

resource "google_compute_firewall" "allow-ssh" {
  name                    = "lab5-allow-ssh"
  network                 = google_compute_network.vpc-network.name
  allow {
    protocol              = "tcp"
    ports                 = ["22"]
  }
  priority              = 110
  description           = "Allow SSH access from trusted IP addresses."
  source_ranges         = ["0.0.0.0/0"] #Should change to my IP only.
}

resource "google_compute_firewall" "allow-internal" {
  name                    = "allow-internal"
  network                 = google_compute_network.vpc-network.name
  allow {
    protocol = "icmp"
  }
  allow {
    protocol = "tcp"
    ports    = ["0-65535"]
  }
  allow {
    protocol = "udp"
    ports    = ["0-65535"]
  }
  source_ranges = [
    google_compute_subnetwork.public-subnet.ip_cidr_range,
    google_compute_subnetwork.private-subnet.ip_cidr_range
  ]
}

## Container Compute VM
## -------------------------
resource "google_compute_instance" "vm-container" {
  name                    = "vm-container"
  machine_type            = "e2-micro"
  zone                    = "us-central1-a"

  boot_disk {
    initialize_params {
      image               = "debian-12-bookworm-v20240312"
    }
  }

  network_interface {
    network               = google_compute_network.vpc-network.name
    subnetwork            = google_compute_subnetwork.public-subnet.name
    access_config {
      // Ephemeral public IP
    }
  }
}