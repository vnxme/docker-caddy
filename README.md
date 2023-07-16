# docker-caddy-custom
 A custom build of Caddy with the following modules inside:
 - [abiosoft/caddy-exec](https://github.com/abiosoft/caddy-exec)
 - [aksdb/caddy-cgi/v2](https://github.com/aksdb/caddy-cgi)
 - [caddy-dns/cloudflare](https://github.com/caddy-dns/cloudflare)
 - [caddy-dns/route53](https://github.com/caddy-dns/route53)
 - [greenpau/caddy-git](https://github.com/greenpau/caddy-git)
 - [greenpau/caddy-security](https://github.com/greenpau/caddy-security)
 - [greenpau/caddy-trace](https://github.com/greenpau/caddy-trace)
 - [mholt/caddy-dynamicdns](https://github.com/mholt/caddy-dynamicdns)
 - [mholt/caddy-events-exec](https://github.com/mholt/caddy-events-exec)
 - [mholt/caddy-l4](https://github.com/mholt/caddy-l4)
 - [mholt/caddy-ratelimit](https://github.com/mholt/caddy-ratelimit)
 - [mholt/caddy-webdav](https://github.com/mholt/caddy-webdav)

### Build Environment
1. Create a headless Debian from [the current AMD64 image](https://cdimage.debian.org/debian-cd/current/amd64/iso-cd/)
2. Install Docker following [the official manual](https://docs.docker.com/engine/install/debian/)
```
apt-get update
apt-get install ca-certificates curl git gnupg
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
chmod a+r /etc/apt/keyrings/docker.gpg
echo \
  "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian \
  "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
  tee /etc/apt/sources.list.d/docker.list > /dev/null

apt-get update
apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
```
3. Prepare Buildx following [the official manual](https://docs.docker.com/build/building/multi-platform/)
```
docker run --privileged --rm tonistiigi/binfmt --install all
docker buildx create --name builder --driver docker-container --bootstrap --use
```
4. Build the container and push it to the registry with the following command
```
git clone https://github.com/vnxme/docker-caddy-custom && cd ./docker-caddy-custom
docker buildx build --platform linux/amd64,linux/arm64,linux/arm/v7 -t vnxme/caddy-custom:latest --push .
```
