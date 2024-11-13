FROM --platform=$BUILDPLATFORM caddy:builder AS builder
ARG TARGETOS TARGETARCH
RUN \
  --mount=type=cache,target=/root/.cache/go-build \
  --mount=type=cache,target=/go/pkg \
  GOOS=$TARGETOS GOARCH=$TARGETARCH xcaddy build v2.8.4 \
  --with github.com/abiosoft/caddy-exec@a42a5b2ae10fe60b6215489d56763fc9a9270a59 \
  --with github.com/aksdb/caddy-cgi/v2@cddc18b229db3cbc3f45c472ad6a490a9b00f8d4 \
  --with github.com/caddy-dns/cloudflare@89f16b99c18ef49c8bb470a82f895bce01cbaece \
  --with github.com/caddy-dns/route53@cdab4f43673f4ab12b5dda1c6aef8d9de44f0c86 \
  --with github.com/caddyserver/forwardproxy@02be81e69669fb6f2d69e852f58d6311635657c8 \
  --with github.com/fvbommel/caddy-combine-ip-ranges@5624d08f5f9e788816bdd877b7c81280c69b434e \
  --with github.com/fvbommel/caddy-dns-ip-range@6facda90c1f7c05ee4a5d8211acb7e50d09f5a71 \
  --with github.com/greenpau/caddy-git@v1.0.9 \
  --with github.com/greenpau/caddy-security@90049c80f2c048dfc1d493c221b9f53a1dca43d5 \
  --with github.com/greenpau/caddy-trace@v1.1.13 \
  --with github.com/mholt/caddy-dynamicdns@012a1d4347472eaf4b78826b86c8f35bda919f72 \
  --with github.com/mholt/caddy-events-exec@055bfd2e8b8247533c7a710e11301b7d1645c933 \
  --with github.com/mholt/caddy-l4@ca3e2f38f6e558e4b8120671d6d2336993d09e38 \
  --with github.com/mholt/caddy-ratelimit@d896102ddeda78822d1c2ac1e5fb06d0af9d2750 \
  --with github.com/mholt/caddy-webdav@0f2910d52a7ea15517a288a6f3f02a5e010da845 \
  --with github.com/WeidiDeng/caddy-cloudflare-ip@f53b62aa13cb7ad79c8b47aacc3f2f03989b67e5

FROM caddy:latest
COPY --from=builder /usr/bin/caddy /usr/bin/caddy
