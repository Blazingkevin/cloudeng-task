variable "project_id" {
  description = "The project ID to deploy to"
  type        = string
}

variable "region" {
  description = "The region to deploy to"
  type        = string
  default     = "us-central1"
}

variable "cluster_name" {
  description = "The name of the GKE cluster"
  type        = string
  default     = "gke-cluster2"
}

variable "vpc_name" {
  description = "The name of the VPC"
  type        = string
  default     = "gke-vpc2"
}
