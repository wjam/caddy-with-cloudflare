FROM caddy:2.7.6-builder-alpine AS builder

RUN xcaddy build \
    --with github.com/caddy-dns/cloudflare \
    --with github.com/mholt/caddy-dynamicdns

FROM caddy:2.7.6-alpine as main

COPY --from=builder /usr/bin/caddy /usr/bin/caddy

FROM main as test

RUN caddy list-modules | grep cloudflare
RUN touch /.test-successful

FROM main
COPY --from=test /.test-successful /
