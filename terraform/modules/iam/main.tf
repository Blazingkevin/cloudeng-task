resource "google_service_account" "k8s_sa" {
  account_id   = "k8s-service-account2"
  display_name = "Kubernetes Service Account"

  provisioner "local-exec" {
    command = "echo 'Waiting for GKE cluster to be ready...' && sleep 120"
  }
}

resource "google_project_iam_binding" "gke_cluster_role" {
  project = var.project_id
  role    = "roles/container.clusterAdmin"

  members = [
    "serviceAccount:${google_service_account.k8s_sa.email}"
  ]

  provisioner "local-exec" {
    command = "echo 'Waiting for GKE cluster to be ready...' && sleep 120"
  }
}

resource "google_project_iam_binding" "gke_kubernetes_admin" {
  project = var.project_id
  role    = "roles/container.admin"

  members = [
    "serviceAccount:${google_service_account.k8s_sa.email}"
  ]

  provisioner "local-exec" {
    command = "echo 'Waiting for GKE cluster to be ready...' && sleep 120"
  }
}

resource "google_project_iam_binding" "gke_node_storage_access" {
  project = var.project_id
  role    = "roles/artifactregistry.reader"

  members = [
    "serviceAccount:${google_service_account.k8s_sa.email}"
  ]

  provisioner "local-exec" {
    command = "echo 'Waiting for GKE cluster to be ready...' && sleep 120"
  }
}

# resource "google_project_iam_binding" "deny_overprivileged_roles" {
#   project = var.project_id
#   role    = "roles/owner"

#   members = [
#     "serviceAccount:${google_service_account.k8s_sa.email}"
#   ]
# }
