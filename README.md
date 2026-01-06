# 🛰️ Ping Monitoring Service

<p align="center"> <img src="https://img.shields.io/badge/DevOps-Ping%20Monitor-blue?style=for-the-badge"/> <br/> <img src="https://github.com/Nodes-Astro/PingScript/actions/workflows/docker-image.yml/badge.svg" /> <img src="https://img.shields.io/docker/pulls/astronodes/ping-monitor" /> <img src="https://img.shields.io/docker/image-size/astronodes/ping-monitor" /> <img src="https://img.shields.io/badge/license-MIT-green" /> </p>

A lightweight ping monitoring service for both Linux (systemd) and Docker environments.
Outputs structured JSON logs, supports configurable parameters, and ships with a full CI/CD pipeline (GitHub Actions → Docker Hub).

### 🚀 Features

Bash script with JSON log output

Runs as:

✔️ Linux systemd service

✔️ Linux systemd timer

✔️ Docker container loop

Configurable environment variables

Lightweight Alpine image

Automated CI/CD pipeline (Docker build & push)

### 📦 Docker Usage

#### Pull image

```
docker pull astronodes/ping-monitor:latest
```

#### Run
```
docker run --rm \
  -e TARGET=8.8.8.8 \
  -e COUNT=3 \
  -e INTERVAL=20 \
  astronodes/ping-monitor:latest
```

#### Logs
```
docker logs -f <container_id>
```

#### Example JSON
```
{"timestamp":"2025-12-11T10:00:00+03:00","target":"8.8.8.8","success":true,"output":"PING 8.8.8.8 ..."}
```

### ⚙️ Environment Variables

| Variable | Default                             | Description            |
| -------- | ----------------------------------- | ---------------------- |
| TARGET   | 8.8.8.8                             | Ping target            |
| COUNT    | 3                                   | ICMP packets per run   |
| INTERVAL | 20                                  | Seconds between checks |
| LOG_FILE | /var/log/ping-monitor.log or stdout | Log output path        |



### 🖥️ Systemd Setup (Linux Host)

#### 1️⃣ Install script
```
sudo cp ping-monitor.sh /usr/local/bin/ping-monitor.sh
sudo chmod +x /usr/local/bin/ping-monitor.sh
```

#### 2️⃣ Create service
```
/etc/systemd/system/ping-monitor.service:

[Unit]
Description=Ping monitoring service (single run)
Wants=network-online.target
After=network-online.target

[Service]
Type=oneshot
ExecStart=/usr/local/bin/ping-monitor.sh
Environment=TARGET=8.8.8.8
Environment=LOG_FILE=/var/log/ping-monitor.log
Environment=COUNT=3
User=root
Group=root
```

#### 3️⃣ Create timer
```
/etc/systemd/system/ping-monitor.timer:

[Unit]
Description=Run ping-monitor.service every 20 seconds

[Timer]
OnUnitActiveSec=20s
Unit=ping-monitor.service
AccuracySec=1s

[Install]
WantedBy=timers.target


Enable & start:

sudo systemctl daemon-reload
sudo systemctl enable --now ping-monitor.timer
```

#### Check logs:
```
sudo tail -n 20 /var/log/ping-monitor.log
```

### 🐳 Dockerfile
```
FROM alpine:3.20

RUN apk add --no-cache bash iputils

WORKDIR /app

COPY ping-monitor.sh /app/ping-monitor.sh
RUN chmod +x /app/ping-monitor.sh

ENV TARGET=8.8.8.8
ENV COUNT=3
ENV INTERVAL=20
ENV LOG_FILE=""

CMD ["sh", "-c", "while true; do /app/ping-monitor.sh; sleep $INTERVAL; done"]
```

### 🔄 GitHub Actions CI/CD
```
.github/workflows/docker-image.yml
```
```
name: Build and Push Docker image

on:
  push:
    branches: ["main"]
  workflow_dispatch:

jobs:
  build-and-push:
    runs-on: ubuntu-latest

    steps:
      - name: Checkout repo
        uses: actions/checkout@v4

      - name: Log in to Docker Hub
        uses: docker/login-action@v3
        with:
          username: ${{ secrets.DOCKERHUB_USERNAME }}
          password: ${{ secrets.DOCKERHUB_TOKEN }}

      - name: Build Docker image
        run: |
          docker build -t astronodes/ping-monitor:latest .

      - name: Push Docker image
        run: |
          docker push astronodes/ping-monitor:latest
```

### 🗂️ Project Structure
```
.
├── ping-monitor.sh
├── Dockerfile
├── README.md
└── .github/
    └── workflows/
        └── docker-image.yml
```

### 📊 Monitoring & Observability (Prometheus + Grafana)

This project includes a production-like monitoring stack using Prometheus, Blackbox Exporter, and Grafana.

#### Stack Overview

Prometheus collects metrics

Blackbox Exporter performs ICMP (ping) probes

Grafana visualizes latency and availability

Monitoring is deployed via Docker Compose.

#### 🚀 Run Monitoring Stack
```
docker compose -f docker-compose.monitoring.yml up -d
```


#### Services:

Prometheus → http://localhost:9090

Grafana → http://localhost:3000

Credentials: admin / admin

#### 📈 Collected Metrics

##### Key metrics used in dashboards:

Key metrics used in dashboards:

probe_success

1 → target reachable

0 → target unreachable

probe_duration_seconds

Total duration of a probe (latency + processing time)

#### 🎨 Grafana Thresholds

Latency thresholds are applied to probe_duration_seconds:

| Latency    | Status      |
| ---------- | ----------- |
| < 100 ms   | 🟢 Healthy  |
| 100–300 ms | 🟡 Degraded |
| > 300 ms   | 🔴 Critical |


Thresholds are configured using Absolute values and displayed in milliseconds (ms).

#### 📊 Example PromQL Queries

Average latency per target:

```
avg by (instance) (probe_duration_seconds)
```

Availability (uptime):

```
probe_success
```
