FROM --platform=$BUILDPLATFORM caddy:builder AS builder
ARG TARGETOS TARGETARCH
RUN \
  --mount=type=cache,target=/root/.cache/go-build \
  --mount=type=cache,target=/go/pkg \
  GOOS=$TARGETOS GOARCH=$TARGETARCH xcaddy build v2.8.4 \
  --with github.com/mholt/caddy-l4=github.com/vnxme/caddy-l4@ed36f3f8a8268d2c7e7eb1503e1a43c62a11c86a

FROM caddy:latest
COPY --from=builder /usr/bin/caddy /usr/bin/caddy
