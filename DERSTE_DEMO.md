# DERSTE CANLI DEMO AKIŞI

Bu dosya, derste doğrudan takip edilecek kısa akıştır.

## 0. Başlamadan Önce

Kali açık, Host-only ağ aktif, internet gerekmiyor.

```bash
cd /media/sf_KendiCA_TLS_Lab
bash 00_kontrol.sh
```

`lab.local` kontrolü:

```bash
getent hosts lab.local
```

Beklenen:

```text
127.0.0.1       lab.local
```

Yoksa:

```bash
echo "127.0.0.1 lab.local" | sudo tee -a /etc/hosts
```

---

## 1. Kendi Kök CA'mı ve lab.local Sertifikasını Oluşturuyorum

```bash
bash 01_pki/pki_olustur.sh
```

Hocaya gösterilecek kritik satırlar:

```text
lab.crt: OK
subject=CN=lab.local
issuer=CN=Siber Güvenlik Ders Kök CA
DNS:lab.local
TLS Web Server Authentication
```

Anlatım:
- CA ve sunucu anahtarları EC P-256 (`prime256v1`).
- `lab.local` sertifikasını kendi kök CA'm imzalıyor.
- SAN alanında `DNS:lab.local` var.

---

## 2. HTTPS Sunucusunu Açıyorum

Terminal 1:

```bash
python3 02_https/https_sunucu.py
```

Beklenen:

```text
HTTPS sunucusu çalışıyor:
  https://lab.local:8443
  Yalnızca TLS 1.3
```

Firefox:

```text
https://lab.local:8443
```

### 2A. CA güvenilmezken

Firefox sertifika uyarısını göster.

Anlatım:
> Sunucu sertifikasını kendi CA'm imzaladı ama tarayıcı henüz bu kök CA'ya güvenmediği için bağlantıyı güvenilir kabul etmiyor.

### 2B. Kök CA'yı güvenilir yap

Firefox:
`Settings → Privacy & Security → Certificates → View Certificates → Authorities → Import`

Dosya:

```text
/media/sf_KendiCA_TLS_Lab/01_pki/ca.crt
```

`Trust this CA to identify websites` → işaretle.

Sayfayı yenile.

Anlatım:
> Aynı sertifika artık güvenilir çünkü imzalayan kök CA'yı tarayıcının güven deposuna ekledim.

---

## 3. Wireshark: ClientHello Açık, Sonraki Veri Şifreli

Wireshark → `Loopback: lo`

Display filter:

```text
tcp.port == 8443
```

Firefox'ta yeni bağlantı oluştur.

ClientHello filtresi:

```text
tls.handshake.type == 1
```

Paket:
`Transport Layer Security → Handshake Protocol: Client Hello → Extension: server_name`

Göster:

```text
Server Name: lab.local
```

Anlatım:
> Bu laboratuvarda SNI, ClientHello içinde açık görülüyor.

Sonra tekrar:

```text
tcp.port == 8443
```

`TLSv1.3 Application Data` paketini seç.

Göster:

```text
Encrypted Application Data
```

Anlatım:
> Uygulama verisi artık düz metin değil; TLS tarafından şifrelenmiş.

---

## 4. Ed25519 Dijital İmza

```bash
python3 04_ed25519/ed25519_demo.py
```

Göster:

```text
Dogrulama: BASARILI
Degistirilmis mesaj: REDDEDILDI
```

Anlatım:
> Ed25519 ile mesajı imzalıyorum. Orijinal mesaj doğrulanıyor; mesaj değiştirilince aynı imza geçersiz oluyor.

---

## 5. X25519 Anahtar Değişimi

```bash
python3 05_x25519/x25519_demo.py
```

Göster:

```text
Alice shared: ...
Bob shared:   ...
Ortak anahtarlar esit mi?: True
```

Anlatım:
> Alice ve Bob farklı özel/açık anahtarlara sahip. Karşı tarafın açık anahtarını kullanarak bağımsız biçimde aynı ortak sırra ulaşıyorlar.

---

## 6. sslscan

HTTPS sunucusu çalışırken:

```bash
sslscan 127.0.0.1:8443
```

Gösterilecekler:

```text
TLSv1.3 enabled
Preferred TLSv1.3 ... TLS_AES_256_GCM_SHA384
Subject: lab.local
Issuer: Siber Güvenlik Ders Kök CA
ECC Curve Name: prime256v1
```

---

## 7. Bonus: mitmproxy ile Kontrollü MITM

Yalnızca bu yerel lab için:

```bash
rm -rf /tmp/kendica-mitmproxy
mkdir -p /tmp/kendica-mitmproxy
mitmproxy --listen-port 8080 --ssl-insecure --set confdir=/tmp/kendica-mitmproxy
```

Firefox proxy:
- HTTP/HTTPS `127.0.0.1:8080`
- `No proxy for`: boş
- `network.proxy.allow_hijacking_localhost = true`
- `network.proxy.no_proxies_on = ""`

İlk denemede Events ekranında istemci proxy sertifikasına güvenmediği için TLS hatasını göster.

Geçici CA:

```text
/tmp/kendica-mitmproxy/mitmproxy-ca-cert.cer
```

Firefox Authorities'a laboratuvar süresince ekle.

Yenile ve mitmproxy'de göster:

```text
GET https://lab.local:8443/
← 200 text/html
```

Anlatım:
> HTTPS tek başına, istemcinin yanlış bir kök CA'ya güvenmesi durumunu çözmez. Güven zinciri kritik önemdedir.

---

## 8. Demo Sonu Temizlik

- Firefox → Network Settings → `No proxy`
- Laboratuvar kök CA ve mitmproxy CA → `Delete or Distrust`
- `network.proxy.allow_hijacking_localhost` → `false/default`
- `network.proxy.no_proxies_on` → Reset
- mitmproxy → `q`
- HTTPS sunucusu → `Ctrl+C`
- geçici MITM dosyaları:

```bash
rm -rf /tmp/kendica-mitmproxy
```

Dersten önce CA'ların kaldırılmış olması önemlidir; aksi halde ilk Firefox uyarısı görünmez.
