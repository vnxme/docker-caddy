FROM --platform=$BUILDPLATFORM caddy:builder AS builder
ARG TARGETOS TARGETARCH
RUN \
  --mount=type=cache,target=/root/.cache/go-build \
  --mount=type=cache,target=/go/pkg \
  GOOS=$TARGETOS GOARCH=$TARGETARCH xcaddy build v2.7.5 \
  --with github.com/abiosoft/caddy-exec@46a1d8879ee2d0e8762c35ee7f895bd8a7cf2116 \
  --with github.com/caddy-dns/cloudflare@737bf003fe8af81814013a01e981dc8faea44c07 \
  --with github.com/caddy-dns/route53@8e49e7546771bf6846e1531dcaff4925af5ddcde \
  --with github.com/greenpau/caddy-git@v1.0.9 \
  --with github.com/greenpau/caddy-security@v1.1.20 \
  --with github.com/greenpau/caddy-trace@v1.1.12 \
  --with github.com/mholt/caddy-dynamicdns@1617db4ea2574090dc140b1285a177f69f4f9806 \
  --with github.com/mholt/caddy-events-exec@a5d053d9cd44b956f36a6ccfd3c0e0adf16cc7f1 \
  --with github.com/mholt/caddy-l4@750e3929d946690d7c5fb361c5e29fee495dc4db \
  --with github.com/mholt/caddy-ratelimit@2dc0d586f0b87e983757c403bc0929ddeb84a537 \
  --with github.com/mholt/caddy-webdav@75a603bc69789413e4213ac746906d4357883929

FROM caddy:latest
COPY --from=builder /usr/bin/caddy /usr/bin/caddy
