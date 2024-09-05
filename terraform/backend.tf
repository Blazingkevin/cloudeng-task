terraform {
  backend "gcs" {
    bucket = "kevin-terraform-state-bucket3"
    prefix = "gke-terraform-api3"
  }
}
