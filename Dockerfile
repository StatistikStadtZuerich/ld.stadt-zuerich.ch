FROM node:12 as builder

# Add tini to act as PID1 for proper signal handling
ENV TINI_VERSION v0.19.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /tini
RUN chmod +x /tini

# Build the app
WORKDIR /app
COPY package.json package-lock.json ./
ENV NODE_ENV production
RUN npm ci
COPY . .

# Build runtime
FROM gcr.io/distroless/nodejs:12 as runtime

# Add tini from build stage
COPY --from=builder /tini /tini
ENTRYPOINT ["/tini", "--", "/nodejs/bin/node"]

# Copy the app from build stage
COPY --from=builder /app /app
WORKDIR /app

# RFC 3339 format
ARG BUILD_DATE
# Git commit hash
ARG COMMIT
# Should be semver
ARG VERSION

# OCI well-known labels
LABEL \
  org.opencontainers.image.created=$BUILD_DATE \
  org.opencontainers.image.authors="Zazuko GmbH" \
  org.opencontainers.image.source="https://github.com/StatistikStadtZuerich/ld.stadt-zuerich.ch" \
  org.opencontainers.image.version=$VERSION \
  org.opencontainers.image.revision=$COMMIT \
  org.opencontainers.image.vendor="Zazuko GmbH" \
  org.opencontainers.image.licenses="MIT" \
  org.opencontainers.image.title="ld.stadt-zuerich.ch" \
  org.opencontainers.image.description="Linked Data Instance of the Municipality of Zurich"

ENV NODE_ENV production

# Run as non-privileged, user "nobody"
USER 65534

# Expose the HTTP service under the unprivileged (>1024) http-alt port
EXPOSE 8080

FROM runtime as production
CMD ["./node_modules/.bin/trifid", "--config", "config.json"]

FROM runtime as develop
CMD ["./node_modules/.bin/trifid", "--config", "config.local.json"]
