#FROM mcr.microsoft.com/playwright:v1.41.0-jammy
FROM node:20-bookworm
WORKDIR /tests

# Install pnpm globally
RUN npm install -g pnpm

# Copy only dependency files first
COPY package.json pnpm-lock.yaml ./

# Install Node.js dependencies
RUN pnpm install

# Install Playwright browsers and dependencies - this is the expensive step we want to cache
RUN pnpm exec playwright install --with-deps

# Copy test configuration
COPY playwright.config.ts ./

# Copy the rest of the test files
COPY . .

CMD ["pnpm", "exec", "playwright", "test"]