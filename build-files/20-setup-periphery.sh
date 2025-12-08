#!/bin/bash
set -euxo pipefail

load_version() {
    local version=""
    for arg in "$@"; do
        if [[ "${arg}" == --version=* ]]; then
            version="${arg#--version=}"
        fi
    done
	version="${version:-latest}"
    echo "${version}"
}

load_latest_version() {
    # Using curl and jq for proper JSON parsing
    local curl_opts=("-fsSL" "--retry" "3" "--retry-delay" "2" "--retry-max-time" "10")

    # Add bearer token if GITHUB_TOKEN is defined
    if [[ -n "${GITHUB_TOKEN}" ]]; then
        curl_opts+=("-H" "Authorization: Bearer ${GITHUB_TOKEN}")
    fi

    curl "${curl_opts[@]}" "https://api.github.com/repos/moghtech/komodo/releases/latest" | \
        jq -r '.tag_name'
}

uses_systemd() {
	true # Assume systemd is always used in this context
}

load_paths() {
    local user_install=false

    echo "${user_install}" "${home_dir}" "${bin_dir}" "${config_dir}" "${service_dir}"
}

copy_binary() {
    local home_dir="${HOME}"
    local bin_dir="/usr/bin"
    local config_dir="/etc/komodo"
    local service_dir="/usr/lib/systemd/system"
    
    local systemctl_opts=""
    [[ "${user_install}" == "true" ]] && systemctl_opts="--user"

    # Stop periphery if it's running
    #systemctl ${systemctl_opts} stop periphery 2>/dev/null || true

}

copy_config() {
    local config_dir="$1"
    local config_file="${config_dir}/periphery.config.toml"

    # Skip if config already exists
    if [[ -f "${config_file}" ]]; then
        echo "config already exists, skipping..."
        return
    fi

    echo "creating config at ${config_file}"

}
main() {
    echo "====================="
    echo " PERIPHERY INSTALLER "
    echo "====================="
    local version
    version=$(load_version "$@")
    local home_dir="${HOME}"
    local bin_dir="/usr/bin"
    local config_dir="/etc/komodo"
    local config_file="${config_dir}/periphery.config.toml"
    local service_dir="/usr/lib/systemd/system"

    # Ensure bin_dir exists
    mkdir -p "${bin_dir}"

    # Remove existing binary
    rm -f "${bin_dir}/periphery"

    # Determine architecture and select appropriate binary
    local arch
    arch=$(uname -m)
    local periphery_bin="periphery-x86_64"
    
    case "${arch}" in
        aarch64|arm64)
            echo "aarch64 detected"
            periphery_bin="periphery-aarch64"
            ;;
        *)
            echo "using x86_64 binary"
            ;;
    esac

    # Download the binary
	if [[ "${version}" == "latest" ]]; then
		url="https://github.com/moghtech/komodo/releases/latest/download/${periphery_bin}" 
	else
		url="https://github.com/moghtech/komodo/releases/download/${version}/${periphery_bin}" 
	fi
    curl -fsSL "${url}" \
        -o "${bin_dir}/periphery"
    
    # Make binary executable
    chmod +x "${bin_dir}/periphery"

	# Download the config
    mkdir -p "${config_dir}"

    curl -sSL "https://raw.githubusercontent.com/moghtech/komodo/main/config/periphery.config.toml" \
        -o "${config_file}"

    mkdir -p "${service_dir}"

    # Use here-document for multi-line file writing (cleaner than echo -e)
    cat > "${service_dir}/periphery.service" << EOF
[Unit]
Description=Agent to connect with Komodo Core

[Service]
Environment="HOME=${home_dir}"
ExecStart=/bin/sh -lc "${bin_dir}/periphery --config-path ${config_dir}/periphery.config.toml"
Restart=on-failure
TimeoutStartSec=0

[Install]
WantedBy=default.target
EOF

    echo "enabling periphery..."
	systemctl preset periphery.service
	systemctl enable periphery.service
}

main "$@"
