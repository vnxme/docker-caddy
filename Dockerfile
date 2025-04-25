FROM --platform=$BUILDPLATFORM caddy:builder AS builder
ARG TARGETOS TARGETARCH
RUN \
  --mount=type=cache,target=/root/.cache/go-build \
  --mount=type=cache,target=/go/pkg \
  GOOS=$TARGETOS GOARCH=$TARGETARCH xcaddy build v2.9.1 \
  --with github.com/abiosoft/caddy-exec@521d8736cb4d1ce7f5b8bf8be6f3a2c9ecad843c \
  --with github.com/aksdb/caddy-cgi/v2@1007290b4939ba90b9235505783b84a93c0ec04b \
  --with github.com/caddy-dns/cloudflare@89f16b99c18ef49c8bb470a82f895bce01cbaece \
  --with github.com/caddy-dns/route53@94b571790e968b09916dc95cc521bc1c2327f7d1 \
  --with github.com/caddyserver/forwardproxy@02be81e69669fb6f2d69e852f58d6311635657c8 \
  --with github.com/fvbommel/caddy-combine-ip-ranges@5624d08f5f9e788816bdd877b7c81280c69b434e \
  --with github.com/fvbommel/caddy-dns-ip-range@6facda90c1f7c05ee4a5d8211acb7e50d09f5a71 \
  --with github.com/greenpau/caddy-git@e1241f5a070ca449ad4bdbc376099cae465f331d \
  --with github.com/greenpau/caddy-security@90049c80f2c048dfc1d493c221b9f53a1dca43d5 \
  --with github.com/greenpau/caddy-trace@b849748ae8ff2e3a1c2c92b382cdc73f3d94dca0 \
  --with github.com/mholt/caddy-dynamicdns@7c818ab3fc3485a72a346f85c77810725f19f9cf \
  --with github.com/mholt/caddy-events-exec@055bfd2e8b8247533c7a710e11301b7d1645c933 \
  --with github.com/mholt/caddy-l4@87e3e5e2c7f986b34c0df373a5799670d7b8ca03 \
  --with github.com/mholt/caddy-ratelimit@12435ecef5dbb1b137eb68002b85d775a9d5cdb2 \
  --with github.com/mholt/caddy-webdav@42168ba04c9dc2cd228ab8c453dbab27654e52e6 \
  --with github.com/WeidiDeng/caddy-cloudflare-ip@f53b62aa13cb7ad79c8b47aacc3f2f03989b67e5

FROM caddy:latest
COPY --from=builder /usr/bin/caddy /usr/bin/caddy
