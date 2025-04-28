# Use a more secure base image
FROM node:18-alpine AS builder

WORKDIR /app

# Install dependencies and build the app
COPY package*.json ./
RUN npm ci
COPY . .
RUN npm run build

# Final stage to run the app
FROM node:18-alpine

WORKDIR /app

COPY --from=builder /app/package*.json ./
COPY --from=builder /app/next.config.ts ./next.config.ts
COPY --from=builder /app/public ./public
COPY --from=builder /app/.next ./.next
COPY --from=builder /app/node_modules ./node_modules

EXPOSE 3000
CMD ["npm", "run", "start"]
