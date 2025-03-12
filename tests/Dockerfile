# Stage 1: Dependency installation and build
FROM mcr.microsoft.com/playwright:latest AS builder

WORKDIR /tests

# Install pnpm using corepack (comes with Node.js 20+)
RUN corepack enable && corepack prepare pnpm@latest --activate

# Copy package files first for optimal caching
COPY package.json pnpm-lock.yaml* ./

# Install production dependencies only
RUN pnpm install --prod --frozen-lockfile

# Copy remaining files
COPY . .

# Stage 2: Minimal runtime image
FROM mcr.microsoft.com/playwright:latest

WORKDIR /tests

# Copy installed dependencies from builder
COPY --from=builder /tests/node_modules ./node_modules
COPY --from=builder /tests/package.json .
COPY --from=builder /tests/playwright.config.ts .
COPY --from=builder /tests/tests ./tests

# Verify browsers are available (already included in base image)
RUN npx playwright install --dry-run

CMD ["pnpm", "exec", "playwright", "test"]
