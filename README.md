# PingScript
Will show you the ping logs every 20 seconds and save as log.txt file running as service.

### Create your  script in usr/local/bin

```
sudo mkdir -p /usr/local/bin
sudo nano /usr/local/bin/ping_logger.sh
```

### Paste this into the editor this is our script file.
```
#!/bin/bash

TARGET="8.8.8.8"                      # Ping atılacak adres
LOGFILE="/var/log/ping_logger.log"    # Log dosyasının tam yolu

# Log dosyası yoksa oluştur
touch "$LOGFILE"

while true; do
  {
    echo "====== $(date '+%Y-%m-%d %H:%M:%S') ======"
    ping -c 4 "$TARGET" | tail -n 3
    echo
  } >> "$LOGFILE"

  sleep 20
done
```
#### Save and exit

### Give permission and create log file
```
sudo chmod +x /usr/local/bin/ping_logger.sh
sudo touch /var/log/ping_logger.log
```
### Creaate systemd service file

```
sudo nano /etc/systemd/system/ping-logger.service
```
### Paste this
```
[Unit]
Description=Ping logger service (8.8.8.8 her 20 saniyede bir)
After=network-online.target
Wants=network-online.target

[Service]
Type=simple
User=alperen
Group=alperen
ExecStart=/usr/local/bin/ping_logger.sh
Restart=always
RestartSec=5

# İstersen çalışma dizini:
WorkingDirectory=/home/alperen

[Install]
WantedBy=multi-user.target

```
#### Save and Exit

### Notice systemd

```
sudo systemctl daemon-reload
```
### Start service and enable auto start
```
sudo systemctl start ping-logger.service
sudo systemctl enable ping-logger.service
```

### Check system status
```
systemctl status ping-logger.service
```

### Check logfile

#### To check content
```
cat /var/log/ping_logger.log
```

#### To check live

```
tail -f /var/log/ping_logger.log
```

### To stop service or restart

#### Stop
```
sudo systemctl stop ping-logger.service
```
#### Restart
```
sudo systemctl restart ping-logger.service
```
#### To disable Auto restart 
```
sudo systemctl disable ping-logger.service
```
### To catch errors
```
journalctl -u ping-logger.service -xe
```

#### That's it for our script, don't hesitate for questions or any help.

