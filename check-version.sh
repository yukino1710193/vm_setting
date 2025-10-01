#!/bin/bash
# check-image.sh
# Check version các thành phần trong golden image

echo "===== GOLDEN IMAGE INFO ====="

echo "[*] OS:"
lsb_release -a 2>/dev/null || cat /etc/os-release

echo "[*] Kernel:"
uname -r

echo "[*] Docker:"
docker --version || echo "Docker not found"
docker compose version || echo "Docker Compose not found"

echo "[*] Golang:"
go version || echo "Go not found"

echo "[*] Helm:"
helm version --short || echo "Helm not found"

echo "[*] Python:"
python3 --version || echo "Python not found"
pip --version 2>/dev/null || echo "pip not found"

echo "[*] Ansible:"
ansible --version | head -n 1 || echo "Ansible not found"

echo "[*] Git:"
git --version || echo "Git not found"

echo "[*] jq:"
jq --version || echo "jq not found"

echo "[*] yq:"
yq --version || echo "yq not found"

echo "[*] UFW:"
ufw status || echo "UFW not found"

echo "============================="
