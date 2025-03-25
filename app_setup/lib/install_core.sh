#!/bin/bash

# ==================== GENERIC INSTALLER CORE ====================

download_app() {
    local url="$1"
    local dest="$2"
    local app_name="$3"

    info "Downloading $app_name from: $url"
    curl -L -o "$dest" "$url" || error "Failed to download $app_name"
    success "Downloaded $app_name → $dest"
}

extract_tarball() {
    local file="$1"
    local target_dir="$2"
    local app_name="$3"

    info "Removing existing $app_name (if any) in $target_dir"
    rm -rf "$target_dir/tmp_install_$app_name"

    info "Extracting $app_name to $target_dir/tmp_install_$app_name"
    mkdir -p "$target_dir/tmp_install_$app_name"
    tar -xf "$file" -C "$target_dir/tmp_install_$app_name" || error "Extraction failed for $app_name"
    success "Extracted $app_name"
}

find_binary_after_extract() {
    local extract_dir="$1"
    local app_name="$2"
    find "$extract_dir" -type f -name "$app_name" -perm -u+x | head -n1
}

add_bin_to_path() {
    local bin_path="$1"

    local export_line="export PATH=\$PATH:$bin_path"
    grep -qxF "$export_line" ~/.bashrc || echo "$export_line" >> ~/.bashrc

    export PATH="$PATH:$bin_path"
    dedup_path
}

validate_binary() {
    local binary_name="$1"
    command -v "$binary_name" &>/dev/null || error "$binary_name not found in PATH after install"
}

install_app() {
    local app_name="$1"
    local download_url="$2"
    local archive_name
    archive_name=$(basename "$download_url")
    local archive_path="$HOME/$archive_name"
    local extract_base="$HOME"
    local extract_dir="$extract_base/tmp_install_$app_name"

    download_app "$download_url" "$archive_path" "$app_name"
    extract_tarball "$archive_path" "$extract_base" "$app_name"

    local binary_path
    binary_path=$(find_binary_after_extract "$extract_dir" "$app_name")
    [[ -z "$binary_path" ]] && error "Không tìm thấy binary '$app_name' sau khi giải nén"

    local bin_path_dest
    bin_path_dest=$(get_app_bin_path "$app_name" "dest")
    sudo mkdir -p "$(dirname "$bin_path_dest")"
    sudo mv "$binary_path" "$bin_path_dest"

    add_bin_to_path "$(dirname "$bin_path_dest")"
    validate_binary "$app_name"
    success "$app_name installation complete"

    rm -rf "$extract_dir"
}
