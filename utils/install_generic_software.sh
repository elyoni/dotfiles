#!/bin/bash

# Generic software installation script
# This script installs essential tools needed by most dotfiles installation scripts
# It should be sourced at the beginning of each install script

# Don't exit on error - we want to handle errors gracefully
set +e

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

# Remove deprecated/broken repositories that cause apt update failures
cleanup_broken_repositories() {
    log_info "Checking for broken repositories..."
    local cleaned=false
    
    # Remove deprecated AppImageLauncher PPA (both formats)
    if ls /etc/apt/sources.list.d/appimagelauncher-team-ubuntu-stable-*.sources 2>/dev/null | grep -q . || \
       ls /etc/apt/sources.list.d/appimagelauncher-team-ubuntu-stable-*.list 2>/dev/null | grep -q .; then
        log_info "Removing deprecated AppImageLauncher PPA..."
        sudo rm -f /etc/apt/sources.list.d/appimagelauncher-team-ubuntu-stable-*.sources 2>/dev/null || true
        sudo rm -f /etc/apt/sources.list.d/appimagelauncher-team-ubuntu-stable-*.list 2>/dev/null || true
        sudo rm -f /etc/apt/sources.list.d/appimagelauncher-team-ubuntu-stable-*.save 2>/dev/null || true
        cleaned=true
    fi
    
    if [ "$cleaned" = true ]; then
        log_success "Cleaned up broken repositories"
    fi
}

# Fix broken packages and dependencies
fix_package_state() {
    log_info "Checking and fixing package state..."
    
    # Clean up broken repositories first
    cleanup_broken_repositories
    
    # Try to fix broken packages
    if sudo apt-get install -f -y >/dev/null 2>&1; then
        log_success "Package state fixed"
        return 0
    else
        log_warning "Could not automatically fix package state, continuing anyway..."
        return 0
    fi
}

# Handle version conflicts by trying alternative installation methods
handle_version_conflict() {
    local package_name=$1
    local error_output=$2
    
    # Check if this is a version conflict issue
    if echo "$error_output" | grep -q "Depends:.*but.*is to be installed"; then
        log_warning "Version conflict detected for $package_name"
        
        # Extract the conflicting package and versions
        local conflict_info=$(echo "$error_output" | grep -o "Depends: [^ ]* (= [^)]*)" | head -1)
        if [ -n "$conflict_info" ]; then
            log_info "Conflict details: $conflict_info"
        fi
        
        # Extract the required version and conflicting package
        local required_pkg=$(echo "$conflict_info" | grep -o "Depends: [^ ]*" | cut -d' ' -f2)
        local required_version=$(echo "$conflict_info" | grep -o "= [^)]*" | cut -d' ' -f2)
        local installed_version=$(dpkg -l "$required_pkg" 2>/dev/null | awk 'NR>5 && $1=="ii" {print $3}')
        
        if [ -n "$required_pkg" ] && [ -n "$required_version" ] && [ -n "$installed_version" ]; then
            log_info "Required: $required_pkg=$required_version, Installed: $installed_version"
            
            # For bzip2/libbz2 conflicts, try to install the exact required version
            if [ "$package_name" = "bzip2" ] && [ "$required_pkg" = "libbz2-1.0" ]; then
                log_info "Attempting to install exact required version of $required_pkg..."
                log_info "This may require downgrading from $installed_version to $required_version"
                
                # Try to install the exact version from repository (may require downgrade)
                if sudo apt-get install -y --allow-downgrades "${required_pkg}=${required_version}" >/dev/null 2>&1; then
                    log_success "Installed exact version of $required_pkg, retrying $package_name..."
                    # Now try installing the original package again
                    if sudo apt-get install -y "$package_name" >/dev/null 2>&1; then
                        log_success "$package_name installed successfully after version fix"
                        return 0
                    fi
                else
                    log_warning "Could not install exact version, trying alternative approach..."
                fi
            fi
        fi
        
        # For bzip2 specifically, check if the command actually works
        if [ "$package_name" = "bzip2" ]; then
            if command -v bzip2 >/dev/null 2>&1; then
                log_warning "bzip2 command is available despite package conflict"
                log_info "This is likely safe to continue - the installed version should work"
                return 0
            fi
        fi
        
        # Try to install with --allow-downgrades to allow version mismatch
        log_info "Attempting installation with --allow-downgrades..."
        if sudo apt-get install -y --allow-downgrades "$package_name" >/dev/null 2>&1; then
            log_success "$package_name installed with --allow-downgrades"
            return 0
        fi
        
        # Try installing both packages together to let apt resolve
        if [ -n "$required_pkg" ]; then
            log_info "Attempting to install $package_name and $required_pkg together..."
            if sudo apt-get install -y "$package_name" "$required_pkg" >/dev/null 2>&1; then
                log_success "$package_name installed by installing dependencies together"
                return 0
            fi
        fi
        
        # Check for held packages
        local held_packages=$(dpkg --get-selections | grep hold | awk '{print $1}')
        if [ -n "$held_packages" ]; then
            log_warning "Found held packages that may be causing conflicts:"
            echo "$held_packages" | head -5
        fi
    fi
    
    return 1
}

# Install essential tools that most install scripts depend on
install_essential_tools() {
    log_info "Installing essential tools..."

    # Update package list
    sudo apt-get update -y
    
    # Fix any broken package states before proceeding
    fix_package_state

    # Install essential tools
    # Note: bzip2 is installed before build-essential as it's a dependency
    local essential_tools=(
        "curl"
        "wget"
        "git"
        "bzip2"
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
            "build-essential"|"software-properties-common"|"apt-transport-https"|"bzip2")
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
            local install_success=false
            local install_output=""
            
            if command -v fast_apt_install >/dev/null 2>&1; then
                install_output=$(fast_apt_install "$tool" 2>&1)
                if [ $? -eq 0 ]; then
                    install_success=true
                fi
            else
                install_output=$(sudo apt-get install -y "$tool" 2>&1)
                if [ $? -eq 0 ]; then
                    install_success=true
                fi
            fi

            # Verify installation based on package type
            if [ "$install_success" = true ]; then
                case "$tool" in
                    "build-essential"|"software-properties-common"|"apt-transport-https"|"bzip2")
                        # For meta-packages, verify package installation
                        if command -v fast_apt_install >/dev/null 2>&1; then
                            if fast_apt_verify "$tool" >/dev/null 2>&1; then
                                log_success "$tool installed successfully"
                            else
                                log_warning "$tool installation may have failed, but continuing..."
                            fi
                        else
                            if dpkg -l | awk -v pkg="$tool" '$1=="ii" && $2==pkg {found=1; exit} END {exit !found}' >/dev/null 2>&1; then
                                log_success "$tool installed successfully"
                            else
                                log_warning "$tool installation may have failed, but continuing..."
                            fi
                        fi
                        ;;
                    *)
                        # For regular packages, verify command availability
                        if command -v "$cmd_name" >/dev/null 2>&1; then
                            log_success "$tool installed successfully"
                        else
                            log_warning "$tool installation may have failed, but continuing..."
                        fi
                        ;;
                esac
            else
                log_error "Failed to install $tool"
                # Show the error output if it contains useful information
                if echo "$install_output" | grep -q "unmet dependencies\|broken packages\|not installable"; then
                    echo "$install_output" | grep -E "(unmet dependencies|broken packages|not installable|Depends:)" | head -5
                fi
                
                # Try to handle version conflicts
                if handle_version_conflict "$tool" "$install_output"; then
                    # Version conflict was resolved, continue
                    log_success "$tool installation resolved"
                else
                    # Try to fix broken packages and retry once
                    log_info "Attempting to fix package dependencies and retry..."
                    fix_package_state
                    
                    # Retry installation
                    local retry_output=""
                    if command -v fast_apt_install >/dev/null 2>&1; then
                        retry_output=$(fast_apt_install "$tool" 2>&1)
                    else
                        retry_output=$(sudo apt-get install -y "$tool" 2>&1)
                    fi
                    
                    # Check if retry succeeded
                    if [ $? -eq 0 ] || command -v "$cmd_name" >/dev/null 2>&1 2>/dev/null; then
                        log_success "$tool installed successfully on retry"
                    else
                        # For critical packages, provide more specific guidance
                        if [ "$tool" = "bzip2" ] || [ "$tool" = "build-essential" ]; then
                            log_warning "Critical package $tool installation failed"
                            log_info "This may be due to version conflicts from custom repositories"
                            log_info "You may need to manually resolve this by:"
                            log_info "  1. Checking for held packages: dpkg --get-selections | grep hold"
                            log_info "  2. Checking repository priorities: apt-cache policy $tool"
                            log_info "  3. Or temporarily allowing version conflicts"
                        fi
                        log_warning "Continuing despite $tool installation issues..."
                    fi
                fi
            fi
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

    # Install essential tools (errors are handled gracefully within the function)
    install_essential_tools

    # Verify essential tools (these are critical, so we check them)
    if ! verify_essential_tools; then
        log_error "Essential tools verification failed"
        log_warning "Some tools may not be available, but continuing with installation..."
        # Don't return 1 here - allow the script to continue
    fi

    log_success "Generic software setup completed"
    return 0
}

# Auto-run if script is executed directly (not sourced)
if [ "${BASH_SOURCE[0]}" == "${0}" ]; then
    ensure_generic_software "$@"
fi