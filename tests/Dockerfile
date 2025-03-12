FROM mcr.microsoft.com/playwright:latest

WORKDIR /tests

COPY package.json pnpm-lock.yaml* ./
RUN npm install -g pnpm && pnpm install --frozen-lockfile

COPY . .

CMD ["pnpm", "exec", "playwright", "test"]
