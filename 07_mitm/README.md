# Kontrollü mitmproxy Deneyi

Bu deney yalnızca yerel `lab.local` laboratuvarında yapılır.

Başlatma:

```bash
rm -rf /tmp/kendica-mitmproxy
mkdir -p /tmp/kendica-mitmproxy
mitmproxy --listen-port 8080 --ssl-insecure --set confdir=/tmp/kendica-mitmproxy
```

Firefox proxy ayarı:

- HTTP Proxy: `127.0.0.1`, Port `8080`
- HTTPS Proxy: `127.0.0.1`, Port `8080`
- `No proxy for`: boş
- `network.proxy.allow_hijacking_localhost = true`
- `network.proxy.no_proxies_on = ""`

İlk aşamada geçici mitmproxy CA güvenilir değildir ve TLS el sıkışması reddedilir. Ardından:

`/tmp/kendica-mitmproxy/mitmproxy-ca-cert.cer`

Firefox Authorities bölümüne, **yalnızca laboratuvar süresince**, “Trust this CA to identify websites” seçeneğiyle eklenir. Yenilemeden sonra mitmproxy akışında:

```text
GET https://lab.local:8443/
← 200 text/html
```

görülür.

## Temizlik

- Firefox Network Settings → `No proxy`
- `network.proxy.allow_hijacking_localhost` → varsayılan/false
- `network.proxy.no_proxies_on` → Reset
- Firefox Authorities → laboratuvar mitmproxy CA → Delete or Distrust
- `rm -rf /tmp/kendica-mitmproxy`
