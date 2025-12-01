# Ping Logger Service

Bu proje, her **20 saniyede bir** belirli bir IP adresine (varsayılan: `8.8.8.8`) ping atıp, çıkan **son 3 satırı** bir log dosyasına (`/var/log/ping_logger.log`) kaydeden bir bash script ve systemd servis dosyası içerir.

Script hem manuel olarak çalıştırılabilir hem de bir **systemd servisi** olarak sistem açılışında otomatik başlatılabilir.

---

## 🚀 Özellikler
- Her 20 saniyede bir ping atar  
- Ping çıktısının sadece son 3 satırını loglar  
- Zaman damgası ekler  
- Log dosyasını `/var/log/` altında tutar  
- systemd servisi olarak otomatik çalışabilir  
- Script herkes tarafından indirilebilir ve kullanılabilir  

---

## 📥 Scripti İndir (Raw Link)

Aşağıdaki komutla script’i direkt indirebilirsiniz:

```
wget https://raw.githubusercontent.com/Nodes-Astro/PingScript/main/ping_logger.sh -O ping_logger.sh
chmod +x ping_logger.sh
```

### Manuel çalıştırmak için
```
 ./ping_logger.sh
```

🛠️ Systemd Servisi Olarak Kurulum

Script’i sistem servisi olarak çalıştırmak için aşağıdaki adımları takip edin:

1) Script’i kalıcı dizine taşı
```
sudo mv ping_logger.sh /usr/local/bin/ping_logger.sh
sudo chmod +x /usr/local/bin/ping_logger.sh
```

3) systemd servis dosyasını oluşturun
```
sudo bash -c 'cat <<EOF > /etc/systemd/system/ping-logger.service
[Unit]
Description=Ping Logger Service
After=network-online.target
Wants=network-online.target

[Service]
Type=simple
User=root
ExecStart=/usr/local/bin/ping_logger.sh
Restart=always
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF'
```
3) Servisi aktif hale getirin
```
sudo systemctl daemon-reload
sudo systemctl enable --now ping-logger.service
```
🔍 Servis Yönetim Komutları

Servis durumu:
```
systemctl status ping-logger.service
```

Servisi durdur:
```
sudo systemctl stop ping-logger.service
```

Yeniden başlat:
```
sudo systemctl restart ping-logger.service
```

Logları canlı izle:
```
tail -f /var/log/ping_logger.log
```
📌 Notlar

Script root kullanıcı ile çalıştığı için log dosyasına yazma sorunu yaşanmaz.

IP adresi ve sleep süresi script içinde düzenlenebilir.

systemd servisi otomatik olarak çökerse yeniden başlama özelliğine sahiptir.

