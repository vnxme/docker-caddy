FROM --platform=$BUILDPLATFORM caddy:builder AS builder
ARG TARGETOS TARGETARCH
RUN \
  --mount=type=cache,target=/root/.cache/go-build \
  --mount=type=cache,target=/go/pkg \
  GOOS=$TARGETOS GOARCH=$TARGETARCH xcaddy build v2.10.0 \
  --with github.com/abiosoft/caddy-exec@521d8736cb4d1ce7f5b8bf8be6f3a2c9ecad843c \
  --with github.com/aksdb/caddy-cgi/v2@c523eea54b2ac1c65be6d9a947cd8f29a585d3f1 \
  --with github.com/caddy-dns/cloudflare@006ebb07b34945b53dd0bb31a7a823ef2e8ccc56 \
  --with github.com/caddyserver/forwardproxy@b9def71846e5992b314c96a6fe66a05485ac66a5 \
  --with github.com/fvbommel/caddy-combine-ip-ranges@5624d08f5f9e788816bdd877b7c81280c69b434e \
  --with github.com/fvbommel/caddy-dns-ip-range@6facda90c1f7c05ee4a5d8211acb7e50d09f5a71 \
  --with github.com/greenpau/caddy-git@e1241f5a070ca449ad4bdbc376099cae465f331d \
  --with github.com/greenpau/caddy-security@83609dec14a46dfd5749dea0b08a03c283bd1114 \
  --with github.com/greenpau/caddy-trace@b849748ae8ff2e3a1c2c92b382cdc73f3d94dca0 \
  --with github.com/mholt/caddy-dynamicdns@bc90ac0e772f8ed9a908570d135eac5cb3b143db \
  --with github.com/mholt/caddy-events-exec@3a351bf9c023b8f9305aaceaa5bf004b31a0ca3d \
  --with github.com/mholt/caddy-l4@87e3e5e2c7f986b34c0df373a5799670d7b8ca03 \
  --with github.com/mholt/caddy-ratelimit@a8e9f68d7bedc7ddb0c5bb93d6d32d8cf75fcc9f \
  --with github.com/mholt/caddy-webdav@42168ba04c9dc2cd228ab8c453dbab27654e52e6 \
  --with github.com/WeidiDeng/caddy-cloudflare-ip@f53b62aa13cb7ad79c8b47aacc3f2f03989b67e5

FROM caddy:latest
COPY --from=builder /usr/bin/caddy /usr/bin/caddy
