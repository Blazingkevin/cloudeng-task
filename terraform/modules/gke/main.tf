resource "google_container_cluster" "primary" {
  name     = var.cluster_name
  location = var.region

  networking_mode          = "VPC_NATIVE"
  remove_default_node_pool = true

  ip_allocation_policy {}
  network    = var.vpc_self_link
  subnetwork = var.subnet_self_link

  initial_node_count = 1

  node_config {
    service_account = var.service_account_email
  }

  provisioner "local-exec" {
    command = "echo 'Waiting for GKE cluster to be ready...' && sleep 120"
  }
}

resource "google_container_node_pool" "primary_nodes" {
  name     = "${var.cluster_name}-node-pool"
  cluster  = google_container_cluster.primary.name
  location = google_container_cluster.primary.location

  autoscaling {
    min_node_count = 1
    max_node_count = 3
  }

  node_config {
    machine_type = "e2-micro"
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform",
      "https://www.googleapis.com/auth/devstorage.read_only"
    ]
    service_account = var.service_account_email
  }

  provisioner "local-exec" {
    command = "echo 'Waiting for GKE cluster to be ready...' && sleep 120"
  }
}

resource "kubernetes_namespace" "default" {
  metadata {
    name = "default3"
  }

  depends_on = [
    google_container_node_pool.primary_nodes,
    google_container_cluster.primary
  ]

  provisioner "local-exec" {
    command = "echo 'Waiting for GKE cluster to be ready...' && sleep 120"
  }
}

resource "kubernetes_deployment" "api" {
  metadata {
    name      = "gke-terraform-api2"
    namespace = kubernetes_namespace.default.metadata[0].name
    # namespace = "default"
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "gke-terraform-api2"
      }
    }

    template {
      metadata {
        labels = {
          app = "gke-terraform-api2"
        }
      }

      spec {
        container {
          name = "gke-terraform-api2"
          # image = "gcr.io/${var.project_id}/gke-terraform-api:v1.0.0"
          image = "us-central1-docker.pkg.dev/${var.project_id}/my-repo/gke-terraform-api:v1.0.0"
          port {
            container_port = 8080
          }
        }
      }
    }
  }

  provisioner "local-exec" {
    command = "echo 'Waiting for GKE cluster to be ready...' && sleep 120"
  }
}

resource "kubernetes_service" "api_service" {
  metadata {
    name      = "gke-terraform-api2-service"
    namespace = kubernetes_namespace.default.metadata[0].name
    # namespace = "default"
  }

  spec {
    selector = {
      app = "gke-terraform-api2"
    }

    port {
      port        = 80
      target_port = 8080
    }

    type = "LoadBalancer"
  }

  provisioner "local-exec" {
    command = "echo 'Waiting for GKE cluster to be ready...' && sleep 120"
  }
}

resource "kubernetes_ingress_v1" "api_ingress" {
  metadata {
    name      = "gke-terraform-api2-ingress"
    namespace = kubernetes_namespace.default.metadata[0].name
    # namespace = "default"
  }

  spec {
    default_backend {
      service {
        name = kubernetes_service.api_service.metadata[0].name
        port {
          number = 80
        }
      }
    }

    rule {
      http {
        path {
          path = "/"
          backend {
            service {
              name = kubernetes_service.api_service.metadata[0].name
              port {
                number = 80
              }
            }
          }
        }
      }
    }

    tls {
      secret_name = "tls-secret"
    }
  }

  provisioner "local-exec" {
    command = "echo 'Waiting for GKE cluster to be ready...' && sleep 120"
  }
}

