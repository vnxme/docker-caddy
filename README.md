# docker-caddy

Multi-platform Docker images of [Caddy](https://github.com/caddyserver/caddy) with a set of extra modules built in. The image is a drop-in replacement for the [official `caddy` image](https://hub.docker.com/_/caddy): same Alpine base, paths, volumes, ports and entrypoint, with a custom-built `caddy` binary.

The images are published to two registries:
- Docker Hub: [`vnxme/caddy`](https://hub.docker.com/r/vnxme/caddy)
- GitHub Container Registry: [`ghcr.io/vnxme/caddy`](https://github.com/vnxme/docker-caddy/pkgs/container/caddy)

## Platforms

- x86 64-bit (`linux/amd64`)
- ARMv8 64-bit (`linux/arm64/v8`)
- ARMv7 32-bit (`linux/arm/v7`)
- ARMv6 32-bit (`linux/arm/v6`)

## Usage

```sh
docker run -d --name caddy \
  -p 80:80 -p 443:443 -p 443:443/udp \
  -v $PWD/Caddyfile:/etc/caddy/Caddyfile \
  -v caddy_data:/data \
  -v caddy_config:/config \
  vnxme/caddy:2
```

With Docker Compose:

```yaml
services:
  caddy:
    image: vnxme/caddy:2
    restart: unless-stopped
    ports:
      - "80:80"
      - "443:443"
      - "443:443/udp"
    volumes:
      - ./Caddyfile:/etc/caddy/Caddyfile
      - caddy_data:/data
      - caddy_config:/config

volumes:
  caddy_data:
  caddy_config:
```

Keep `/data` on a persistent volume: it holds your TLS certificates and keys. To list the modules compiled into the image, run `docker run --rm vnxme/caddy caddy list-modules --skip-standard`.

## Tags

| Tag | Meaning |
|-----|---------|
| `latest`, `2`, `2.11`, `2.11.3` | The latest release, and the latest release in each major or minor line. These tags get updated base images (see below). |
| `2.11.3-1` | A re-release of the same Caddy version with updated modules |
| `2.11.3-YYYYMMDD` | A fixed snapshot of a release, built on that date. It never changes, so pin it if you need a reproducible image. |

Every week, CI checks whether the official `caddy` builder or Alpine base image for the latest release has been updated upstream, for example with Go or Alpine security fixes. If so, it rebuilds that release with the same modules, pushes it again under its version tags (`2.11.3`, `2.11`, `2`, `latest`) and adds a new dated tag. If nothing changed, nothing is pushed. Older releases are not rebuilt.
| `main` | Built from the `main` branch |
| `sha-<commit>` | Built from a specific commit |

## Modules

Besides the standard modules, Caddy is built with:

<!-- modules:start -->
- [abiosoft/caddy-exec](https://github.com/abiosoft/caddy-exec)
- [aksdb/caddy-cgi](https://github.com/aksdb/caddy-cgi)
- [caddy-dns/cloudflare](https://github.com/caddy-dns/cloudflare)
- [caddyserver/forwardproxy](https://github.com/caddyserver/forwardproxy)
- [fvbommel/caddy-combine-ip-ranges](https://github.com/fvbommel/caddy-combine-ip-ranges)
- [fvbommel/caddy-dns-ip-range](https://github.com/fvbommel/caddy-dns-ip-range)
- [greenpau/caddy-git](https://github.com/greenpau/caddy-git)
- [greenpau/caddy-security](https://github.com/greenpau/caddy-security)
- [greenpau/caddy-trace](https://github.com/greenpau/caddy-trace)
- [mholt/caddy-dynamicdns](https://github.com/mholt/caddy-dynamicdns)
- [mholt/caddy-events-exec](https://github.com/mholt/caddy-events-exec)
- [mholt/caddy-l4](https://github.com/mholt/caddy-l4)
- [mholt/caddy-ratelimit](https://github.com/mholt/caddy-ratelimit)
- [mholt/caddy-webdav](https://github.com/mholt/caddy-webdav)
- [WeidiDeng/caddy-cloudflare-ip](https://github.com/WeidiDeng/caddy-cloudflare-ip)
<!-- modules:end -->

Modules are pinned to specific commits. [Renovate](https://docs.renovatebot.com/) opens a grouped update PR every week.

## License

The build files in this repository are licensed under the [Apache License 2.0](LICENSE). Caddy and each module keep their own licenses.
