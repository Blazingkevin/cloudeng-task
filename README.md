
# Shortlet Current Time API

## Project Structure

```bash
├.
├── go.mod                  # Go module definition
├── main.go                 # Go file for Current Time API
├── Dockerfile              # Dockerfile for building the API container
├── .gitignore              # Gitignore file to exclude files from version control
├── README.md               # Project documentation
├── terraform/              # Terraform configurations for GKE, IAM, and Network setup
│   ├── modules/
│   │   ├── gke/            # GKE module for Kubernetes cluster
│   │   │   ├── main.tf
│   │   │   ├── variables.tf
│   │   │   ├── outputs.tf
│   │   ├── iam/            # IAM module for service account and permissions
│   │   │   ├── main.tf
│   │   │   ├── variables.tf
│   │   │   ├── outputs.tf
│   │   ├── network/        # Network module for VPC, subnets, and firewalls
│   │   │   ├── main.tf
│   │   │   ├── variables.tf
│   │   │   ├── outputs.tf
│   ├── main.tf             # Main Terraform file to orchestrate the entire setup
│   ├── variables.tf        # Variables for the Terraform setup
│   ├── outputs.tf          # Outputs for the Terraform setup
└── .github/                # GitHub Actions workflows for CI/CD pipeline
    └── workflows/
        └── ci-cd.yml       # GitHub Actions configuration for CI/CD

```

## Step-by-Step Setup

### 1. Google Cloud Setup

1. **Create a Google Cloud Project** if you don't have one already.
   
   ```bash
   gcloud projects create my-project-id
   ```

2. **Enable necessary APIs**(From the GCP console or command line as shown below ):
   
   ```bash
   gcloud services enable container.googleapis.com \
       artifactregistry.googleapis.com \
       iam.googleapis.com
   ```

3. **Create a service account** and assign the necessary roles(From the GCP IAM console or command line as shown below):

   ```bash
   gcloud iam service-accounts create k8s-service-account --display-name="Kubernetes Service Account"
   ```

4. **Assign roles to the service account** (From the GCP IAM console or command line as shown below):

   ```bash
   gcloud projects add-iam-policy-binding $PROJECT_ID \
       --member="serviceAccount:k8s-service-account@${PROJECT_ID}.iam.gserviceaccount.com" \
       --role="roles/container.admin"
   gcloud projects add-iam-policy-binding $PROJECT_ID \
       --member="serviceAccount:k8s-service-account@${PROJECT_ID}.iam.gserviceaccount.com" \
       --role="roles/artifactregistry.reader"
   ```

### 2. Artifact Registry

1. **Create an Artifact Registry repository**:

   ```bash
   gcloud artifacts repositories create my-repo \
       --repository-format=docker \
       --location=$REGION
   ```

### 3. Terraform Setup

1. **Initialize Terraform**:

   Navigate to the `terraform/` directory and initialize Terraform.

   ```bash
   terraform init
   ```

2. **Apply Terraform Configuration**:

   Apply the infrastructure setup by running the command below. Make sure to replace values of variables such as `project_id`:

   ```bash
   terraform apply -var="project_id=<your_project_id>" -auto-approve
   ```

   This command will create the GKE cluster, set up networking, IAM policies, and deploy the current time API.

### 4. Docker Image Build and Push

1. **Build Docker Image**:

   Build the Docker image locally:

   ```bash
   docker build -t us-central1-docker.pkg.dev/<your_project_id>/my-repo/gke-terraform-api:v1.0.0 .
   ```

2. **Push Docker Image** to Google Artifact Registry:

   ```bash
   docker push us-central1-docker.pkg.dev/<your_project_id>/my-repo/gke-terraform-api:v1.0.0
   ```

### 5. GitHub Actions CI/CD

1. **Set up GitHub Secrets** for your project:

   - `GCP_SA_KEY`: Your Google Cloud service account JSON key.
   - `GCP_PROJECT_ID`: Your Google Cloud project ID.
   - `GCP_REGION`: Your selected region (e.g., `us-central1`).
   - `GKE_CLUSTER_NAME`: Your GKE cluster name.

2. **Trigger GitHub Actions** by pushing changes to the `main` branch.

   The pipeline will:

   - Set up Google Cloud SDK.
   - Authenticate using the service account.
   - Build and push the Docker image.
   - Apply Terraform configuration.
   - Test the API endpoint.

### 6. Testing the API

Once the infrastructure is deployed and the API is running, you can test the API using `curl`.

1. **Get the external IP** of the API:

   ```bash
   terraform output -raw kubernetes_endpoint
   ```

2. **Test the API**:

   ```bash
   curl http://<EXTERNAL_IP>/time
   ```

   You should receive a JSON response with the current time.

## Configuration

### Variables

- `project_id`: The Google Cloud project ID.
- `region`: The region where your resources are deployed.
- `cluster_name`: The name of the GKE cluster.
- `vpc_name`: The name of the VPC used for networking.
- `kube_config_path`: The path to the Kubernetes config file (default: `~/.kube/config`).

### Outputs

The project provides several outputs:

- **Kubernetes Endpoint**: The external IP of the API load balancer.
- **Cluster Endpoint**: The endpoint of the GKE cluster.
- **Service Account Email**: The email of the Kubernetes service account.

## Local Testing

To test locally before deploying:

1. **Run the API locally**:

   If you want to test the API locally without GKE, run the Docker container:

   ```bash
   docker run -p 8080:8080 gke-terraform-api:v1.0.0
   ```

   Then, visit `http://localhost:8080/time` to get the current time.

## Cleanup

To clean up resources after testing, you can destroy the infrastructure using Terraform:

```bash
terraform destroy -var="project_id=<your_project_id>" -auto-approve
```

This will delete the GKE cluster, networking resources, IAM bindings, and other associated resources.