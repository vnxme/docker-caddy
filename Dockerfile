FROM --platform=$BUILDPLATFORM caddy:builder AS builder
ARG TARGETOS TARGETARCH
RUN \
  --mount=type=cache,target=/root/.cache/go-build \
  --mount=type=cache,target=/go/pkg \
  GOOS=$TARGETOS GOARCH=$TARGETARCH xcaddy build v2.7.6 \
  --with github.com/abiosoft/caddy-exec@46a1d8879ee2d0e8762c35ee7f895bd8a7cf2116 \
  --with github.com/caddy-dns/cloudflare@2fa0c8ac916ab13ee14c836e59fec9d85857e429 \
  --with github.com/caddy-dns/route53@8e49e7546771bf6846e1531dcaff4925af5ddcde \
  --with github.com/greenpau/caddy-git@v1.0.9 \
  --with github.com/greenpau/caddy-security@v1.1.23 \
  --with github.com/greenpau/caddy-trace@v1.1.13 \
  --with github.com/mholt/caddy-dynamicdns@b7b54f0510fca7bdf748c5e3c976ec0b986b6a90 \
  --with github.com/mholt/caddy-events-exec@055bfd2e8b8247533c7a710e11301b7d1645c933 \
  --with github.com/mholt/caddy-l4@22554b119f249f9cac5626ada525cd257f2fb404 \
  --with github.com/mholt/caddy-ratelimit@89a7fece9addf6881169642d0b8a18e79d58e179 \
  --with github.com/mholt/caddy-webdav@5e0e1179b5b2144c16b5cba4ccf7876931f3a22d

FROM caddy:latest
COPY --from=builder /usr/bin/caddy /usr/bin/caddy
