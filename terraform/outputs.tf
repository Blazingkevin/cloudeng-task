output "vpc_self_link" {
  description = "The self link of the VPC"
  value       = module.network.vpc_self_link
}

output "subnet_self_link" {
  description = "The self link of the subnet"
  value       = module.network.subnet_self_link
}

output "kubernetes_endpoint" {
  description = "The external IP of the API load balancer"
  value       = module.gke.kubernetes_endpoint
}
