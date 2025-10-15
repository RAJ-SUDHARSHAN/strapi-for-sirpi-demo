FROM node:20-alpine AS builder

# Install build dependencies
RUN apk add --no-cache \
    build-base \
    gcc \
    autoconf \
    automake \
    zlib-dev \
    libpng-dev \
    nasm \
    bash \
    vips-dev \
    git

WORKDIR /app

# Copy package files for better caching
COPY package.json yarn.lock .yarnrc.yml ./
COPY .yarn ./.yarn

# Install all dependencies (including devDependencies for build)
RUN yarn install --immutable

# Copy application code
COPY . .

# Build the application
ARG NODE_ENV=production
ENV NODE_ENV=${NODE_ENV}
RUN yarn build

# Production stage
FROM node:20-alpine AS production

# Install runtime dependencies
RUN apk add --no-cache \
    vips \
    curl

# Create non-root user
RUN addgroup -g 1001 -S strapiuser && \
    adduser -S -u 1001 -G strapiuser strapiuser

WORKDIR /app

# Copy package files
COPY --chown=strapiuser:strapiuser package.json yarn.lock .yarnrc.yml ./
COPY --chown=strapiuser:strapiuser .yarn ./.yarn

# Install production dependencies only
ENV NODE_ENV=production
RUN yarn workspaces focus --production && \
    yarn cache clean

# Copy built application from builder stage
COPY --chown=strapiuser:strapiuser --from=builder /app/dist ./dist
COPY --chown=strapiuser:strapiuser --from=builder /app/build ./build
COPY --chown=strapiuser:strapiuser --from=builder /app/public ./public
COPY --chown=strapiuser:strapiuser --from=builder /app/.cache ./.cache
COPY --chown=strapiuser:strapiuser --from=builder /app/config ./config
COPY --chown=strapiuser:strapiuser --from=builder /app/database ./database
COPY --chown=strapiuser:strapiuser --from=builder /app/src ./src

# Switch to non-root user
USER strapiuser

# Configure runtime
ARG PORT=1337
ENV PORT=${PORT}
ENV HOST=0.0.0.0

# Add metadata labels
LABEL maintainer="devops@company.com"
LABEL app="strapi"
LABEL version="1.0.0"
LABEL runtime="node20"

# Expose application port
EXPOSE ${PORT}

# Add health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=40s --retries=3 \
    CMD curl -f http://localhost:${PORT}/_health || exit 1

# Start the application
CMD ["yarn", "start"]