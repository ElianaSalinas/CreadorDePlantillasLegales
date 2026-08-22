FROM node:22-alpine

WORKDIR /app

# Copy package files
COPY package.json package-lock.json ./

# Install ALL dependencies (including devDependencies needed for build)
RUN npm ci

# Copy source code
COPY . .

# Build the Next.js app
RUN npm run build

# Expose port
EXPOSE 3000

ENV NODE_ENV=production
ENV HOSTNAME=0.0.0.0

# Use Railway's dynamic $PORT (falls back to 3000 locally)
CMD ["node_modules/.bin/next", "start", "-p", "3000"]
