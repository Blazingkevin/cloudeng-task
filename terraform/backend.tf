terraform {
  backend "gcs" {
    bucket = "kevin-terraform-state-bucket2"
    prefix = "gke-terraform-api2"
  }
}
