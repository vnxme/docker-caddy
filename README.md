# docker-caddy-custom
 A custom build of Caddy with the following modules inside:
 - Cloudflare DNS

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
docker buildx build --platform linux/amd64,linux/arm64,linux/arm/v7 -t vnxme/caddy-custom:latest --push .
```
