resource "google_compute_network" "vpc" {
  name                    = "${var.project_id}-vpc"
  auto_create_subnetworks = "false"
}
resource "google_compute_subnetwork" "nodes" {
  name          = "${var.project_id}-nodes"
  region        = var.region
  network       = google_compute_network.vpc.name
  ip_cidr_range = var.primary_ip_cidr_range
  secondary_ip_range = [
    {
      range_name = "${var.project_id}-pods"
      ip_cidr_range = var.secondary_pods_ip_cidr_range
    },
    {
      range_name = "${var.project_id}-services"
      ip_cidr_range = var.secondary_services_ip_cidr_range
    }
  ]
}
output "region" {
  value       = var.region
  description = "region"
}
