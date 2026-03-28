# Base image: Node.js 14 (as shown in the lecture)
FROM node:14

# Set working directory inside the container
WORKDIR /app

# Copy package.json first to take advantage of Docker layer caching.
# Docker only re-runs 'npm install' when package.json actually changes.
COPY package.json .

# Install dependencies
RUN npm install

# Copy the rest of the application source code
COPY . .

# Expose the port the app listens on (documentation only; does not publish the port)
EXPOSE 4000

# Default command to start the application
CMD ["npm", "start"]
