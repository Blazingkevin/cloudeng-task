# Main Terraform file to orchestrate infrastructure creation

provider "google" {
  # credentials = file("./sa.json")
  project     = var.project_id
  region      = var.region
}

provider "kubernetes" {
  config_path = "~/.kube/config"
}

module "network" {
  source     = "./modules/network"
  project_id = var.project_id
  region     = var.region
  vpc_name   = var.vpc_name
}

module "iam" {
  source     = "./modules/iam"
  project_id = var.project_id
}

module "gke" {
  source                = "./modules/gke"
  project_id            = var.project_id
  region                = var.region
  cluster_name          = var.cluster_name
  vpc_self_link         = module.network.vpc_self_link
  subnet_self_link      = module.network.subnet_self_link
  service_account_email = module.iam.k8s_service_account_email
}

output "k8s_service_account_email" {
  value = module.iam.k8s_service_account_email
}
