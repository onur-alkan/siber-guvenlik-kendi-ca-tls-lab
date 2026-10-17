#!/usr/bin/env bash
set -u

echo "=== Ortam Kontrolü ==="
for cmd in openssl python3 wireshark sslscan mitmproxy; do
  if command -v "$cmd" >/dev/null 2>&1; then
    echo "[OK] $cmd -> $(command -v "$cmd")"
  else
    echo "[EKSIK] $cmd"
  fi
done

python3 - <<'PY'
try:
    import cryptography
    print("[OK] Python cryptography:", cryptography.__version__)
except Exception as exc:
    print("[EKSIK] Python cryptography:", exc)
PY
