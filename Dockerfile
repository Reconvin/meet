# Install dependencies in the first stage
FROM node:18-alpine AS builder

# Set the working directory
WORKDIR /app

# Copy package files
COPY package.json pnpm-lock.yaml ./

# Install pnpm
RUN npm install -g pnpm

# Install dependencies
RUN pnpm install

# Copy all project files
COPY . .

# Build the app
RUN pnpm build

# Production image
FROM node:18-alpine

# Set the working directory
WORKDIR /app

# Copy built app from the builder stage
COPY --from=builder /app /app

# Install pnpm and production dependencies
RUN npm install -g pnpm && pnpm install --prod

# Expose the port
EXPOSE 3000

# Start the app
CMD ["pnpm", "start"]
