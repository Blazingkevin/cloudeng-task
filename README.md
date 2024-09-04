# Shortlet Current Time API

This project demonstrates the setup and deployment of a simple API on Google Kubernetes Engine (GKE) using Terraform and GitHub Actions. The API serves the current time and is packaged into a Docker image, deployed to Google Cloud Artifact Registry, and then orchestrated through GKE.

## Prerequisites

Before you can run and test this setup locally, ensure you have the following installed:

- **Google Cloud SDK** with `gke-gcloud-auth-plugin` installed
- **Docker** (for building images)
- **Terraform** version 1.9.5 (or compatible)
- **Kubectl** for interacting with the Kubernetes cluster
- **GitHub CLI** (for actions and workflows)
- A **Google Cloud Project** with GKE and Artifact Registry enabled

## Project Structure

```bash
.
├── modules/# Shortlet Current Time API

This project demonstrates the setup and deployment of a simple API on Google Kubernetes Engine (GKE) using Terraform and GitHub Actions. The API serves the current time and is packaged into a Docker image, deployed to Google Cloud Artifact Registry, and then orchestrated through GKE.

## Prerequisites

Before you can run and test this setup locally, ensure you have the following installed:

- **Google Cloud SDK** with `gke-gcloud-auth-plugin` installed
- **Docker** (for building images)
- **Terraform** version 1.9.5 (or compatible)
- **Kubectl** for interacting with the Kubernetes cluster
- **GitHub CLI** (for actions and workflows)
- A **Google Cloud Project** with GKE and Artifact Registry enabled

## Project Structure

```bash
.
├── modules/
│   ├── gke/
│   ├── iam/
│   └── network/
├── terraform/
│   ├── main.tf
│   ├── variables.tf
│   ├── outputs.tf
└── .github/
    └── workflows/
        └── ci.yml
│   ├── gke/
│   ├── iam/
│   └── network/
├── terraform/
│   ├── main.tf
│   ├── variables.tf
│   ├── outputs.tf
└── .github/
    └── workflows/
        └── ci.yml
```
