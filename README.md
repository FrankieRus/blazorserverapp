# BlazorServerApp

A .NET 10 Blazor Web App configured with Interactive Server rendering (`--interactivity Server`), a `/health` endpoint, **GitHub Codespaces** support, Docker support, and optional Azure App Service CI/CD.

## Run in GitHub Codespaces

[![Open in GitHub Codespaces](https://github.com/codespaces/badge.svg)](https://codespaces.new/FrankieRus/blazorserverapp)

Opening this repository in GitHub Codespaces uses `.devcontainer/devcontainer.json` to:
1. Provision a `.NET 10` container (`mcr.microsoft.com/devcontainers/dotnet:10.0-noble`).
2. Restore and build `BlazorServerApp.csproj`.
3. Automatically start the app on port `5080` via `.devcontainer/start.sh` and forward it with automatic browser preview.
4. Keep the Codespace synced with `origin/main` via `.devcontainer/auto-sync.sh` (checks every 15s; when the working tree is clean and new commits are pushed to `main`, it runs `git pull --ff-only` and restarts the app automatically).

Useful commands inside the Codespace terminal:
- View app logs: `tail -f /tmp/blazorserverapp.log`
- View auto-sync logs: `tail -f /tmp/blazorserverapp-sync.log`
- Restart the background app & auto-sync: `bash .devcontainer/start.sh`
- Run with hot reload (`dotnet watch`): stop the background process first or run the VS Code `watch` task (`Ctrl+Shift+P` → `Tasks: Run Task` → `watch`).
- Make the forwarded port public (optional, to share the preview URL): in the **Ports** tab, right-click port `5080` → **Port Visibility** → **Public**.

## Run Locally

```bash
dotnet restore
dotnet run
```

Health check endpoint: `GET /health`

## Optional: Docker & Azure App Service

- **Docker**:
  ```bash
  docker build -t blazorserverapp .
  docker run -p 8080:8080 blazorserverapp
  ```
- **Azure App Service**: see `.github/workflows/deploy-azure.yml` (add repository secret `AZURE_WEBAPP_PUBLISH_PROFILE` and optional variable `AZURE_WEBAPP_NAME`).
