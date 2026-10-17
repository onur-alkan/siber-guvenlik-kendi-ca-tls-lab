from cryptography.hazmat.primitives.asymmetric.x25519 import X25519PrivateKey
from cryptography.hazmat.primitives import serialization

alice_private = X25519PrivateKey.generate()
alice_public = alice_private.public_key()

bob_private = X25519PrivateKey.generate()
bob_public = bob_private.public_key()

alice_shared = alice_private.exchange(bob_public)
bob_shared = bob_private.exchange(alice_public)

alice_pub_bytes = alice_public.public_bytes(
    encoding=serialization.Encoding.Raw,
    format=serialization.PublicFormat.Raw
)
bob_pub_bytes = bob_public.public_bytes(
    encoding=serialization.Encoding.Raw,
    format=serialization.PublicFormat.Raw
)

print("=== X25519 Anahtar Degisimi Demo ===")
print("Alice public key:", alice_pub_bytes.hex())
print("Bob public key:  ", bob_pub_bytes.hex())
print("Alice shared:    ", alice_shared.hex())
print("Bob shared:      ", bob_shared.hex())
print("Ortak anahtarlar esit mi?:", alice_shared == bob_shared)
