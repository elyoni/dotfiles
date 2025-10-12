#!/bin/bash

# Generic software installation script
# This script installs essential tools needed by most dotfiles installation scripts
# It should be sourced at the beginning of each install script

set -e

# Source apt utilities if available
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [ -f "$SCRIPT_DIR/package/apt" ]; then
    source "$SCRIPT_DIR/package/apt"
fi

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

log_info() {
    echo -e "${BLUE}[GENERIC]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[GENERIC]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[GENERIC]${NC} $1"
}

log_error() {
    echo -e "${RED}[GENERIC]${NC} $1"
}

# Install essential tools that most install scripts depend on
install_essential_tools() {
    log_info "Installing essential tools..."

    # Update package list
    sudo apt-get update -y

    # Install essential tools
    local essential_tools=(
        "curl"
        "wget"
        "git"
        "build-essential"
        "software-properties-common"
        "apt-transport-https"
    )

    for tool in "${essential_tools[@]}"; do
        # Check if command exists or package is installed
        local cmd_name="${tool%% *}"  # Get first word (command name)
        local should_install=false

        # Special handling for meta-packages that don't provide commands
        case "$tool" in
            "build-essential"|"software-properties-common"|"apt-transport-https")
                # For meta-packages, check if package is installed instead of command
                if command -v fast_apt_install >/dev/null 2>&1; then
                    if ! fast_apt_verify "$tool" >/dev/null 2>&1; then
                        should_install=true
                    fi
                else
                    if ! dpkg -l | awk -v pkg="$tool" '$1=="ii" && $2==pkg {found=1; exit} END {exit !found}' >/dev/null 2>&1; then
                        should_install=true
                    fi
                fi
                ;;
            *)
                # For regular packages, check if command exists
                if ! command -v "$cmd_name" >/dev/null 2>&1; then
                    should_install=true
                fi
                ;;
        esac

        if [ "$should_install" = true ]; then
            log_info "Installing $tool..."
            if command -v fast_apt_install >/dev/null 2>&1; then
                fast_apt_install "$tool"
            else
                sudo apt-get install -y "$tool"
            fi

            # Verify installation based on package type
            case "$tool" in
                "build-essential"|"software-properties-common"|"apt-transport-https")
                    # For meta-packages, verify package installation
                    if command -v fast_apt_install >/dev/null 2>&1; then
                        if fast_apt_verify "$tool" >/dev/null 2>&1; then
                            log_success "$tool installed successfully"
                        else
                            log_error "Failed to install $tool"
                            return 1
                        fi
                    else
                        if dpkg -l | awk -v pkg="$tool" '$1=="ii" && $2==pkg {found=1; exit} END {exit !found}' >/dev/null 2>&1; then
                            log_success "$tool installed successfully"
                        else
                            log_error "Failed to install $tool"
                            return 1
                        fi
                    fi
                    ;;
                *)
                    # For regular packages, verify command availability
                    if command -v "$cmd_name" >/dev/null 2>&1; then
                        log_success "$tool installed successfully"
                    else
                        log_error "Failed to install $tool - command not available after installation"
                        return 1
                    fi
                    ;;
            esac
        else
            log_info "$tool is already available"
        fi
    done
}

# Verify essential tools are available
verify_essential_tools() {
    log_info "Verifying essential tools..."

    local required_tools=("curl" "wget" "git")
    local missing_tools=()

    for tool in "${required_tools[@]}"; do
        if ! command -v "$tool" >/dev/null 2>&1; then
            missing_tools+=("$tool")
            log_error "$tool is not available"
        else
            log_success "$tool is available"
        fi
    done

    if [ ${#missing_tools[@]} -gt 0 ]; then
        log_error "Missing essential tools: ${missing_tools[*]}"
        return 1
    fi

    log_success "All essential tools verified"
    return 0
}

# Main function to ensure generic software is installed
ensure_generic_software() {
    log_info "Ensuring generic software is available..."

    if ! install_essential_tools; then
        log_error "Failed to install essential tools"
        return 1
    fi

    if ! verify_essential_tools; then
        log_error "Essential tools verification failed"
        return 1
    fi

    log_success "Generic software setup completed"
    return 0
}

# Auto-run if script is executed directly (not sourced)
if [ "${BASH_SOURCE[0]}" == "${0}" ]; then
    ensure_generic_software "$@"
fi