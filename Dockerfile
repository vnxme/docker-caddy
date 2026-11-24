# syntax=docker/dockerfile:1

# Single source of truth for the Caddy version: it selects both base images
# and the Caddy release that xcaddy builds. Updated by Renovate.
ARG CADDY_VERSION=2.11.9

FROM --platform=$BUILDPLATFORM caddy:${CADDY_VERSION}-builder AS builder
ARG TARGETOS TARGETARCH TARGETVARIANT
ENV CGO_ENABLED=0
# xcaddy builds the release named by the builder image's own CADDY_VERSION
# env (e.g. v2.11.3), which always matches the image tag selected above.
RUN \
  --mount=type=cache,target=/root/.cache/go-build \
  --mount=type=cache,target=/go/pkg \
  # Go defaults to GOARM=7 when cross-compiling, so pass the variant
  # explicitly or linux/arm/v6 would get an ARMv7 binary.
  if [ "$TARGETARCH" = "arm" ]; then export GOARM="${TARGETVARIANT#v}"; fi; \
  GOOS=$TARGETOS GOARCH=$TARGETARCH xcaddy build \
  --with github.com/abiosoft/caddy-exec@521d8736cb4d1ce7f5b8bf8be6f3a2c9ecad843c \
  --with github.com/aksdb/caddy-cgi/v2@8c1c76069394f05a44fb99a91b792d7f6b18e66b \
  --with github.com/caddy-dns/cloudflare@a8737d095ad5a48ca031cea6ab704057dbc2d250 \
  --with github.com/caddyserver/forwardproxy@0aab84dad4fc2830789f34e27b4d7bc22a40889e \
  --with github.com/fvbommel/caddy-combine-ip-ranges@5624d08f5f9e788816bdd877b7c81280c69b434e \
  --with github.com/fvbommel/caddy-dns-ip-range@f6ba728e351ac4f6bddbb56d3638f8b13445819c \
  --with github.com/greenpau/caddy-git@e1241f5a070ca449ad4bdbc376099cae465f331d \
  --with github.com/greenpau/caddy-security@e03784fa058152e464dcdd2fd1396f43a0b56e7d \
  --with github.com/greenpau/caddy-trace@b849748ae8ff2e3a1c2c92b382cdc73f3d94dca0 \
  --with github.com/mholt/caddy-dynamicdns@1af4f88765982db86ce091eeb075cfb2d9348dc8 \
  --with github.com/mholt/caddy-events-exec@3a351bf9c023b8f9305aaceaa5bf004b31a0ca3d \
  --with github.com/mholt/caddy-l4@45e9c728448b3109dff3e342321a3ad3eda5de64 \
  --with github.com/mholt/caddy-ratelimit@16aecbbcb8ca07dc1c671e263379606ff9493c55 \
  --with github.com/mholt/caddy-webdav@fa2f366b0d75e54c2e381c0aefc3a8df8bf5794b \
  --with github.com/WeidiDeng/caddy-cloudflare-ip@f53b62aa13cb7ad79c8b47aacc3f2f03989b67e5

FROM caddy:${CADDY_VERSION}-alpine
COPY --from=builder /usr/bin/caddy /usr/bin/caddy
