#!/usr/bin/env bash
set -euo pipefail

TARGET=${TARGET:-8.8.8.8}
LOG_FILE="${LOG_FILE-/var/log/ping-monitor.log}"
COUNT=${COUNT:-3}

# Zaman damgası (ISO format)
TIMESTAMP="$(date -Iseconds)"

# Ping çalıştır
PING_OUTPUT="$(ping -c "$COUNT" "$TARGET" 2>&1 || true)"
EXIT_CODE=$?

# Çıktıyı tek satıra indir (satır sonlarını \n yap)
PING_OUTPUT_SINGLE_LINE="$(echo "$PING_OUTPUT" | tr '\n' '\\n' | tr '"' "'")"

if [ "$EXIT_CODE" -eq 0 ]; then
  SUCCESS=true
else
  SUCCESS=false
fi

# JSON log satırı
LOG_LINE=$(printf '{"timestamp":"%s","target":"%s","success":%s,"output":"%s"}\n' \
  "$TIMESTAMP" "$TARGET" "$SUCCESS" "$PING_OUTPUT_SINGLE_LINE")

# Eğer LOG_FILE boş değilse dosyaya yaz, yoksa stdout'a bas
if [ -n "$LOG_FILE" ]; then
  echo "$LOG_LINE" >> "$LOG_FILE"
else
  echo "$LOG_LINE"
fi

