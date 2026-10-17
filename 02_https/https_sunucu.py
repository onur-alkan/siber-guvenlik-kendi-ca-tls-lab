from http.server import HTTPServer, BaseHTTPRequestHandler
import ssl
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
CERT = ROOT / "01_pki" / "lab.crt"
KEY = ROOT / "01_pki" / "lab.key"

class Handler(BaseHTTPRequestHandler):
    def do_GET(self):
        html = """<!doctype html>
<html lang="tr">
<head>
    <meta charset="utf-8">
    <title>Kendi CA TLS Laboratuvarı</title>
</head>
<body>
    <h1>Kendi CA TLS Laboratuvarı</h1>
    <p><strong>Öğrenci:</strong> Onur Alkan</p>
    <p><strong>Öğrenci No:</strong> 232923044</p>
    <p><strong>Alan adı:</strong> lab.local</p>
    <p>Bu HTTPS sunucusunun sertifikası kendi oluşturduğum kök CA tarafından imzalanmıştır.</p>
</body>
</html>"""
        data = html.encode("utf-8")
        self.send_response(200)
        self.send_header("Content-Type", "text/html; charset=utf-8")
        self.send_header("Content-Length", str(len(data)))
        self.end_headers()
        self.wfile.write(data)

    def log_message(self, fmt, *args):
        print("[HTTP]", fmt % args)

server = HTTPServer(("127.0.0.1", 8443), Handler)

context = ssl.SSLContext(ssl.PROTOCOL_TLS_SERVER)
context.minimum_version = ssl.TLSVersion.TLSv1_3
context.maximum_version = ssl.TLSVersion.TLSv1_3
context.load_cert_chain(certfile=CERT, keyfile=KEY)

server.socket = context.wrap_socket(server.socket, server_side=True)

print("HTTPS sunucusu çalışıyor:")
print("  https://lab.local:8443")
print("  Yalnızca TLS 1.3")
print("Durdurmak için Ctrl+C")

try:
    server.serve_forever()
except KeyboardInterrupt:
    print("\nSunucu durduruldu.")
finally:
    server.server_close()
