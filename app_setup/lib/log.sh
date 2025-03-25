# ==================== COLOR & LOGGING ====================
RED="\033[31m"
GREEN="\033[32m"
YELLOW="\033[33m"
BLUE="\033[34m"
RESET="\033[0m"
BOLD="\033[1m"

log() {
    local color="$1"; shift
    echo -e "${color}$*${RESET}"
}

success() { log "${GREEN}${BOLD}" "[✔] $*"; }
warning() { log "${YELLOW}${BOLD}" "[!] $*"; }
error()   { log "${RED}${BOLD}" "[✖] $*"; exit 1; }
info()    { log "${BLUE}${BOLD}" "[i] $*"; }
