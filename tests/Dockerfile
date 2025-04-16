FROM mcr.microsoft.com/playwright:v1.51.0
WORKDIR /tests

RUN npm install -g pnpm
COPY package.json pnpm-lock.yaml* ./
RUN pnpm install --frozen-lockfile
COPY . .

#CMD ["npx", "playwright", "test"]
CMD ["pnpm", "exec", "playwright", "test"]