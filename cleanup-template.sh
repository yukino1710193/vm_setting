#!/bin/bash
set -e

echo "[*] Cleanup machine-id"
rm -f /etc/machine-id
touch /etc/machine-id
rm -f /var/lib/dbus/machine-id
ln -s /etc/machine-id /var/lib/dbus/machine-id

echo "[*] Cleanup SSH host keys"
rm -f /etc/ssh/ssh_host_*

echo "[*] Cleanup logs"
journalctl --rotate || true
journalctl --vacuum-time=1s || true
rm -f /var/log/wtmp /var/log/btmp
find /var/log -type f -exec truncate -s 0 {} \;

echo "[*] Cleanup histories"
# clear in-memory history for current shell
history -c || true
history -w || true
unset HISTFILE
# remove history files for all users
rm -f /root/.bash_history
rm -f /home/*/.bash_history

echo "[*] Cleanup cloud-init state"
if command -v cloud-init >/dev/null 2>&1; then
    cloud-init clean --logs
    rm -rf /var/lib/cloud/*
fi

echo "[*] Cleanup package manager cache"
apt-get clean
rm -rf /var/lib/apt/lists/*

echo "[*] Cleanup tmp dirs"
rm -rf /tmp/* /var/tmp/*

# optional: remove ssh known_hosts (nếu bạn không muốn mang theo fingerprint cũ)
rm -f /root/.ssh/known_hosts
rm -f /home/*/.ssh/known_hosts

echo "[*] Final sync "
sync
