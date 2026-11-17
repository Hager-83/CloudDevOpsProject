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

## Terraform Infrastructure Progress

### Completed

- Configured a dedicated IAM user for local Terraform execution.
- Created an S3 bucket for remote Terraform state with:
  - Versioning enabled.
  - AES256 server-side encryption.
  - Public access blocked.
  - Terraform deletion protection.
- Configured the main infrastructure to use the S3 backend
  with native S3 state locking.
- Implemented and deployed the network module:
  - One VPC with DNS support.
  - Two public and two private subnets across two Availability Zones.
  - An Internet Gateway.
  - One NAT Gateway with an Elastic IP.
  - Public and private route tables and subnet associations.
  - Separate public and private Network ACLs.
- Created three private ECR repositories:
  - `ivolve/auth-service`
  - `ivolve/frontend`
  - `ivolve/roadmap-service`
- Configured ECR repositories with immutable image tags
  and AES256 encryption.
- Exposed VPC, subnet, and ECR repository outputs.

### Validation

- Terraform initialization and validation completed successfully.
- The network deployment was verified with a subsequent plan
  reporting no changes.
- All three ECR repository URLs were retrieved successfully.

### Current Limitations

- Network ACLs currently allow all IPv4 inbound and outbound traffic.
- Both private subnets share one NAT Gateway in a single Availability Zone.
- Bootstrap state is currently stored locally and excluded from Git.
- ECR repositories are ready; application images have not been pushed yet.
- NAT Gateway and public IPv4 charges apply while provisioned.

### Next Steps

- Provision EKS and its worker nodes.
- Configure GitHub Actions authentication using AWS OIDC.
- Build and push application images to ECR.
- Deploy the application to EKS.