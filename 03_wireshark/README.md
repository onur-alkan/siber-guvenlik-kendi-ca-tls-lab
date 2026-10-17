# Wireshark TLS İncelemesi

Sunucu `127.0.0.1:8443` üzerinde çalıştığı için `lo` (Loopback) arayüzü dinlenir.

1. Capture filtresi yerine yakalama sırasında display filter olarak `tcp.port == 8443` kullanılabilir.
2. Yeni bir Firefox bağlantısı oluşturulur: `https://lab.local:8443`
3. ClientHello için: `tls.handshake.type == 1`
4. Paket ayrıntısında `Extension: server_name` altında `Server Name: lab.local` gösterilir.
5. Daha sonraki `TLSv1.3 Application Data` paketinde `Encrypted Application Data` görülür; HTTP gövdesi düz metin olarak görünmez.

> Not: Bu laboratuvarda SNI, ClientHello içinde açık görülmüştür. Encrypted ClientHello (ECH) kullanılan yapılarda bu gözlem farklı olabilir.
