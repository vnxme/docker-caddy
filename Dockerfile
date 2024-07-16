FROM --platform=$BUILDPLATFORM caddy:builder AS builder
ARG TARGETOS TARGETARCH
RUN \
  --mount=type=cache,target=/root/.cache/go-build \
  --mount=type=cache,target=/go/pkg \
  GOOS=$TARGETOS GOARCH=$TARGETARCH xcaddy build v2.8.4 \
  --with github.com/mholt/caddy-l4=github.com/vnxme/caddy-l4@b7f2e985551fdbdc42175413c8cce62d0eb3fd7b

FROM caddy:latest
COPY --from=builder /usr/bin/caddy /usr/bin/caddy
