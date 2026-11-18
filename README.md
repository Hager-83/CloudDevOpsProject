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

### Current Limitations

- Network ACLs currently allow all IPv4 inbound and outbound traffic.
- Both private subnets share one NAT Gateway in a single Availability Zone.
- Bootstrap state is stored locally and excluded from Git.
  Retain a secure backup of this state.
- ECR repositories are provisioned; application images have not
  been pushed yet.
- Application workloads and ArgoCD have not been deployed to EKS.
- GitHub Actions workflows have not been configured yet.
- Provisioned AWS resources, including EKS, EC2 worker nodes,
  EBS volumes, NAT Gateway, and public IPv4 addresses, incur charges.

### Next Steps

- Create Kubernetes manifests for the application and database.
- Configure persistent storage, environment configuration,
  Secrets, Services, and frontend Ingress.
- Implement reusable GitHub Actions workflows to build images,
  scan them with Trivy, push them to ECR, and update manifests.
- Verify GitHub Actions authentication to AWS using OIDC.
- Configure ArgoCD to deploy and synchronize the application.
- Complete setup instructions and architecture documentation.