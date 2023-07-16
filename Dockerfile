FROM --platform=$BUILDPLATFORM caddy:builder AS builder
ARG TARGETOS TARGETARCH
RUN GOOS=$TARGETOS GOARCH=$TARGETARCH xcaddy build \
  --with github.com/abiosoft/caddy-exec \
  --with github.com/aksdb/caddy-cgi/v2 \
  --with github.com/caddy-dns/cloudflare \
  --with github.com/caddy-dns/route53 \
  --with github.com/greenpau/caddy-git \
  --with github.com/greenpau/caddy-security \
  --with github.com/greenpau/caddy-trace \
  --with github.com/mholt/caddy-dynamicdns \
  --with github.com/mholt/caddy-events-exec \
  --with github.com/mholt/caddy-l4 \
  --with github.com/mholt/caddy-ratelimit \
  --with github.com/mholt/caddy-webdav

FROM caddy:latest
COPY --from=builder /usr/bin/caddy /usr/bin/caddy
