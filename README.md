# caddy-with-cloudflare

This repository provides a pre-built image of [caddy](https://caddyserver.com/) with added support for automatically managing DNS records in [Cloudflare](https://www.cloudflare.com/).

Example Caddyfile which requires `CLOUDFLARE_API_TOKEN`, `IPV4`, and `IPV6` environment variables:

```text
{
	admin :2019
	servers {
		metrics
	}
	dynamic_dns {
		provider cloudflare {$CLOUDFLARE_API_TOKEN}
		domains {
			root.test something
		}
		ip_source static {$IPV4} {$IPV6}
		versions ipv4 ipv6
		ttl 1h
	}
}

something.root.test {
	tls {
		dns cloudflare {$CLOUDFLARE_API_TOKEN}
	}
	reverse_proxy something:8080
}
```
