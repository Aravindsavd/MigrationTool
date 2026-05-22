# Migration Tracker

**On-Premises → SaaS File Migration Demo**  
HKakshatha's DevOps & Cloud Engineering Portfolio

Live interactive demo showing Windows File Explorer-style migration from on-prem storage to SharePoint/OneDrive (SaaS), deployed on Azure Container Apps with a full CI/CD pipeline.

---

## Tech Stack

| Layer | Technology |
|---|---|
| App | Node.js + Express |
| Frontend | Vanilla HTML/CSS/JS |
| Container | Docker |
| Registry | Azure Container Registry (ACR) |
| Hosting | Azure Container Apps |
| CI/CD | Azure Pipelines |

---

## Project Structure

```
migration-tracker/
├── src/
│   ├── server.js          # Express server
│   └── public/
│       └── index.html     # Migration demo UI
├── Dockerfile             # Container definition
├── azure-pipelines.yml    # CI/CD pipeline
├── azure-setup.sh         # One-time Azure infra setup
├── package.json
└── README.md
```

---

## Getting Started

### 1. Run locally

```bash
npm install
npm start
# Open http://localhost:3000
```

### 2. Deploy to Azure

**Step 1 — One-time Azure setup** (run once):
```bash
az login
chmod +x azure-setup.sh
./azure-setup.sh
```

**Step 2 — Connect Azure Pipelines to GitHub:**
- Go to [dev.azure.com](https://dev.azure.com) → New Project
- Pipelines → New Pipeline → GitHub → select this repo
- Set service connection name to `azure-service-connection`
- Run the pipeline

**Step 3 — Push code, auto-deploy!**
```bash
git add .
git commit -m "feat: initial migration tracker"
git push origin main
# Azure Pipelines picks it up automatically
```

---

## CI/CD Pipeline Stages

```
Push to main
    │
    ▼
[Stage 1] Build & Test
    │  npm ci → npm test
    ▼
[Stage 2] Containerize
    │  docker build → push to ACR
    ▼
[Stage 3] Deploy
       az containerapp update → live URL printed
```

---

## Azure Resources Created

| Resource | Name |
|---|---|
| Resource Group | migration-tracker-rg |
| Container Registry | migrationtrackeracr |
| Container Apps Env | migration-tracker-env |
| Container App | migration-tracker |

---

Built by HKakshatha · Inspired by the GCP Cloud Run version
