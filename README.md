# BlazorServerApp

A .NET 10 Blazor Web App configured with Interactive Server rendering (`--interactivity Server`), a `/health` endpoint, Docker support, and GitHub Actions CI/CD for Azure App Service.

## Run Locally

```bash
dotnet restore
dotnet run
```

Health check endpoint: `GET /health`

## Deploy to Azure App Service

### Option 1: GitHub Actions (Automatic CI/CD)

The workflow in `.github/workflows/deploy-azure.yml` builds and publishes the app on every push/PR to `main` and deploys to Azure App Service on pushes to `main` (or manual runs).

1. Create a Linux Web App in Azure App Service with runtime **.NET 10 (LTS)** and enable **WebSockets** (required for Blazor Server SignalR circuits):
   ```bash
   az group create --name blazorserverapp-rg --location eastus
   az appservice plan create --name blazorserverapp-plan --resource-group blazorserverapp-rg --sku B1 --is-linux
   az webapp create --name <your-unique-app-name> --resource-group blazorserverapp-rg --plan blazorserverapp-plan --runtime "DOTNETCORE:10.0"
   az webapp config set --name <your-unique-app-name> --resource-group blazorserverapp-rg --web-sockets-enabled true
   ```
2. Download the publish profile:
   ```bash
   az webapp deployment list-publishing-profiles --name <your-unique-app-name> --resource-group blazorserverapp-rg --xml
   ```
3. In GitHub (`Settings → Secrets and variables → Actions`):
   - Add **Secret** `AZURE_WEBAPP_PUBLISH_PROFILE` with the XML publish profile content.
   - Add **Variable** `AZURE_WEBAPP_NAME` with `<your-unique-app-name>` (defaults to `blazorserverapp`).
4. Push to `main` or run **Build and Deploy Blazor Server App to Azure App Service** from the **Actions** tab.

### Option 2: Docker

```bash
docker build -t blazorserverapp .
docker run -p 8080:8080 blazorserverapp
```
