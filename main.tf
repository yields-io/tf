terraform {
  required_version = ">= 0.12.0, < 0.14"
}
provider "google" {
  project = var.project_id
  region  = var.region
}
module "gke" {
  source                     = "terraform-google-modules/kubernetes-engine/google"
  project_id                 = var.project_id
  name                       = var.name
  region                     = var.region
  zones                      = var.zones
  network                    = google_compute_network.vpc.name
  subnetwork                 = google_compute_subnetwork.nodes.name
  ip_range_pods              = "${var.project_id}-pods"
  ip_range_services          = "${var.project_id}-services"
  http_load_balancing        = false
  horizontal_pod_autoscaling = true
  network_policy             = true
  node_pools = [
    {
      name               = "default"
      machine_type       = "n1-standard-4"
      min_count          = 1
      max_count          = 3
      local_ssd_count    = 0
      disk_size_gb       = 100
      disk_type          = "pd-standard"
      image_type         = "COS"
      auto_repair        = true
      auto_upgrade       = true
      service_account    = "devops@${var.project_id}.iam.gserviceaccount.com"
      preemptible        = false
      initial_node_count = 3
    },
    {
      name               = "spark"
      machine_type       = "c2-standard-8"
      min_count          = 1
      max_count          = 3
      local_ssd_count    = 0
      disk_size_gb       = 100
      disk_type          = "pd-standard"
      image_type         = "COS"
      auto_repair        = true
      auto_upgrade       = true
      service_account    = "devops@${var.project_id}.iam.gserviceaccount.com"
      preemptible        = false
      initial_node_count = 2
    }
  ]
  node_pools_oauth_scopes = {
    all = [
      "https://www.googleapis.com/auth/cloud-platform",
    ]
  }
  node_pools_labels = {
    all = {}
    default = {
      default = true
    }
    spark = {
      spark = true
    }
  }
  node_pools_tags = {
    all = []
    default = [
      "default",
    ]
  }
}
