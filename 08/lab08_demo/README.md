# Lab 08 — Docker Basics Demo

A minimal Node.js/Express app to demonstrate Docker fundamentals.
Matches the exact code shown in the lecture videos (port 4000, node:14 base image).

## Run Without Docker

```bash
npm install
npm start
# Visit http://localhost:4000
```

For local development with hot-reload:

```bash
npm install --save-dev nodemon
npm run start:dev
```

## Docker Quick Start

```bash
# Build the image
docker build -t express-node-app .

# Run a container (foreground, to see logs directly)
docker run --name express-node-app-container express-node-app

# Run detached (background) with port forwarding
docker run -d --name express-node-app-container -p 4000:4000 express-node-app

# Verify the container is running
docker ps

# Visit http://localhost:4000 — you should see the HTML response

# Stop the container
docker stop express-node-app-container

# Remove a stopped container
docker rm express-node-app-container

# Force-stop and remove in one command
docker rm -f express-node-app-container
```

## Useful Docker Commands

```bash
docker image ls                          # list local images
docker ps                                # list running containers
docker ps -a                             # list all containers (running + stopped)
docker logs express-node-app-container   # view container output
docker rmi express-node-app              # remove the image (remove container first)
```

## Key Concepts

| Concept | Description |
|---------|-------------|
| Dockerfile | Instructions for building the image |
| `FROM node:14` | Base image pulled from Docker Hub |
| `WORKDIR /app` | Working directory inside the container |
| `COPY package.json .` | Copied before `npm install` for layer caching |
| `RUN npm install` | Installs deps during build (not at runtime) |
| `EXPOSE 4000` | Documentation only — does not publish the port |
| `CMD ["npm", "start"]` | Command that runs when a container starts |
| `-p 4000:4000` | Port forwarding: host port → container port |
| `-d` | Detached mode — runs container in background |
| Docker Image | Template/blueprint (like a Class in OOP) |
| Docker Container | Running instance of an image (like an Object) |
