output "iam_policy_status" {
  description = "Status of IAM policy enforcement"
  value       = "Policies applied"
}


output "k8s_service_account_email" {
  description = "The email of the Kubernetes service account"
  value       = google_service_account.k8s_sa.email
}
