#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")"

echo "[1/4] Kök CA oluşturuluyor (EC prime256v1 / P-256)..."
openssl req -x509 -newkey ec \
  -pkeyopt ec_paramgen_curve:prime256v1 \
  -nodes \
  -keyout ca.key \
  -out ca.crt \
  -days 30 \
  -utf8 \
  -subj "/CN=Siber Güvenlik Ders Kök CA"

echo "[2/4] lab.local için EC anahtar ve CSR oluşturuluyor..."
openssl req -new -newkey ec \
  -pkeyopt ec_paramgen_curve:prime256v1 \
  -nodes \
  -keyout lab.key \
  -out lab.csr \
  -subj "/CN=lab.local" \
  -addext "subjectAltName=DNS:lab.local" \
  -addext "extendedKeyUsage=serverAuth"

echo "[3/4] Sunucu sertifikası kendi CA'mızla imzalanıyor..."
openssl x509 -req \
  -in lab.csr \
  -CA ca.crt \
  -CAkey ca.key \
  -CAcreateserial \
  -out lab.crt \
  -days 30 \
  -copy_extensions copy

echo "[4/4] Doğrulama..."
openssl verify -CAfile ca.crt lab.crt
openssl x509 -in lab.crt -noout -subject -issuer -ext subjectAltName -ext extendedKeyUsage

echo
echo "Bitti. Üretilen özel anahtarlar GitHub'a yüklenmemelidir."
