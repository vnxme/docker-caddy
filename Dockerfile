FROM --platform=$BUILDPLATFORM caddy:builder AS builder
ARG TARGETOS TARGETARCH
RUN \
  --mount=type=cache,target=/root/.cache/go-build \
  --mount=type=cache,target=/go/pkg \
  GOOS=$TARGETOS GOARCH=$TARGETARCH xcaddy build v2.8.4 \
  --with github.com/abiosoft/caddy-exec@a42a5b2ae10fe60b6215489d56763fc9a9270a59 \
  --with github.com/aksdb/caddy-cgi/v2@cddc18b229db3cbc3f45c472ad6a490a9b00f8d4 \
  --with github.com/caddy-dns/cloudflare@d11ac0bfeab7475d8b89e2dc93f8c7a8b8859b8f \
  --with github.com/caddy-dns/route53@8e49e7546771bf6846e1531dcaff4925af5ddcde \
  --with github.com/greenpau/caddy-git@v1.0.9 \
  --with github.com/greenpau/caddy-security@90049c80f2c048dfc1d493c221b9f53a1dca43d5 \
  --with github.com/greenpau/caddy-trace@v1.1.13 \
  --with github.com/mholt/caddy-dynamicdns@012a1d4347472eaf4b78826b86c8f35bda919f72 \
  --with github.com/mholt/caddy-events-exec@055bfd2e8b8247533c7a710e11301b7d1645c933 \
  --with github.com/mholt/caddy-l4@ce9789f602eb7de74472d6b15e945181b7bcfe4a \
  --with github.com/mholt/caddy-ratelimit@9f619ad46dbd1efd7799bcbfdfbc4a4cfaae948a \
  --with github.com/mholt/caddy-webdav@0f2910d52a7ea15517a288a6f3f02a5e010da845 \
  --with github.com/WeidiDeng/caddy-cloudflare-ip@f53b62aa13cb7ad79c8b47aacc3f2f03989b67e5

FROM caddy:latest
COPY --from=builder /usr/bin/caddy /usr/bin/caddy
