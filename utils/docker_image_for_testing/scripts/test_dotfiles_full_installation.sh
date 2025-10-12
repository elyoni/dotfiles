#!/bin/bash

set -e

DOTFILES_DIR="/tmp/dotfiles"
TEST_LOG_DIR="/tmp/dotfiles-test"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

setup_test_environment() {
    log_info "Setting up test environment..."

    # Ensure the test log directory exists and has proper permissions
    if [ ! -d "$TEST_LOG_DIR" ]; then
        sudo mkdir -p "$TEST_LOG_DIR"
    fi

    # Make sure current user owns the directory
    sudo chown -R "$USER:$USER" "$TEST_LOG_DIR" 2>/dev/null || true
    sudo chmod -R 755 "$TEST_LOG_DIR" 2>/dev/null || true

    # Verify we can write to the directory
    if ! touch "$TEST_LOG_DIR/test_write" 2>/dev/null; then
        log_error "Cannot write to test directory: $TEST_LOG_DIR"
        return 1
    fi
    rm -f "$TEST_LOG_DIR/test_write"

    cd "$DOTFILES_DIR"
}

run_main_install() {
    log_info "Running main dotfiles installation..."

    # Run the main install script
    if [ -f "$DOTFILES_DIR/install" ]; then
        log_info "Found main install script, running interactive installation..."

        # Create automated responses for the menu
        # Option 1: System Applications
        # Option 2: Programming Languages
        # Option 3: Terminal Applications
        # Option 4: GUI Applications
        # Option 5: Quit

        local install_failed=false

        log_info "Running System Applications installation..."
        if ! echo "1" | bash "$DOTFILES_DIR/install" 2>&1 | tee "$TEST_LOG_DIR/01_system_install.log"; then
            log_error "System Applications installation failed"
            install_failed=true
        fi

        log_info "Running Programming Languages installation..."
        if ! echo "2" | bash "$DOTFILES_DIR/install" 2>&1 | tee "$TEST_LOG_DIR/02_programming_install.log"; then
            log_error "Programming Languages installation failed"
            install_failed=true
        fi

        log_info "Running Terminal Applications installation..."
        if ! echo "3" | bash "$DOTFILES_DIR/install" 2>&1 | tee "$TEST_LOG_DIR/03_terminal_install.log"; then
            log_error "Terminal Applications installation failed"
            install_failed=true
        fi

        log_info "Running GUI Applications installation..."
        if ! echo "4" | bash "$DOTFILES_DIR/install" 2>&1 | tee "$TEST_LOG_DIR/04_gui_install.log"; then
            log_error "GUI Applications installation failed"
            install_failed=true
        fi

        if [ "$install_failed" = true ]; then
            log_error "One or more installation steps failed"
            return 1
        fi

        log_success "Main installation completed"
        return 0
    else
        log_error "Main install script not found at $DOTFILES_DIR/install"
        return 1
    fi
}

run_individual_verifications() {
    log_info "Running individual application verifications..."

    local verification_results=()

    # List of applications to verify
    local apps=(
        "zsh"
        "git"
        "neovim"
        "tmux"
        "taskwarrior"
    )

    for app in "${apps[@]}"; do
        local app_path="$DOTFILES_DIR/applications/$app"

        if [ -d "$app_path" ] && [ -f "$app_path/install" ]; then
            log_info "Verifying $app installation..."

            # Try to run verify function if it exists
            if bash "$app_path/install" verify 2>&1 | tee "$TEST_LOG_DIR/${app}_verify.log"; then
                log_success "$app verification passed"
                verification_results+=("$app: ✅ PASSED")
            else
                log_error "$app verification failed"
                verification_results+=("$app: ❌ FAILED")
                return 1
            fi
        else
            log_warning "$app install script not found"
            verification_results+=("$app: ⚠️  NOT FOUND")
        fi
    done

    # Print summary
    log_info "Verification Summary:"
    for result in "${verification_results[@]}"; do
        echo "  $result"
    done
}

check_system_state() {
    log_info "Checking overall system state..."

    # Check shell
    log_info "Default shell: $SHELL"

    # Check installed binaries
    local binaries=("zsh" "git" "nvim" "tmux" "task" "starship")

    for binary in "${binaries[@]}"; do
        if command -v "$binary" >/dev/null 2>&1; then
            log_success "$binary is available"
        else
            log_warning "$binary is not available"
        fi
    done

    # Check configuration files
    local configs=(
        "$HOME/.zshrc"
        "$HOME/.gitconfig"
        "$HOME/.config/nvim"
        "$HOME/.tmux.conf"
        "$HOME/.taskrc"
    )

    for config in "${configs[@]}"; do
        if [ -e "$config" ]; then
            log_success "$config exists"
        else
            log_warning "$config not found"
        fi
    done
}

generate_final_report() {
    log_info "Generating final test report..."

    local report_file="$TEST_LOG_DIR/final_test_report.md"

    cat > "$report_file" << EOF
# Dotfiles Full Installation Test Report

**Generated:** $(date)
**Environment:** Docker container (Ubuntu 22.04)
**User:** $USER
**Home:** $HOME

## Installation Summary

### Main Installation Steps
- ✅ System Applications: See \`01_system_install.log\`
- ✅ Programming Languages: See \`02_programming_install.log\`
- ✅ Terminal Applications: See \`03_terminal_install.log\`
- ✅ GUI Applications: See \`04_gui_install.log\`

### Binary Availability
$(for binary in zsh git nvim tmux task starship; do
    if command -v "$binary" >/dev/null 2>&1; then
        echo "- ✅ $binary: $(command -v "$binary")"
    else
        echo "- ❌ $binary: Not found"
    fi
done)

### Configuration Files
$(for config in "$HOME/.zshrc" "$HOME/.gitconfig" "$HOME/.config/nvim" "$HOME/.tmux.conf" "$HOME/.taskrc"; do
    if [ -e "$config" ]; then
        echo "- ✅ $config"
    else
        echo "- ❌ $config"
    fi
done)

### Shell Information
- Current shell: $SHELL
- Default shell: $(grep "^$USER:" /etc/passwd | cut -d: -f7)

## Log Files
All detailed logs are available in the \`$TEST_LOG_DIR\` directory:
$(ls -1 "$TEST_LOG_DIR"/*.log 2>/dev/null | sed 's/^/- /' || echo "- No log files found")

EOF

    log_success "Final report generated: $report_file"

    # Also display a summary
    log_info "=== FINAL SUMMARY ==="
    cat "$report_file"
}

# Main test execution function
run_full_dotfiles_test() {
    log_info "Starting full dotfiles installation test..."

    setup_test_environment

    # Run main installation
    if run_main_install; then
        log_success "Main installation completed"
    else
        log_error "Main installation failed"
        return 1
    fi

    # Run verifications
    run_individual_verifications

    # Check system state
    check_system_state

    # Generate final report
    generate_final_report

    log_success "Full dotfiles test completed! Check the logs in $TEST_LOG_DIR"
}

# Help function
help() {
    echo "Usage: $0 [command]"
    echo ""
    echo "Commands:"
    echo "  run_full_dotfiles_test     Run complete dotfiles installation and verification"
    echo "  run_main_install          Run only the main installation"
    echo "  run_individual_verifications  Run only verification checks"
    echo "  check_system_state        Check current system state"
    echo "  generate_final_report     Generate test report"
    echo "  help                      Show this help message"
}

# Main execution
if [ $# -eq 0 ]; then
    run_full_dotfiles_test
else
    "$@"
fi