#!/usr/bin/env bash
set -euo pipefail

# -------------------------------------------------------
# Minimal OpenSSH setup (no SELinux, no key injection)
# Tasks:
#   1) Install openssh-server if missing
#   2) Enable & start ssh/sshd service
#   3) Create ~/.ssh/authorized_keys with correct perms
# Options:
#   -u|--user <username>   : target user (default: SUDO_USER or current user)
# -------------------------------------------------------

usage() {
  echo "Usage: sudo $0 [-u USER]"
}

# ---- parse args
TARGET_USER="${SUDO_USER:-${USER}}"
while [[ $# -gt 0 ]]; do
  case "$1" in
    -u|--user) TARGET_USER="$2"; shift 2;;
    -h|--help) usage; exit 0;;
    *) echo "Unknown arg: $1"; usage; exit 2;;
  esac
done

# ---- require root
if [[ $EUID -ne 0 ]]; then
  echo "[ERR] Need root. Run: sudo $0 [options]" >&2
  exit 1
fi

# ---- validate target user & home
if ! id "$TARGET_USER" &>/dev/null; then
  echo "[ERR] User '$TARGET_USER' not found." >&2
  exit 1
fi
HOME_DIR=$(eval echo "~$TARGET_USER")
if [[ ! -d "$HOME_DIR" ]]; then
  echo "[ERR] Cannot resolve HOME for '$TARGET_USER'." >&2
  exit 1
fi

echo "[INFO] Target user: $TARGET_USER (HOME=$HOME_DIR)"

# ---- detect package manager
PM="" ; PKG_NAME="openssh-server"
if command -v apt-get >/dev/null 2>&1; then
  PM="apt"
elif command -v dnf >/dev/null 2>&1; then
  PM="dnf"
elif command -v yum >/dev/null 2>&1; then
  PM="yum"
elif command -v zypper >/dev/null 2>&1; then
  PM="zypper"
elif command -v pacman >/dev/null 2>&1; then
  PM="pacman"; PKG_NAME="openssh"
else
  echo "[ERR] No supported package manager (apt/dnf/yum/zypper/pacman)." >&2
  exit 1
fi
echo "[INFO] Package manager: $PM"

# ---- install openssh-server if missing
if ! command -v sshd >/dev/null 2>&1; then
  echo "[INFO] Installing $PKG_NAME ..."
  case "$PM" in
    apt)
      export DEBIAN_FRONTEND=noninteractive
      apt-get update -y
      apt-get install -y "$PKG_NAME"
      ;;
    dnf) dnf install -y "$PKG_NAME" ;;
    yum) yum install -y "$PKG_NAME" ;;
    zypper)
      zypper --non-interactive refresh
      zypper --non-interactive install "$PKG_NAME"
      ;;
    pacman)
      pacman -Sy --noconfirm "$PKG_NAME"
      ;;
  esac
  echo "[OK] Installed $PKG_NAME."
else
  echo "[OK] sshd already present."
fi

# ---- pick service name: ssh (Deb/Ub) or sshd (RHEL/Arch/etc.)
SERVICE_NAME="sshd"
if systemctl list-unit-files | grep -qE '^ssh\.service'; then
  SERVICE_NAME="ssh"
elif systemctl list-unit-files | grep -qE '^sshd\.service'; then
  SERVICE_NAME="sshd"
fi
echo "[INFO] Service name: $SERVICE_NAME"

# ---- enable & start
systemctl enable --now "$SERVICE_NAME"
systemctl is-active --quiet "$SERVICE_NAME" \
  && echo "[OK] Service $SERVICE_NAME is running." \
  || { echo "[ERR] Service $SERVICE_NAME not running. Check: journalctl -u $SERVICE_NAME"; exit 1; }

# ---- create ~/.ssh & authorized_keys with strict perms
SSH_DIR="$HOME_DIR/.ssh"
AUTH_KEYS="$SSH_DIR/authorized_keys"

mkdir -p "$SSH_DIR"
touch "$AUTH_KEYS"

chmod 700 "$SSH_DIR"
chmod 600 "$AUTH_KEYS"
chown -R "$TARGET_USER:$TARGET_USER" "$SSH_DIR"

echo "[OK] ~/.ssh and authorized_keys prepared with correct permissions."
echo "[DONE]"
