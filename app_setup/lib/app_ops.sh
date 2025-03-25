#!/bin/bash

# ==================== APP INSTALL CONFIG ====================
declare -A app_bin_path_dest=(
    [go]="/usr/local/go/bin"
    [ko]="/usr/local/bin"
    [upx]="/usr/local/bin"
)

get_app_bin_path() {
    local app_name="$1"
    local mode="$2"
    local array_name="app_bin_path_${mode}[$app_name]"
    local value=$(eval "echo \${$array_name}")

    if [[ -n "$value" && "$value" != " " ]]; then
        echo "$value"
    else
        read -p "[?] Chưa có bin_path_${mode} cho $app_name, bạn muốn nhập (y/n)? " choice
        if [[ "$choice" == "y" ]]; then
            read -p "Nhập bin_path_${mode} cho $app_name: " user_path
            eval "app_bin_path_${mode}[$app_name]=\"$user_path\""
            echo "$user_path"
        else
            local fallback="/usr/local/$app_name/bin"
            echo "[i] Dùng mặc định: $fallback"
            echo "$fallback"
        fi
    fi
}
