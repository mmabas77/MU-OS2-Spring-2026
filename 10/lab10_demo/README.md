# Lab 10 Demo — Multi-Stage Docker + MongoDB + Mongo Express

A Node.js/Express app demonstrating Docker environments, multi-stage builds, and MongoDB with Mongo Express.

## Project Structure

```
lab10_demo/
├── Dockerfile                 # Multi-stage: development + production stages
├── docker-compose.yml         # Shared base (node-app, mongo, mongo-express)
├── docker-compose.dev.yml     # Dev overrides (bind mount, nodemon, dev stage)
├── docker-compose.prod.yml    # Prod overrides (no volumes, production stage)
├── .env                       # Environment variables (do not commit)
├── .env.example               # Template (safe to commit)
├── index.js                   # Express app with MongoDB routes
└── models/Item.js             # Mongoose model
```

## Quick Start

### Development (hot reload + dev dependencies)

```bash
docker compose -f docker-compose.yml -f docker-compose.dev.yml up --build
```

### Production (lean image, no devDeps)

```bash
docker compose -f docker-compose.yml -f docker-compose.prod.yml up --build
```

### Stop containers

```bash
docker compose down          # keep MongoDB data volume
docker compose down -v       # also delete MongoDB data
```

## Access

| Service       | URL                    |
|---------------|------------------------|
| Node.js App   | http://localhost:3000  |
| Mongo Express | http://localhost:8081  |

## API Endpoints

| Method | Path     | Description        |
|--------|----------|--------------------|
| GET    | /        | Status + DB state  |
| GET    | /items   | List all items     |
| POST   | /items   | Create item { "name": "..." } |

## Key Concepts Demonstrated

- **Multi-stage Dockerfile**: development stage (all deps + nodemon) vs production stage (only prod deps, smaller image)
- **Multiple Compose files**: base + per-environment overrides merged with -f
- **MongoDB service**: persistent data via named volume mongo-data
- **Mongo Express**: web UI for MongoDB at port 8081
- **Docker networking**: containers communicate by service name (mongo)
