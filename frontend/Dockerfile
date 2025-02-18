FROM node:20-alpine

# Install pnpm
RUN npm install -g pnpm

WORKDIR /app

COPY . .
# Copy pnpm-lock.yaml in addition to package.json
#COPY package.json pnpm-lock.yaml ./

# Use pnpm to install dependencies
RUN pnpm install



EXPOSE 3000

CMD ["pnpm", "run", "dev"]
