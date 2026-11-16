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