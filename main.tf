terraform {
  required_version = ">= 0.12.0, < 0.14"
}
provider "google" {
  project = var.project_id
  region  = var.region
}
resource "google_container_cluster" "primary" {
  name     = var.name
  location = var.region
  remove_default_node_pool = true
  initial_node_count       = 1
  master_auth {
    username = ""
    password = ""
    client_certificate_config {
      issue_client_certificate = false
    }
  }
}
resource "google_container_node_pool" "default" {
  name       = "default"
  location   = var.region
  cluster    = google_container_cluster.primary.name
  initial_node_count = 1
  node_config {
    preemptible  = true
    machine_type = "n1-standard-4"
    metadata = {
      disable-legacy-endpoints = "true"
    }
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }
}
resource "google_container_node_pool" "spark" {
  name       = "spark"
  location   = var.region
  cluster    = google_container_cluster.primary.name
  initial_node_count = 1
  autoscaling {
    min_node_count = 1
    max_node_count = 3
  }
  node_config {
    preemptible  = true
    machine_type = "c2-standard-8"
    metadata = {
      disable-legacy-endpoints = "true"
    }
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }
}
