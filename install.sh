#!/usr/bin/env bash

set -euo pipefail

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

INSTALL_DIR="/usr/local/bin"
SCRIPT_NAME="aptos-keyrotate"
REPO_URL="https://raw.githubusercontent.com/ThalaLabs/aptos-keyrotate/main"

error() {
    echo -e "${RED}Error: $1${NC}" >&2
}

success() {
    echo -e "${GREEN}$1${NC}"
}

info() {
    echo "$1"
}

warning() {
    echo -e "${YELLOW}$1${NC}"
}

# Check if running with sufficient privileges
check_permissions() {
    if [[ ! -w "$INSTALL_DIR" ]]; then
        error "Cannot write to $INSTALL_DIR"
        info "Please run with sudo: curl -fsSL ... | sudo bash"
        exit 1
    fi
}

# Download and install the script
install_script() {
    local tmp_file
    tmp_file=$(mktemp)

    info "Downloading $SCRIPT_NAME..."

    if ! curl -fsSL "$REPO_URL/$SCRIPT_NAME" -o "$tmp_file"; then
        error "Failed to download $SCRIPT_NAME"
        rm -f "$tmp_file"
        exit 1
    fi

    # Verify it's a bash script
    if ! head -1 "$tmp_file" | grep -q "^#!/.*bash"; then
        error "Downloaded file is not a valid bash script"
        rm -f "$tmp_file"
        exit 1
    fi

    info "Installing to $INSTALL_DIR/$SCRIPT_NAME..."

    # Install the script
    if ! mv "$tmp_file" "$INSTALL_DIR/$SCRIPT_NAME"; then
        error "Failed to install $SCRIPT_NAME to $INSTALL_DIR"
        rm -f "$tmp_file"
        exit 1
    fi

    # Make it executable
    chmod +x "$INSTALL_DIR/$SCRIPT_NAME"

    success "✓ Successfully installed $SCRIPT_NAME"
}

# Check if aptos CLI is installed
check_aptos_cli() {
    if ! command -v aptos &> /dev/null; then
        warning ""
        warning "⚠️  Aptos CLI is not installed"
        warning "aptos-keyrotate requires the Aptos CLI to function."
        warning ""
        warning "Install it from: https://aptos.dev/tools/aptos-cli/install-cli"
        warning ""
    fi
}

# Display success message
display_success() {
    success ""
    success "=========================================="
    success "  Installation Complete!"
    success "=========================================="
    info ""
    info "Run '$SCRIPT_NAME --help' to get started"
    info ""
    info "Example usage:"
    info "  $SCRIPT_NAME --profile my-wallet"
    info ""
}

main() {
    info "Installing aptos-keyrotate..."
    info ""

    check_permissions
    install_script
    check_aptos_cli
    display_success
}

main "$@"
