FROM docker.io/library/node:18 as builder

# Build the app
WORKDIR /app
COPY package.json package-lock.json ./
ENV NODE_ENV production
RUN npm ci
COPY . .

# Build runtime
FROM docker.io/library/node:18-alpine as runtime

# Add tini from build stage
RUN apk add --no-cache tini

# Copy the app from build stage
COPY --from=builder /app /app
WORKDIR /app

ENV NODE_ENV production

# Run as non-privileged, user "node"
USER 1000

# Expose the HTTP service under the unprivileged (>1024) http-alt port
EXPOSE 8080
CMD [ "tini", "--", "npm", "run", "start" ]
