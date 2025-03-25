#!/bin/bash

# ==================== IMPORT MODULES ====================
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib/log.sh"
source "$SCRIPT_DIR/lib/utils.sh"
source "$SCRIPT_DIR/lib/install_core.sh"
source "$SCRIPT_DIR/lib/app_ops.sh"

# ==================== MAIN ====================
info "Enter App's name:"
read -r APP_NAME

info "Enter Go's download link:"
read -r LINK_DOWNLOAD

install_app "$APP_NAME" "$LINK_DOWNLOAD"
