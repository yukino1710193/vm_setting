#!/bin/bash
# prepare-firstboot.sh
# Enable các service run-once để VM clone sẵn sàng chạy ở lần boot đầu

set -e

SERVICES=(
  firstboot-ssh-keygen.service
  firstboot-resize.service
)

for svc in "${SERVICES[@]}"; do
  if systemctl list-unit-files | grep -q "$svc"; then
    echo "[*] Enabling $svc ..."
    sudo systemctl enable "$svc"
  else
    echo "[!] Service $svc chưa được cài đặt."
  fi
done

echo "[*] Prepare done. Các service run-once sẽ chạy ở lần boot tiếp theo."
