FROM alpine:3.20

# Ping için iputils ekle
RUN apk add --no-cache bash iputils

WORKDIR /app

# Script'i kopyala
COPY ping-monitor.sh /app/ping-monitor.sh
RUN chmod +x /app/ping-monitor.sh

# Varsayılan ortam değişkenleri
ENV TARGET=8.8.8.8
ENV COUNT=3
ENV INTERVAL=20
# Container'da LOG_FILE boş kalsın, stdout'a loglayalım
ENV LOG_FILE=""

# Container içinde basit bir loop: her INTERVAL saniyede bir script çalıştır
CMD ["sh", "-c", "while true; do /app/ping-monitor.sh; sleep $INTERVAL; done"]
