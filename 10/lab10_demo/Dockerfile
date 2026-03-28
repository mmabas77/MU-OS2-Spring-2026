# ── Stage 0: Base ─────────────────────────────────────────────────────────────
# Shared foundation — both development and production inherit from this stage.
# Only copies package files here; the actual install happens in each child stage.
FROM node:20-alpine AS base
WORKDIR /app
COPY package*.json ./

# ── Stage 1: Development ──────────────────────────────────────────────────────
# Installs ALL dependencies including devDependencies (e.g. nodemon).
# The bind-mount in docker-compose.dev.yml overwrites /app at runtime for live
# reload, but node_modules comes from this layer (not the host).
FROM base AS development
RUN npm install
COPY . .
EXPOSE 3000
CMD ["npm", "run", "dev"]

# ── Stage 2: Production ───────────────────────────────────────────────────────
# Installs only production dependencies → smaller, leaner image.
# No bind-mount at runtime; all source code is baked into this image layer.
FROM base AS production
RUN npm install --only=production
COPY . .
EXPOSE 3000
CMD ["npm", "start"]
