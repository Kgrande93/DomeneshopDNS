# DOMENESHOP DNS Manager - grandedata.no

A self-hosted tool that automatically keeps DNS records updated at Domeneshop when the external IP changes (DDNS), and lets you manage subdomains directly from the terminal.

---

## How it works

Everything lives in a single file (`dns`) that does two things:

1. **DDNS** — Run automatically by cron every 5 minutes. Fetches the external IP via `ipify.org` and compares it with the last known IP. If the IP has changed, all A records on the account are updated automatically via the Domeneshop API.

2. **DNS management** — Lets you create, delete, and list A records directly from the terminal without having to log into the Domeneshop panel. New subdomains are created with the current external IP right away, and are kept updated automatically afterward by the DDNS job.

## Commands

List all A records:
```bash
dns list
```

Create a new subdomain with the current external IP:
```bash
dns create <subdomain>
```

Delete a subdomain:
```bash
dns delete <subdomain>
```

## Requirements

- Debian 13 (Trixie) LXC
- `curl` and `python3` (installed automatically by install.sh)
- API token and secret from Domeneshop (`domeneshop.no/admin?view=api`)

## Installation

1. Clone the repo on the LXC:

```bash
git clone https://github.com/Kgrande93/DomeneshopDNS.git
cd DomeneshopDNS
```

2. Fill in `TOKEN` and `SECRET` at the top of the `dns` file:

```bash
nano dns
```

3. Run the install script as root:

```bash
bash install.sh
```

This installs `dns` to `/usr/local/bin/`, sets up the cron job, configures the MOTD, and runs an initial test.

## Files

| File         | Description                                          |
| ------------ | ----------------------------------------------------- |
| `dns`        | Main script — handles both DDNS and DNS management    |
| `install.sh` | Installation script for a fresh Debian 13 LXC          |
| `README.md` | This file      |
| `LICENSE` | LICENSE        |

## Logging

All events are logged to `/var/log/ddns-update.log`:

```bash
tail -f /var/log/ddns-update.log
```

## Infrastructure

Runs as a minimal LXC container on Proxmox (pve1) with 1 core, 512 MB RAM, and 2 GB disk on VLAN40. Very low resource usage — the script only makes a few simple API calls every 5 minutes.

## Security

- The `dns` file has `chmod 700` so only root can read the token and secret
- Credentials stay local to the LXC and are never sent anywhere else
