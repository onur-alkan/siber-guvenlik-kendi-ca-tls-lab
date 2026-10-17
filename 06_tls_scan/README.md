# sslscan

HTTPS sunucusu çalışırken:

```bash
sslscan 127.0.0.1:8443
```

Bu laboratuvarda doğrulanan başlıca sonuçlar:

- TLS 1.3 etkin.
- Tercih edilen şifre takımı: `TLS_AES_256_GCM_SHA384`
- Kabul edilen diğer TLS 1.3 şifre takımları:
  - `TLS_CHACHA20_POLY1305_SHA256`
  - `TLS_AES_128_GCM_SHA256`
- Sertifika konusu: `lab.local`
- Issuer: `Siber Güvenlik Ders Kök CA`
- İmza: `ecdsa-with-SHA256`
- EC eğrisi: `prime256v1`
