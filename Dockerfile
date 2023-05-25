FROM caddy:builder AS builder

RUN xcaddy build \
    --with github.com/caddy-dns/cloudflare

FROM caddy:latest

COPY --from=builder /usr/bin/caddy /usr/bin/caddy

COPY caddy.sh /root/caddy.sh
RUN chmod +x /root/caddy.sh

CMD ["/root/caddy.sh"]
