#!/bin/bash
# ─────────────────────────────────────────────────────────────
# Azure One-Time Setup Script
# Run this ONCE before your first pipeline run.
# ─────────────────────────────────────────────────────────────

set -e

RESOURCE_GROUP="migration-tracker-rg"
LOCATION="eastus"
ACR_NAME="migrationtrackeracr"
APP_NAME="migration-tracker"
ENVIRONMENT_NAME="migration-tracker-env"

echo "🔧 Creating Resource Group..."
az group create --name $RESOURCE_GROUP --location $LOCATION

echo "📦 Creating Azure Container Registry..."
az acr create \
  --resource-group $RESOURCE_GROUP \
  --name $ACR_NAME \
  --sku Basic \
  --admin-enabled true

echo "🌐 Creating Container Apps Environment..."
az containerapp env create \
  --name $ENVIRONMENT_NAME \
  --resource-group $RESOURCE_GROUP \
  --location $LOCATION

echo "🚀 Creating Container App (initial deploy)..."
az containerapp create \
  --name $APP_NAME \
  --resource-group $RESOURCE_GROUP \
  --environment $ENVIRONMENT_NAME \
  --image mcr.microsoft.com/azuredocs/containerapps-helloworld:latest \
  --target-port 3000 \
  --ingress external \
  --min-replicas 0 \
  --max-replicas 10 \
  --memory 0.5Gi \
  --cpu 0.25 \
  --registry-server "$ACR_NAME.azurecr.io" \
  --registry-username $(az acr credential show --name $ACR_NAME --query username -o tsv) \
  --registry-password $(az acr credential show --name $ACR_NAME --query "passwords[0].value" -o tsv)

URL=$(az containerapp show \
  --name $APP_NAME \
  --resource-group $RESOURCE_GROUP \
  --query properties.configuration.ingress.fqdn -o tsv)

echo ""
echo "✅ Setup complete!"
echo "📍 App URL: https://$URL"
echo ""
echo "Next: Push code to GitHub → Azure Pipelines will auto-deploy."
