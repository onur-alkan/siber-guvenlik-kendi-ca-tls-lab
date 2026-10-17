# Teslim / Demo Kontrol Listesi

- [x] P-256 kök CA üretildi.
- [x] `lab.local` sertifikası kendi CA ile imzalandı.
- [x] SAN alanında `DNS:lab.local` doğrulandı.
- [x] Python HTTPS sunucusu TLS 1.3 ile çalıştı.
- [x] Firefox CA güvenilmezken uyarı verdi.
- [x] Kök CA güvenildikten sonra sayfa uyarısız açıldı.
- [x] Wireshark ClientHello içinde `Server Name: lab.local` görüldü.
- [x] Wireshark'ta sonraki veri `Encrypted Application Data` olarak görüldü.
- [x] Ed25519 doğru mesajı doğruladı, değiştirilmiş mesajı reddetti.
- [x] X25519 Alice ve Bob için aynı ortak sır üretildi.
- [x] sslscan ile TLS 1.3 ve sertifika özellikleri doğrulandı.
- [x] mitmproxy laboratuvarında CA güvenilmezken reddetme gözlendi.
- [x] Geçici mitmproxy CA güvenildikten sonra HTTP akışı `200` olarak görüldü.
- [x] Demo sonrası proxy/CA temizliği yapıldı.
- [ ] Dersten hemen önce `DERSTE_DEMO.md` üzerinden kuru prova yapılacak.
