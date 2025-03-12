#FROM mcr.microsoft.com/playwright:v1.41.0-jammy
FROM node:20-bookworm
WORKDIR /tests
COPY playwright.config.ts .
COPY package.json .
COPY pnpm-lock.yaml .
RUN npm install -g pnpm
RUN pnpm install
RUN pnpm exec playwright install --with-deps
COPY . .
CMD ["pnpm", "exec", "playwright", "test"]