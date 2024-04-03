## VPC
## -------------------------
resource "google_compute_network" "vpc-network" {
  project                 = "assignment2-418411"
  name                    = "cheng-network"
  auto_create_subnetworks = "false"
  # routing_mode            = "REGIONAL"
}

resource "google_compute_subnetwork" "public-subnet" {
  project                 = "assignment2-418411"
  name                    = "cheng-pub-subnet"
  ip_cidr_range           = "10.0.10.0/24"
  network                 = google_compute_network.vpc-network.id
  region                  = "us-central1"
}

resource "google_compute_subnetwork" "private-subnet" {
  project                 = "assignment2-418411"
  name                    = "cheng-pri-subnet"
  ip_cidr_range           = "10.0.20.0/24"
  network                 = google_compute_network.vpc-network.id
  region                  = "us-central1"
}

## Firewall Rule
## -------------------------
resource "google_compute_firewall" "container-allow-icmp" {
  name                    = "container-allow-http"
  network                 = google_compute_network.vpc-network.name
  allow {
    protocol              = "icmp"
  }
  priority                = 65534
  description             = "Allow ICMP."
  source_ranges           = ["0.0.0.0/0"]
}

resource "google_compute_firewall" "container-allow-port8080" {
  name                    = "container-allow-http"
  network                 = google_compute_network.vpc-network.name
  allow {
    protocol              = "tcp"
    ports                 = ["80"]
  }
  priority              = 110
  description           = "Allow HTTP Port 8080 traffic for web servers."
  source_ranges         = ["0.0.0.0/0"]
}

resource "google_compute_firewall" "container-allow-ssh" {
  name                    = "container-allow-ssh"
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
      image               = "cos-cloud/cos-101-17162-386-57"
    }
  }

  ## Start Image is not required for the lab, but there is always some error in the CI/CD process without metadata.
  metadata = {
    gce-container-declaration = <<EOT
    spec:
      containers:
      - name: flaskapp-container
        image: 'us-central1-docker.pkg.dev/assignment2-418411/cheng-repo/flaskapp@sha256:bee94644cf39a29d506be2779d50509573b7ad2074626fbed79907a5fa74093b'
        stdin: false
        tty: false
      restartPolicy: Always
    EOT
  }

  network_interface {
    network               = google_compute_network.vpc-network.name
    subnetwork            = google_compute_subnetwork.public-subnet.name
    access_config {
      // Ephemeral public IP
    }
  }

  service_account {
    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    email                 = "764950655405-compute@developer.gserviceaccount.com"
    scopes = [
      "https://www.googleapis.com/auth/cloud-platform",
      "https://www.googleapis.com/auth/cloud-platform.read-only"
  ]
  }
}

## Project IAM Binding
## -------------------------
resource "google_project_iam_binding" "instance_editor_binding" {
  project                 = "assignment2-418411"
  role                    = "roles/editor"

  members = [
    "serviceAccount:764950655405-compute@developer.gserviceaccount.com",
  ]
}