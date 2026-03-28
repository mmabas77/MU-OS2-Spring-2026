# Lab 10: Docker in Production — Environments, Multi-Stage Builds, and Databases

## Overview

This lab covers advanced Docker topics: managing multiple deployment environments using separate Docker Compose files, writing multi-stage Dockerfiles to produce lean production images, connecting a Node.js application to a MongoDB database running in a Docker container, persisting database data using Docker volumes, and adding a Mongo Express web UI as an additional service.

---

## Objectives

- Separate development and production configurations using multiple Docker Compose files
- Use a shared `docker-compose.yml` base file with environment-specific override files
- Write a multi-stage Dockerfile with separate `development` and `production` build stages
- Run MongoDB as a Docker container alongside a Node.js application
- Use Docker networking so containers communicate by service name
- Persist database data across container restarts using named Docker volumes
- Add Mongo Express as an admin UI container for MongoDB

---

## Prerequisites

- Labs 08 and 09 completed (Docker basics, single-container Node.js app, Docker Compose)
- Docker and Docker Compose installed
- A Node.js application with a `package.json` already in place

---

## Background

### 1. Docker Environments (Dev vs Prod)

Running the same application in development and production requires different settings:

| Setting | Development | Production |
|---|---|---|
| Node startup command | `npm run dev` (nodemon) | `npm start` |
| `NODE_ENV` | `development` | `production` |
| Volume bind-mount (live reload) | Yes | No |
| Install dev dependencies | Yes | No (`--only=production`) |

#### Strategy: One Base File + Per-Environment Override Files

Instead of duplicating a full Docker Compose file for every environment, use:

- `docker-compose.yml` — shared configuration (ports, service name, build context)
- `docker-compose.dev.yml` — development-specific overrides (volumes, command, env)
- `docker-compose.prod.yml` — production-specific overrides (command, env)

**`docker-compose.yml` (base — shared settings)**

```yaml
version: "3"
services:
  node-app:
    build: .
    ports:
      - "3000:3000"
```

**`docker-compose.dev.yml` (development overrides)**

```yaml
version: "3"
services:
  node-app:
    volumes:
      - ./:/app
      - /app/node_modules
    environment:
      - NODE_ENV=development
    command: npm run dev
```

**`docker-compose.prod.yml` (production overrides)**

```yaml
version: "3"
services:
  node-app:
    environment:
      - NODE_ENV=production
    command: npm start
```

#### Running with a specific environment

Specify both files with `-f`. Docker Compose merges them — the override file wins for any key that appears in both.

```bash
# Development
docker compose -f docker-compose.yml -f docker-compose.dev.yml up -d

# Production
docker compose -f docker-compose.yml -f docker-compose.prod.yml up -d

# Rebuild and start (after Dockerfile changes)
docker compose -f docker-compose.yml -f docker-compose.dev.yml up -d --build

# Stop (same files must be specified)
docker compose -f docker-compose.yml -f docker-compose.dev.yml down
```

> **Note:** You must specify both `-f` files when running `down` as well. If Docker Compose cannot find the service name it will report an error.

---

### 2. Multi-Stage Dockerfile

A multi-stage Dockerfile lets you use different build instructions for different environments — all in a single file. Docker Compose points to the correct stage using the `target` field.

#### Why multi-stage?

| Problem | Solution |
|---|---|
| Dev dependencies included in the production image | Only run `npm install --only=production` in the `production` stage |
| Wrong startup command per environment | Each stage defines its own `CMD` |
| Large final image size | Production stage skips dev tools entirely |

#### Single-file multi-stage Dockerfile

```dockerfile
FROM node:14 AS base
WORKDIR /app
COPY package*.json ./

FROM base AS development
RUN npm install
COPY . .
CMD ["npm", "run", "dev"]

FROM base AS production
RUN npm install --only=production
COPY . .
CMD ["npm", "start"]
```

**Explanation:**

- `base` stage — sets the working directory and copies `package.json` only; no install yet
- `development` stage (`FROM base AS development`) — full `npm install` including dev dependencies; starts with nodemon
- `production` stage (`FROM base AS production`) — `npm install --only=production` skips dev tools; starts normally

#### Pointing Docker Compose to a stage

Replace the plain `build: .` with a build block specifying `context` and `target`:

**`docker-compose.dev.yml`**

```yaml
version: "3"
services:
  node-app:
    build:
      context: .
      target: development
    volumes:
      - ./:/app
      - /app/node_modules
    environment:
      - NODE_ENV=development
```

**`docker-compose.prod.yml`**

```yaml
version: "3"
services:
  node-app:
    build:
      context: .
      target: production
    environment:
      - NODE_ENV=production
```

#### Architecture diagram

```mermaid
graph TD
    A[Dockerfile] --> B["base stage\nFROM node:14\nWORKDIR /app\nCOPY package*.json"]
    B --> C["development stage\nRUN npm install\nCMD npm run dev"]
    B --> D["production stage\nRUN npm install --only=production\nCMD npm start"]

    E["docker-compose.dev.yml\ntarget: development"] --> C
    F["docker-compose.prod.yml\ntarget: production"] --> D
```

---

### 3. Docker with MongoDB and Node.js

#### Adding MongoDB as a service

MongoDB has an official image on Docker Hub. Add it as a second service in `docker-compose.yml`:

```yaml
version: "3"
services:
  node-app:
    build: .
    ports:
      - "3000:3000"

  mongo:
    image: mongo
    environment:
      - MONGO_INITDB_ROOT_USERNAME=root
      - MONGO_INITDB_ROOT_PASSWORD=example
    volumes:
      - mongo-db:/data/db

volumes:
  mongo-db:
```

> The `volumes:` section at the bottom declares the named volume `mongo-db`. The service maps it to `/data/db` inside the container — that is where MongoDB stores its data files.

#### Connecting from Node.js using Mongoose

Install mongoose:

```bash
npm install mongoose
```

In your Node.js application (`index.js`):

```javascript
const mongoose = require("mongoose");

const DB_USER = "root";
const DB_PASSWORD = "example";
const DB_HOST = "mongo";    // Docker service name — resolved automatically by Docker DNS
const DB_PORT = 27017;

const URI = `mongodb://${DB_USER}:${DB_PASSWORD}@${DB_HOST}:${DB_PORT}`;

mongoose
  .connect(URI)
  .then(() => console.log("Connected to database"))
  .catch((err) => console.log("Failed to connect to database", err));
```

> **Key point:** Use the Docker Compose **service name** (`mongo`) as the hostname. Docker's built-in DNS maps the service name to the container's IP address automatically. You never need to hard-code an IP address.

#### How Docker networking works

When Docker Compose starts multiple services it creates a **default network** and attaches all containers to it. Each container gets an IP address, and Docker's internal DNS maps every service name to its container's current IP.

```mermaid
graph LR
    subgraph default_network["Docker Default Network"]
        A["node-app\ncontainer"] <-->|"hostname: mongo"| B["mongo\ncontainer"]
    end
    C["Host Machine"] -->|":3000"| A
```

#### Inspecting containers and networks

```bash
# List running containers
docker ps

# Inspect a container (shows IP, network, env, volumes)
docker inspect <container_name>

# List Docker networks
docker network ls

# Inspect the default network (shows all containers and their IPs)
docker network inspect <network_name>
```

#### Verifying the connection

```bash
# Follow application logs
docker logs <node_app_container> -f

# Expected output:
# App is up and running on port 3000
# Connected to database
```

#### Working inside the MongoDB container

```bash
# Open a terminal on the MongoDB container
docker exec -it <mongo_container> bash

# Start the mongo shell
mongosh -u root -p example

# Inside mongosh
show dbs
use testdb
db.books.insertOne({ title: "Book One" })
db.books.find()
```

You can also run a command directly without opening a shell:

```bash
docker exec -it <mongo_container> mongosh -u root -p example --eval "show dbs"
```

---

### 4. Docker Volumes for Data Persistence

Without a volume, all MongoDB data is lost when the container stops.

**Demonstrating the data-loss problem:**

```bash
docker compose down        # stops and removes containers
docker compose up -d       # restarts — database is empty again
```

**Solution: Named Volume**

Add to `docker-compose.yml`:

```yaml
services:
  mongo:
    image: mongo
    environment:
      - MONGO_INITDB_ROOT_USERNAME=root
      - MONGO_INITDB_ROOT_PASSWORD=example
    volumes:
      - mongo-db:/data/db   # named volume -> MongoDB data directory inside container

volumes:
  mongo-db:                 # declare the named volume here
```

**Volume management commands:**

```bash
# List all volumes
docker volume ls

# Remove a specific volume
docker volume rm <volume_name>

# Remove all unused volumes (cleanup)
docker volume prune

# Stop containers but KEEP volumes (default)
docker compose down

# Stop containers AND DELETE volumes
docker compose down -v
```

> **Warning:** `docker compose down -v` permanently deletes your database data. Never use `-v` on a production database.

---

### 5. Mongo Express Admin UI

Mongo Express is a web-based MongoDB admin interface that runs as its own Docker container alongside MongoDB.

#### Adding Mongo Express to Docker Compose

```yaml
version: "3"
services:
  node-app:
    build: .
    ports:
      - "3000:3000"

  mongo:
    image: mongo
    environment:
      - MONGO_INITDB_ROOT_USERNAME=root
      - MONGO_INITDB_ROOT_PASSWORD=example
    volumes:
      - mongo-db:/data/db

  mongo-express:
    image: mongo-express
    ports:
      - "8081:8081"
    environment:
      - ME_CONFIG_MONGODB_ADMINUSERNAME=root
      - ME_CONFIG_MONGODB_ADMINPASSWORD=example
      - ME_CONFIG_MONGODB_SERVER=mongo
    depends_on:
      - mongo

volumes:
  mongo-db:
```

**Mongo Express environment variables:**

| Variable | Value | Purpose |
|---|---|---|
| `ME_CONFIG_MONGODB_ADMINUSERNAME` | `root` | MongoDB admin username |
| `ME_CONFIG_MONGODB_ADMINPASSWORD` | `example` | MongoDB admin password |
| `ME_CONFIG_MONGODB_SERVER` | `mongo` | Service name of the MongoDB container |

> `depends_on: - mongo` tells Docker Compose to start the `mongo` container before starting `mongo-express`.

#### Starting all three services

```bash
docker compose -f docker-compose.yml -f docker-compose.dev.yml up -d --build
```

Open `http://localhost:8081` in a browser to access the Mongo Express UI.

#### Full three-container architecture

```mermaid
graph LR
    Browser -->|":8081"| ME["mongo-express\ncontainer"]
    App["node-app\ncontainer"] -->|"service: mongo"| DB["mongo\ncontainer"]
    ME -->|"service: mongo"| DB
    DB --- Vol[("mongo-db\nvolume")]

    subgraph net["Docker Default Network"]
        App
        ME
        DB
    end
```

---

## Lab Tasks

### Task 1: Create Dev and Prod Configurations

**Goal:** Split a single `docker-compose.yml` into a base file plus two environment-specific override files.

**Steps:**

1. Create a project folder structure:

   ```
   my-app/
   ├── index.js
   ├── package.json
   ├── Dockerfile
   ├── .dockerignore
   ├── docker-compose.yml
   ├── docker-compose.dev.yml
   └── docker-compose.prod.yml
   ```

2. Write `docker-compose.yml` (shared base):

   ```yaml
   version: "3"
   services:
     node-app:
       build: .
       ports:
         - "3000:3000"
   ```

3. Write `docker-compose.dev.yml`:

   ```yaml
   version: "3"
   services:
     node-app:
       volumes:
         - ./:/app
         - /app/node_modules
       environment:
         - NODE_ENV=development
       command: npm run dev
   ```

4. Write `docker-compose.prod.yml`:

   ```yaml
   version: "3"
   services:
     node-app:
       environment:
         - NODE_ENV=production
       command: npm start
   ```

5. Start in development mode:

   ```bash
   docker compose -f docker-compose.yml -f docker-compose.dev.yml up -d --build
   ```

6. Verify the app at `http://localhost:3000`.

7. Edit `index.js` and confirm live reload (file changes are reflected without rebuilding).

8. Stop and switch to production:

   ```bash
   docker compose -f docker-compose.yml -f docker-compose.dev.yml down
   docker compose -f docker-compose.yml -f docker-compose.prod.yml up -d --build
   ```

9. Edit `index.js` again and confirm changes are NOT picked up without a rebuild.

**Expected output when starting:**

```
[+] Running 1/1
 ✔ Container my-app-node-app-1  Started
```

---

### Task 2: Write a Multi-Stage Dockerfile

**Goal:** Replace a single-environment Dockerfile with a multi-stage Dockerfile targeting dev and prod stages separately.

**Steps:**

1. Write a multi-stage `Dockerfile`:

   ```dockerfile
   FROM node:14 AS base
   WORKDIR /app
   COPY package*.json ./

   FROM base AS development
   RUN npm install
   COPY . .
   CMD ["npm", "run", "dev"]

   FROM base AS production
   RUN npm install --only=production
   COPY . .
   CMD ["npm", "start"]
   ```

2. Update `docker-compose.dev.yml` to target the development stage:

   ```yaml
   version: "3"
   services:
     node-app:
       build:
         context: .
         target: development
   ```

3. Update `docker-compose.prod.yml` to target the production stage:

   ```yaml
   version: "3"
   services:
     node-app:
       build:
         context: .
         target: production
   ```

4. Build and run in production:

   ```bash
   docker compose -f docker-compose.yml -f docker-compose.prod.yml up -d --build
   ```

5. Verify `nodemon` is NOT installed in production:

   ```bash
   docker exec -it <container_name> bash
   ls node_modules | grep nodemon
   # Expected: no output
   ```

6. Stop, then build and run in development:

   ```bash
   docker compose -f docker-compose.yml -f docker-compose.prod.yml down
   docker compose -f docker-compose.yml -f docker-compose.dev.yml up -d --build
   ```

7. Verify `nodemon` IS present:

   ```bash
   docker exec -it <container_name> bash
   ls node_modules | grep nodemon
   # Expected: nodemon
   ```

---

### Task 3: Connect Node.js App with MongoDB

**Goal:** Add MongoDB as a service and connect the Node.js app using Mongoose.

**Steps:**

1. Install Mongoose in your project:

   ```bash
   npm install mongoose
   ```

2. Update `docker-compose.yml` to add the MongoDB service and a named volume:

   ```yaml
   version: "3"
   services:
     node-app:
       build: .
       ports:
         - "3000:3000"

     mongo:
       image: mongo
       environment:
         - MONGO_INITDB_ROOT_USERNAME=root
         - MONGO_INITDB_ROOT_PASSWORD=example
       volumes:
         - mongo-db:/data/db

   volumes:
     mongo-db:
   ```

3. Add a database connection in `index.js`:

   ```javascript
   const mongoose = require("mongoose");

   const URI = "mongodb://root:example@mongo:27017";

   mongoose
     .connect(URI)
     .then(() => console.log("Connected to database"))
     .catch((err) => console.log("Failed to connect:", err));
   ```

4. Start the services:

   ```bash
   docker compose -f docker-compose.yml -f docker-compose.dev.yml up -d --build
   ```

5. Verify the connection:

   ```bash
   docker logs <node_app_container> -f
   ```

   **Expected:**

   ```
   App is up and running on port 3000
   Connected to database
   ```

6. Insert a record inside MongoDB:

   ```bash
   docker exec -it <mongo_container> mongosh -u root -p example
   use testdb
   db.books.insertOne({ title: "Docker Lab 10" })
   db.books.find()
   ```

7. Test data persistence:

   ```bash
   docker compose down
   docker compose -f docker-compose.yml -f docker-compose.dev.yml up -d
   docker exec -it <mongo_container> mongosh -u root -p example
   use testdb
   db.books.find()
   ```

   **Expected:** The record is still present after restart.

---

### Task 4: Add Mongo Express Admin UI

**Goal:** Add Mongo Express as a third service and browse the database through a web UI.

**Steps:**

1. Update `docker-compose.yml` to add Mongo Express:

   ```yaml
   version: "3"
   services:
     node-app:
       build: .
       ports:
         - "3000:3000"

     mongo:
       image: mongo
       environment:
         - MONGO_INITDB_ROOT_USERNAME=root
         - MONGO_INITDB_ROOT_PASSWORD=example
       volumes:
         - mongo-db:/data/db

     mongo-express:
       image: mongo-express
       ports:
         - "8081:8081"
       environment:
         - ME_CONFIG_MONGODB_ADMINUSERNAME=root
         - ME_CONFIG_MONGODB_ADMINPASSWORD=example
         - ME_CONFIG_MONGODB_SERVER=mongo
       depends_on:
         - mongo

   volumes:
     mongo-db:
   ```

2. Start all services:

   ```bash
   docker compose -f docker-compose.yml -f docker-compose.dev.yml up -d --build
   ```

3. Verify three containers are running:

   ```bash
   docker ps
   ```

   **Expected (3 rows):**

   ```
   CONTAINER ID   IMAGE           STATUS
   xxxxxxxxxxxx   node-app        Up
   xxxxxxxxxxxx   mongo           Up
   xxxxxxxxxxxx   mongo-express   Up
   ```

4. Open `http://localhost:8081` in a browser.

5. Navigate to `testdb` → `books` and confirm the record from Task 3 is visible.

6. Use the Mongo Express UI to insert a new document.

7. Verify the new document appears when you run `db.books.find()` in the mongo shell.

---

## Summary

| Concept | Key Takeaway |
|---|---|
| Environment separation | Use a shared `docker-compose.yml` + per-environment override files with `-f` |
| Override merging | Docker Compose merges files — values in the override file win |
| Multi-stage Dockerfile | One Dockerfile, multiple `FROM ... AS <stage>` blocks; `target:` selects the stage |
| Production dependencies | `npm install --only=production` skips dev tools |
| Container networking | Docker Compose creates a default network; use **service names** as hostnames |
| `docker inspect` | Shows container IP address, network membership, volumes, and environment |
| Named volumes | Declared in `volumes:` block; persist data across container restarts |
| `docker compose down -v` | Deletes containers AND volumes — use with caution |
| Mongo Express | Web UI for MongoDB; connects to the `mongo` container by service name |
| `depends_on` | Controls startup order between services |
