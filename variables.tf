variable "project_id" {
  type = string
  description = "Google Cloud Project ID"
}
variable "name" {
  type = string
  description = "Google Kubernetes Engine Cluster Name"
}
variable "region" {
  type = string
  description = "Google Kubernetes Engine Region"
  default = "europe-west1"
}
variable "zones" {
  type = list
  description = "Google Kubernetes Engine Zones"
}
variable "parent_domain" {
  type = string
  description = "Google Cloud DNS Parent Domain"
}
variable "primary_ip_cidr_range" {
  type = string
  description = "Google VPC Primary Subnet IP CIDR Range (Nodes)"
  default = "10.10.0.0/22"
}
variable "secondary_pods_ip_cidr_range" {
  type = string
  description = "Google VPC Secondary Subnet IP CIDR Range (Pods)"
  default = "10.1.0.0/16"
}
variable "secondary_services_ip_cidr_range" {
  type = string
  description = "Google VPC Secondary Subnet IP CIDR Range (Services)"
  default = "10.2.0.0/20"
}
