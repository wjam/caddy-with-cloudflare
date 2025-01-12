FROM golang:1.23 as builder

WORKDIR /src
COPY go.mod .
COPY go.sum .
COPY main.go .

RUN CGO_ENABLED=0 go build -o caddy -ldflags "-w -s" -trimpath -tags nobadger

FROM alpine:3.21 as main

RUN apk add --no-cache \
	ca-certificates \
	libcap \
	mailcap

RUN set -eux; \
	mkdir -p \
		/config/caddy \
		/data/caddy \
		/etc/caddy \
		/usr/share/caddy

EXPOSE 80
EXPOSE 443
EXPOSE 443/udp
EXPOSE 2019

# See https://caddyserver.com/docs/conventions#file-locations for details
ENV XDG_CONFIG_HOME /config
ENV XDG_DATA_HOME /data

WORKDIR /srv

COPY --from=builder /src/caddy /usr/bin/caddy

CMD ["caddy", "run", "--config", "/etc/caddy/Caddyfile", "--adapter", "caddyfile"]

FROM main as test

RUN caddy list-modules | grep cloudflare
RUN caddy list-modules | grep dynamic_dns
RUN touch /.test-successful

FROM main
COPY --from=test /.test-successful /
