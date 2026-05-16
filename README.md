# WireGuard VPN (wg1)

WireGuard VPN server managed via [wg-easy](https://github.com/wg-easy/wg-easy). Serves as a VPN gateway

---

## Ports

| Port | Protocol | Purpose |
|------|----------|---------|
| `51823` | UDP | WireGuard VPN |
| `51824` | TCP | wg-easy Web UI |

---

## Prerequisites

- Docker + Docker Compose [installed](https://github.com/LtWinters9/ks-docker).
- Ports `51823/udp` and `51824/tcp` open in the firewall
- Domain `sub.domain.net` pointing to the server's public IP

---

## Configuration

Copy and edit the environment file before first run:

```bash
cp .env.example .env
nano .env
```

| Variable | Description |
|----------|-------------|
| `PORT` | Web UI port (default: `51824`) |
| `INSECURE` | Allow HTTP for the UI (`true`/`false`) |
| `INIT_USERNAME` | Admin username for first boot |
| `INIT_PASSWORD` | Admin password for first boot |
| `INIT_HOST` | Public hostname or IP for WireGuard endpoint |
| `INIT_PORT` | WireGuard UDP port (default: `51823`) |
| `INIT_DNS` | DNS pushed to VPN clients (default: Custom) |

> **After first boot:** Remove or comment out all `INIT_*` variables from `.env` to prevent the unattended setup from running again on restart.

---

## Running

```bash
# Start
docker compose up -d

# Stop
docker compose down

# View logs
docker compose logs -f wg1

# Restart
docker compose restart wg1
```

---

## Accessing the Web UI

```
http://sub.domain.net:51824
```

Or via [Caddy reverse proxy](https://github.com/LtWinters9/ks-caddy) if configured. Log in with the `INIT_USERNAME` / `INIT_PASSWORD` credentials set in `.env`.

---

## Adding VPN Clients

1. Open the web UI
2. Click **New Client**
3. Name the client and click **Create**
4. Download the config or scan the QR code on the client device

---

## Data

WireGuard config and client data is persisted at `~/.wg1-easy` on the host.

```bash
# Backup
tar -czf wg1-backup.tar.gz ~/.wg1-easy

# Restore
tar -xzf wg1-backup.tar.gz -C ~/
```
