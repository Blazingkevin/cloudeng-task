output "kubernetes_endpoint" {
  description = "The external IP of the API load balancer"
  value       = kubernetes_service.api_service.status[0].load_balancer[0].ingress[0].ip
}

output "cluster_endpoint" {
  description = "The endpoint of the GKE cluster"
  value       = google_container_cluster.primary.endpoint
}

output "cluster_ca_certificate" {
  description = "The base64-encoded public certificate for the cluster"
  value       = google_container_cluster.primary.master_auth[0].cluster_ca_certificate
}
