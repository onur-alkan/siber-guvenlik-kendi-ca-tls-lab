# Kendi CA, TLS 1.3 ve Modern Kriptografi Laboratuvarı

**Öğrenci:** Onur Alkan  
**Öğrenci No:** 232923044  
**Ders:** Siber Güvenlik  

Bu depo, derste canlı gösterim amacıyla hazırlanmış yerel bir laboratuvar çalışmasıdır. Çalışma gerçek sistemlere yönelik değildir; yalnızca `lab.local`, `127.0.0.1` ve izole Kali sanal makinesi üzerinde gerçekleştirilmiştir.

## Kapsam

1. OpenSSL ile `prime256v1` (P-256) tabanlı kök CA oluşturma.
2. `lab.local` için EC özel anahtar, CSR ve sunucu sertifikası üretme.
3. Python ile yalnızca TLS 1.3 kullanan yerel HTTPS sunucusu.
4. Firefox'ta güvenilmeyen kök CA uyarısı ve kök CA güvenildikten sonraki başarılı bağlantı.
5. Wireshark ile TLS ClientHello/SNI ve şifreli Application Data gözlemi.
6. Ed25519 dijital imza ve değiştirilmiş mesaj doğrulama deneyi.
7. X25519 ile iki tarafın aynı ortak sırra ulaşması.
8. `sslscan` ile TLS yapılandırması kontrolü.
9. Bonus: `mitmproxy` ile kontrollü yerel MITM ve CA güven modelinin gösterilmesi.

## Proje Yapısı

```text
.
├── 00_kontrol.sh
├── 01_pki/
│   └── pki_olustur.sh
├── 02_https/
│   └── https_sunucu.py
├── 03_wireshark/
│   └── README.md
├── 04_ed25519/
│   └── ed25519_demo.py
├── 05_x25519/
│   └── x25519_demo.py
├── 06_tls_scan/
│   └── README.md
├── 07_mitm/
│   └── README.md
├── kanitlar/
├── DERSTE_DEMO.md
├── TESLIM_KONTROL.md
└── .gitignore
```

## Hızlı Başlangıç

Kali'de:

```bash
cd /media/sf_KendiCA_TLS_Lab
bash 00_kontrol.sh
bash 01_pki/pki_olustur.sh
```

`/etc/hosts` içinde aşağıdaki kayıt bulunmalıdır:

```text
127.0.0.1 lab.local
```

Sunucu:

```bash
python3 02_https/https_sunucu.py
```

Firefox:

```text
https://lab.local:8443
```

## Doğrulanan Sonuçlar

- `openssl verify -CAfile ca.crt lab.crt` → `lab.crt: OK`
- `lab.crt` SAN → `DNS:lab.local`
- Sertifika issuer → `Siber Güvenlik Ders Kök CA`
- HTTPS sunucusu yalnızca TLS 1.3
- Wireshark ClientHello → `Server Name: lab.local`
- Sonraki TLS trafiği → `Encrypted Application Data`
- Ed25519 → doğru mesaj `BASARILI`, değiştirilmiş mesaj `REDDEDILDI`
- X25519 → `Ortak anahtarlar esit mi?: True`
- sslscan → `TLS_AES_256_GCM_SHA384` tercih edilen TLS 1.3 şifre takımı
- mitmproxy CA güvenilmezken istemci bağlantıyı reddetti; geçici CA güvenildikten sonra `GET ... → 200` akışı görüldü.

## Güvenlik

Özel anahtarlar **repoya yüklenmez**. `.gitignore` aşağıdakileri engeller:

- `*.key`
- `*.csr`
- `*.srl`
- geçici mitmproxy CA dizinleri
- Python cache dosyaları
- varsayılan olarak `.pcap` / `.pcapng` yakalamaları

Bu repository yalnızca eğitim ve yetkili yerel laboratuvar ortamı içindir.
