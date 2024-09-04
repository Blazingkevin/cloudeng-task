output "vpc_self_link" {
  description = "The self link of the VPC"
  value       = google_compute_network.vpc_network.self_link
}

output "subnet_self_link" {
  description = "The self link of the subnet"
  value       = google_compute_subnetwork.subnetwork.self_link
}
