#!/bin/bash
# install.sh
# Installation script for DNS Manager on a fresh Debian 13 LXC
# Run as root: bash install.sh
set -e
echo "=== DNS Manager - installation ==="
echo ""
# Install dependencies
apt-get update && apt-get install -y curl python3
# Copy the dns script
cp dns /usr/local/bin/dns
chmod 700 /usr/local/bin/dns
# Create required directories and files
mkdir -p /var/cache
touch /var/log/ddns-update.log
# Set up cron every 5 minutes
echo "*/5 * * * * root /usr/local/bin/dns --ddns" > /etc/cron.d/ddns-update
chmod 644 /etc/cron.d/ddns-update
# Set MOTD
cat > /etc/motd << 'MOTD'
╔═══════════════════════════════════════════════╗
║           DNS Manager - grandedata.no         ║
╠═══════════════════════════════════════════════╣
║                                               ║
║  dns list               List all A records    ║
║  dns create <name>      Create subdomain      ║
║  dns delete <name>      Delete subdomain      ║
║                                               ║
║  Example:                                     ║
║    dns create uptime                          ║
║    dns delete uptime                          ║
║                                               ║
║  Log: tail -f /var/log/ddns-update.log        ║
║                                               ║
╚═══════════════════════════════════════════════╝
MOTD
# Run an initial DDNS update to test
echo "Running initial DDNS update..."
/usr/local/bin/dns --ddns
echo ""
echo "=== Installation complete ==="
echo ""
cat /var/log/ddns-update.log
