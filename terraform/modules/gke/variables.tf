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
}

variable "vpc_self_link" {
  description = "The self link of the VPC"
  type        = string
}

variable "subnet_self_link" {
  description = "The self link of the subnet"
  type        = string
}

variable "service_account_email" {
  description = "The email of the service account to use for the GKE cluster"
  type        = string
}
