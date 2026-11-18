# CloudDevOpsProject
End-to-end cloud DevOps project using Docker, Terraform, AWS EKS, ECR, GitHub Actions, and ArgoCD.


## Local Development with Docker Compose

### Prerequisites

- Docker Engine
- Docker Compose plugin

### Application Services

| Service | Technology | Internal Port |
|---|---|---|
| Frontend | Node.js / Express | 3000 |
| Auth Service | Python / Flask | 5000 |
| Roadmap Service | Java / Spring Boot | 8080 |
| Database | MySQL | 3306 |

### Configuration

Copy the environment template:

```bash
cp .env.example .env
```

Set the database passwords and session secret in `.env`.

### Build and Run

```bash
docker compose config --quiet
docker compose up -d --build
```

Open http://localhost:3000 and create an account.

### Check Services

```bash
docker compose ps
docker compose logs --tail=80
```

### Verify Data Persistence

```bash
docker compose down
docker compose up -d
```

Log in using the previously created account.

### Stop the Application

```bash
docker compose down
```

The MySQL named volume is retained.
## Terraform Infrastructure

### Completed

- Configured a dedicated IAM user for local Terraform execution.
- Created an S3 bucket for Terraform state with versioning,
  AES256 encryption, public access blocking, and Terraform
  deletion protection.
- Configured the main infrastructure to use the S3 backend
  with native S3 state locking.
- Implemented and deployed the network module:
  - One VPC with DNS support.
  - Two public and two private subnets across two Availability Zones.
  - An Internet Gateway.
  - One NAT Gateway with an Elastic IP.
  - Public and private route tables and subnet associations.
  - Separate public and private Network ACLs.
- Created three private ECR repositories with immutable image tags
  and AES256 encryption:
  - `ivolve/auth-service`
  - `ivolve/frontend`
  - `ivolve/roadmap-service`
- Implemented and deployed the EKS module:
  - EKS cluster named `ivolve-eks`.
  - Two managed node groups with one worker node each.
  - Worker nodes in separate private subnets in `us-east-1a`
    and `us-east-1b`.
  - Private API endpoint access and public API access restricted
    to the configured administrator CIDR.
  - IAM roles for the cluster and worker nodes.
  - Cluster administrator access for the Terraform IAM user.
- Created the GitHub Actions OIDC provider and IAM role:
  - Trust restricted to the `main` branch of
    `Hager-83/CloudDevOpsProject`.
  - ECR image push permissions restricted to the three
    project repositories.
- Exposed VPC, subnet, ECR repository, and GitHub Actions role outputs.

### Validation

- Terraform initialization and validation completed successfully.
- The latest Terraform plan reported no changes after provisioning.
- All three ECR repository URLs were retrieved successfully.
- Both EKS worker nodes reported `Ready` in different Availability Zones.
- AWS networking, CoreDNS, and kube-proxy pods reported `Running`
  with all containers ready and zero restarts.
- The GitHub Actions IAM role ARN was retrieved successfully.
- End-to-end GitHub OIDC authentication has not been tested yet.

### Local Terraform Usage

Authenticate using the local AWS CLI profile:

```bash
aws login --profile ivolve
export AWS_PROFILE=ivolve
```

Initialize and review the infrastructure:

```bash
terraform -chdir=terraform init
terraform -chdir=terraform validate
terraform -chdir=terraform plan
```

Configure kubectl access:

```bash
aws eks update-kubeconfig \
  --name ivolve-eks \
  --region us-east-1 \
  --profile ivolve \
  --alias ivolve-eks
```

Verify the cluster:

```bash
kubectl --context ivolve-eks get nodes \
  -L topology.kubernetes.io/zone

kubectl --context ivolve-eks get pods -n kube-system
```

### GitHub Actions IAM Role

```text
arn:aws:iam::211017377170:role/ivolve-github-actions-role
```

## Kubernetes Deployment Progress

### Completed

- Created the `ivolve` namespace.
- Installed the EKS Pod Identity Agent and Amazon EBS CSI Driver
  using Terraform.
- Configured a dedicated IAM role for the EBS CSI controller
  using EKS Pod Identity.
- Created the `ivolve-gp3` StorageClass with:
  - Encrypted gp3 volumes.
  - WaitForFirstConsumer volume binding.
  - Volume expansion enabled.
  - Retain reclaim policy.
- Created the application ConfigMap.
- Created the application Secret from the local `.env` file.
  Secret values are excluded from Git.
- Deployed MySQL using a StatefulSet and a Headless Service.
- Provisioned and attached a 10 GiB persistent EBS volume.
- Prepared Deployments and ClusterIP Services for:
  - `auth-service`
  - `roadmap-service`
  - `frontend`
- Configured resource requests, memory limits, and startup,
  readiness, and liveness probes for the application containers.

### Validation

- Pod Identity Agent and EBS CSI components rolled out successfully.
- The MySQL PVC reported `Bound`.
- The MySQL Pod reported `1/1 Running`.
- A database connection test succeeded using the application user.
- The three application Deployments and Services passed
  Kubernetes server-side dry-run validation.

### Current Limitations

- Application images have not been pushed to ECR.
- Application Deployments and Services have been validated
  but have not been applied to the cluster.
- The `initial` image tags are placeholders that CI will replace.
- Database persistence across Pod recreation has not yet been
  verified with a test record.
- Frontend Ingress and its controller are not configured yet.
- GitHub Actions and ArgoCD are not configured yet.
- The application Secret must be created separately when setting
  up a new cluster.

### Recreate the Application Secret

Create the namespace first, then run from the repository root:

```bash
kubectl --context ivolve-eks -n ivolve create secret generic app-secrets \
  --from-env-file=.env \
  --dry-run=client -o yaml \
  | kubectl --context ivolve-eks apply -f -
```

Use unquoted `KEY=value` entries without surrounding whitespace
in the local environment file. Never commit the `.env` file
or generated Secret values.

## Continuous Integration with GitHub Actions

Each microservice has a dedicated workflow that calls a shared
reusable workflow.

Pipeline stages:
1. Build the Docker image.
2. Scan the image with Trivy.
3. Authenticate to AWS using OIDC.
4. Push the image to Amazon ECR.
5. Delete the local image.
6. Update the Kubernetes image reference.
7. Commit and push the manifest update.

HIGH or CRITICAL vulnerability findings block image publishing.

Images use unique tags containing the commit SHA, workflow run ID,
and run attempt to support immutable ECR repositories.

Workflows run on GitHub-hosted runners. Manifest-only changes do
not trigger image builds.

The workflows are configured but have not yet been verified by
a successful run. Application deployment will be managed by ArgoCD.
