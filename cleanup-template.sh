#!/bin/bash
set -e

echo "[*] Cleanup machine-id"
truncate -s 0 /etc/machine-id
rm -f /var/lib/dbus/machine-id
ln -s /etc/machine-id /var/lib/dbus/machine-id

echo "[*] Cleanup SSH host keys"
rm -f /etc/ssh/ssh_host_*

echo "[*] Cleanup logs"
journalctl --rotate
journalctl --vacuum-time=1s
rm -f /var/log/wtmp /var/log/btmp
truncate -s 0 /var/log/*.log || true

echo "[*] Cleanup history"
history -c && history -w
rm -f ~/.bash_history

if command -v cloud-init >/dev/null 2>&1; then
    echo "[*] Cleanup cloud-init state"
    cloud-init clean --logs
fi

echo "[*] Cleanup done. Shutdown to convert to template."
