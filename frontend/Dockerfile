# Build stage
FROM node:20-alpine AS builder

# Install pnpm
RUN npm install -g pnpm

WORKDIR /app




# Copy the rest of the app
COPY . .

RUN pnpm install

# Set environment variables for Vite build
ENV VITE_API_DOMAIN=/api
ENV VITE_WEBSITE_DOMAIN=https://localhost
RUN pnpm run build

# Production stage
FROM node:20-alpine

# Install serve to host static files
RUN npm install -g serve

WORKDIR /app

# Copy built files from builder stage
COPY --from=builder /app/dist ./dist

EXPOSE 3000

CMD ["serve", "-s", "dist", "-l", "3000"]