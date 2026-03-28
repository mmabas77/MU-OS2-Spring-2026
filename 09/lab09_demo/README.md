# Lab 09 Demo — Docker Compose, Volumes & Hot Reload

## Quick Start

```bash
# Start the app with hot reload (uses docker-compose.yml)
docker compose up

# Rebuild the image first (needed after changing Dockerfile or dependencies)
docker compose up --build

# Stop and remove containers
docker compose down

# Stop, remove containers, and also delete volumes
docker compose down -v
```

## Hot Reload

Edit `index.js` while the container is running. Nodemon detects the change and restarts the server automatically — no need to rebuild the image.

This works because of the **bind mount** in `docker-compose.yml`:
```yaml
- ./:/app:ro         # local files → container (read-only: container cannot write back)
- /app/node_modules  # anonymous volume: keep container's node_modules separate
```

The `start:dev` script in `package.json` runs nodemon, which watches for file changes and restarts the Node.js server automatically.

## Environment Variables

Copy `.env.example` to `.env` and adjust values before running:

```bash
cp .env.example .env
```

| Variable   | Default       | Description              |
|------------|---------------|--------------------------|
| `NODE_ENV` | `development` | Runtime environment      |
| `PORT`     | `4000`        | Port the server listens on |

## Endpoints

| Route        | Response                                         |
|--------------|--------------------------------------------------|
| `GET /`      | Plain text `"Hi Hi"` — change this to test hot reload |
| `GET /health`| Plain text showing env mode and port             |
