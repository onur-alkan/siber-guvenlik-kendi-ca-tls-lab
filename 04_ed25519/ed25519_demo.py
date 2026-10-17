from cryptography.hazmat.primitives.asymmetric.ed25519 import Ed25519PrivateKey
from cryptography.exceptions import InvalidSignature

message = b"Siber Guvenlik Dersi - Onur Alkan - 232923044"

private_key = Ed25519PrivateKey.generate()
public_key = private_key.public_key()
signature = private_key.sign(message)

print("=== Ed25519 Dijital Imza Demo ===")
print("Mesaj:", message.decode())
print("Imza (hex):", signature.hex())

try:
    public_key.verify(signature, message)
    print("Dogrulama: BASARILI")
except InvalidSignature:
    print("Dogrulama: BASARISIZ")

tampered = b"Siber Guvenlik Dersi - Degistirilmis Mesaj"

try:
    public_key.verify(signature, tampered)
    print("Degistirilmis mesaj: HATALI SEKILDE KABUL EDILDI")
except InvalidSignature:
    print("Degistirilmis mesaj: REDDEDILDI")
