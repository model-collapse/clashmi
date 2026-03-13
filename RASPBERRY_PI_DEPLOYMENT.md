# Deploy Mihomo Proxy Server to Raspberry Pi Zero

## What You Need
- Raspberry Pi Zero (ARMv6 architecture)
- SSH access to your Pi
- Basic Clash/Mihomo configuration file

## Quick Deployment

### 1. Download Mihomo Binary for ARMv6

On your Raspberry Pi Zero:
```bash
# Download ARMv6 binary
wget https://github.com/MetaCubeX/mihomo/releases/download/v1.19.21/mihomo-linux-armv6-v1.19.21.gz

# Extract
gunzip mihomo-linux-armv6-v1.19.21.gz

# Make executable
chmod +x mihomo-linux-armv6-v1.19.21

# Move to /usr/local/bin
sudo mv mihomo-linux-armv6-v1.19.21 /usr/local/bin/mihomo
```

### 2. Create Configuration Directory

```bash
sudo mkdir -p /etc/mihomo
sudo mkdir -p /var/log/mihomo
```

### 3. Create Basic Config File

Create `/etc/mihomo/config.yaml`:
```yaml
port: 7890
socks-port: 7891
allow-lan: true
mode: rule
log-level: info
external-controller: 0.0.0.0:9090

dns:
  enable: true
  listen: 0.0.0.0:53
  default-nameserver:
    - 1.1.1.1
    - 8.8.8.8
  nameserver:
    - https://cloudflare-dns.com/dns-query
    - https://dns.google/dns-query

proxies:
  - name: "your-proxy-name"
    type: ss  # or vmess, trojan, etc.
    server: your-server.com
    port: 443
    cipher: aes-256-gcm
    password: "your-password"

proxy-groups:
  - name: PROXY
    type: select
    proxies:
      - your-proxy-name
      - DIRECT

rules:
  - DOMAIN-SUFFIX,google.com,PROXY
  - DOMAIN-SUFFIX,youtube.com,PROXY
  - GEOIP,CN,DIRECT
  - MATCH,PROXY
```

### 4. Create Systemd Service

Create `/etc/systemd/system/mihomo.service`:
```ini
[Unit]
Description=Mihomo Proxy Server
After=network.target

[Service]
Type=simple
User=root
ExecStart=/usr/local/bin/mihomo -d /etc/mihomo
Restart=on-failure
RestartSec=5s

[Install]
WantedBy=multi-user.target
```

### 5. Start Service

```bash
# Reload systemd
sudo systemctl daemon-reload

# Enable on boot
sudo systemctl enable mihomo

# Start now
sudo systemctl start mihomo

# Check status
sudo systemctl status mihomo

# View logs
sudo journalctl -u mihomo -f
```

### 6. Configure Network (Optional)

To use as transparent proxy for your network:

**A) Set Pi as DNS server** - Point devices to Pi's IP for DNS

**B) Set as HTTP/SOCKS proxy** - Configure devices to use:
- HTTP: `http://pi-ip:7890`
- SOCKS5: `socks5://pi-ip:7891`

**C) Use RESTful API** - Access dashboard at `http://pi-ip:9090/ui`

## Configuration Management

### Update Configuration
```bash
sudo nano /etc/mihomo/config.yaml
sudo systemctl restart mihomo
```

### Add Subscriptions
```yaml
proxy-providers:
  my-provider:
    type: http
    url: "https://your-subscription-url"
    interval: 3600
    path: ./providers/my-provider.yaml
    health-check:
      enable: true
      url: http://www.gstatic.com/generate_204
      interval: 300
```

### View Logs
```bash
sudo journalctl -u mihomo -f
sudo tail -f /var/log/mihomo/mihomo.log
```

## Alternative: Use Pre-built DEB Package

```bash
# Download DEB package
wget https://github.com/MetaCubeX/mihomo/releases/download/v1.19.21/mihomo-linux-armv6-v1.19.21.deb

# Install
sudo dpkg -i mihomo-linux-armv6-v1.19.21.deb

# The package should auto-configure service
```

## Testing

```bash
# Test HTTP proxy
curl -x http://localhost:7890 https://www.google.com

# Test SOCKS5 proxy
curl --socks5 localhost:7891 https://www.google.com

# Test API
curl http://localhost:9090/version
```

## Troubleshooting

### Service won't start
```bash
# Check logs
sudo journalctl -u mihomo -n 50 --no-pager

# Check config syntax
/usr/local/bin/mihomo -d /etc/mihomo -t
```

### Permission errors
```bash
sudo chown -R root:root /etc/mihomo
sudo chmod 644 /etc/mihomo/config.yaml
```

### Port already in use
```bash
# Check what's using the port
sudo netstat -tulpn | grep :7890
```

## Advanced: Web Dashboard

Mihomo includes a web dashboard. To enable:

1. Download dashboard:
```bash
cd /etc/mihomo
sudo wget https://github.com/MetaCubeX/Yacd-meta/archive/gh-pages.zip
sudo unzip gh-pages.zip
sudo mv Yacd-meta-gh-pages ui
```

2. Access at: `http://pi-ip:9090/ui`

## Resources

- Mihomo Documentation: https://wiki.metacubex.one/
- Mihomo GitHub: https://github.com/MetaCubeX/mihomo
- Config Examples: https://github.com/MetaCubeX/mihomo/tree/Alpha/docs/config.yaml

## Notes

- Raspberry Pi Zero has limited RAM (512MB) - keep config simple
- No Flutter, no GUI needed - pure CLI operation
- Uses ~50-100MB RAM in typical operation
- Can handle 100+ concurrent connections easily on Pi Zero
