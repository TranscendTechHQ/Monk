FROM mcr.microsoft.com/playwright:v1.41.0-jammy
WORKDIR /tests
COPY . .
RUN npm install -g pnpm
RUN pnpm install
RUN pnpm exec playwright install --with-deps
CMD ["pnpm", "exec", "playwright", "test"]