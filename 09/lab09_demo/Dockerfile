FROM node:18-alpine

WORKDIR /app

# Copy only package.json first to leverage layer caching:
# If source code changes but dependencies don't, npm install is skipped
COPY package.json .

RUN npm install

# Copy the rest of the source code after installing dependencies
COPY . .

EXPOSE 4000

CMD ["npm", "run", "start:dev"]
