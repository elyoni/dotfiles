#!/bin/bash

#==============================================================================
# DIRECTORIES TO SYNC
# Add or remove directories as needed. Paths will be preserved on remote.
#==============================================================================

SYNC_DIRS=(
    #"$HOME/.dotfiles"
    "$HOME/.work_dotfiles"
    #"$HOME/.ssh"
    "$HOME/.obsidian"
    "$HOME/Documents"
    "$HOME/Downloads"
    "$HOME/projects"
    "$HOME/private"
    "$HOME/scripts"
    "$HOME/.config/Cursor"
    "$HOME/.config/Claude"
    "$HOME/.config/obsidian"
    #"$HOME/.local/share/applications"
    #"$HOME/.local/bin"
)

#==============================================================================
# FILES TO SYNC
# Individual files to sync. Paths will be preserved on remote.
#==============================================================================

SYNC_FILES=(
    "$HOME/.zsh_history"
    "$HOME/.bashrc"
    "$HOME/.bash_history"
)

#==============================================================================
# EXCLUDE PATTERNS
# Files/directories matching these patterns will be excluded from sync
#==============================================================================

EXCLUDE_PATTERNS=(
    "node_modules/"
    "__pycache__/"
    "*.pyc"
    ".venv/"
    "venv/"
    ".cache/"
    "*.tmp"
    ".DS_Store"
    "Thumbs.db"
    "*.swp"
    "*.swo"
    ".npm/"
    ".cargo/registry/"
    ".cargo/git/"
    ".rustup/toolchains/"
    "Cache/"
    "CachedData/"
    "GPUCache/"
    "Service Worker/"
    "Code Cache/"
    "*.sock"
)

#==============================================================================
# CONFIGURATION
#==============================================================================

# SSH host from ~/.ssh/config (e.g., "backup-server")
REMOTE_HOST="${REMOTE_HOST:-}"

# Rsync options (base options, --delete added conditionally)
RSYNC_OPTS="-avz --progress"

# Bandwidth limit in KB/s (0 = unlimited)
BANDWIDTH_LIMIT="${BANDWIDTH_LIMIT:-0}"

#==============================================================================
# SCRIPT
#==============================================================================

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

log() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

warn() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

error() {
    echo -e "${RED}[ERROR]${NC} $1"
    exit 1
}

info() {
    echo -e "${BLUE}[SYNC]${NC} $1"
}

show_help() {
    cat << EOF
Usage: $(basename "$0") [OPTIONS] REMOTE_HOST

Sync local directories with a remote computer for backup.
Remote host should be configured in ~/.ssh/config.

ARGUMENTS:
    REMOTE_HOST         SSH host from ~/.ssh/config (e.g., backup-server)

OPTIONS:
    -p, --pull          Pull from remote to local (restore)
    -l, --list          List directories that will be synced (shows remote sizes if REMOTE_HOST provided)
    -v, --verify        Verify remote backup (compare sizes)
    -d, --dir PATH      Sync only specific directory (must be in SYNC_DIRS)
    -h, --help          Show this help message
    --dry-run           Perform a dry run without making changes
    --bwlimit KBPS      Bandwidth limit in KB/s

Without --pull, performs push (local to remote backup).

EXAMPLES:
    $(basename "$0") backup-server                      # Backup all to remote
    $(basename "$0") --pull backup-server               # Restore all from remote
    $(basename "$0") --dir ~/projects backup-server     # Sync only projects
    $(basename "$0") --verify backup-server             # Verify backup
    $(basename "$0") --dry-run backup-server            # Test sync
    $(basename "$0") --list                             # Show directories (local only)
    $(basename "$0") --list backup-server               # Show directories with remote comparison

SETUP:
    1. Configure remote host in ~/.ssh/config:
       Host backup-server
           HostName 192.168.1.100
           User myuser
           Port 22
           IdentityFile ~/.ssh/id_rsa

    2. Edit SYNC_DIRS in this script to add/remove directories

    3. Run: $(basename "$0") backup-server
EOF
}

list_dirs() {
    local show_remote=false
    if [ -n "$REMOTE_HOST" ]; then
        # Test connection quickly
        if ssh -o ConnectTimeout=3 "$REMOTE_HOST" "echo 'ok'" &>/dev/null; then
            show_remote=true
        fi
    fi

    echo "Directories to sync:"
    echo "===================="
    for dir in "${SYNC_DIRS[@]}"; do
        local local_exists=false
        local local_size=""
        local remote_exists=false
        local remote_size=""
        
        if [ -d "$dir" ]; then
            local_exists=true
            local_size=$(du -sh "$dir" 2>/dev/null | cut -f1)
        fi
        
        if [ "$show_remote" = "true" ]; then
            local relative_path="${dir#$HOME/}"
            remote_size=$(ssh "$REMOTE_HOST" "if [ -d ~/$relative_path ]; then du -sh ~/$relative_path 2>/dev/null | cut -f1; fi" 2>/dev/null)
            if [ -n "$remote_size" ]; then
                remote_exists=true
            fi
        fi
        
        # Display status
        if [ "$local_exists" = "true" ] && [ "$remote_exists" = "true" ]; then
            if [ "$local_size" = "$remote_size" ]; then
                echo -e "${GREEN}✓${NC} $dir"
                echo -e "    Local:  ${GREEN}${local_size}${NC} | Remote: ${GREEN}${remote_size}${NC} ${GREEN}(match)${NC}"
            else
                echo -e "${GREEN}✓${NC} $dir"
                echo -e "    Local:  ${BLUE}${local_size}${NC} | Remote: ${BLUE}${remote_size}${NC} ${YELLOW}(diff)${NC}"
            fi
        elif [ "$local_exists" = "true" ]; then
            echo -e "${GREEN}✓${NC} $dir"
            if [ "$show_remote" = "true" ]; then
                echo -e "    Local:  ${GREEN}${local_size}${NC} | Remote: ${YELLOW}(not found)${NC}"
            else
                echo -e "    Local:  ${GREEN}${local_size}${NC}"
            fi
        elif [ "$remote_exists" = "true" ]; then
            echo -e "${YELLOW}✗${NC} $dir"
            echo -e "    Local:  ${YELLOW}(not found)${NC} | Remote: ${GREEN}${remote_size}${NC}"
        else
            echo -e "${YELLOW}✗${NC} $dir (not found)"
        fi
    done
    echo
    echo "Total directories: ${#SYNC_DIRS[@]}"
    echo
    echo "Files to sync:"
    echo "===================="
    for file in "${SYNC_FILES[@]}"; do
        local local_exists=false
        local local_size=""
        local remote_exists=false
        local remote_size=""
        
        if [ -f "$file" ]; then
            local_exists=true
            local_size=$(du -sh "$file" 2>/dev/null | cut -f1)
        fi
        
        if [ "$show_remote" = "true" ]; then
            local relative_path="${file#$HOME/}"
            remote_size=$(ssh "$REMOTE_HOST" "if [ -f ~/$relative_path ]; then du -sh ~/$relative_path 2>/dev/null | cut -f1; fi" 2>/dev/null)
            if [ -n "$remote_size" ]; then
                remote_exists=true
            fi
        fi
        
        # Display status
        if [ "$local_exists" = "true" ] && [ "$remote_exists" = "true" ]; then
            if [ "$local_size" = "$remote_size" ]; then
                echo -e "${GREEN}✓${NC} $file"
                echo -e "    Local:  ${GREEN}${local_size}${NC} | Remote: ${GREEN}${remote_size}${NC} ${GREEN}(match)${NC}"
            else
                echo -e "${GREEN}✓${NC} $file"
                echo -e "    Local:  ${BLUE}${local_size}${NC} | Remote: ${BLUE}${remote_size}${NC} ${YELLOW}(diff)${NC}"
            fi
        elif [ "$local_exists" = "true" ]; then
            echo -e "${GREEN}✓${NC} $file"
            if [ "$show_remote" = "true" ]; then
                echo -e "    Local:  ${GREEN}${local_size}${NC} | Remote: ${YELLOW}(not found)${NC}"
            else
                echo -e "    Local:  ${GREEN}${local_size}${NC}"
            fi
        elif [ "$remote_exists" = "true" ]; then
            echo -e "${YELLOW}✗${NC} $file"
            echo -e "    Local:  ${YELLOW}(not found)${NC} | Remote: ${GREEN}${remote_size}${NC}"
        else
            echo -e "${YELLOW}✗${NC} $file (not found)"
        fi
    done
    echo
    echo "Total files: ${#SYNC_FILES[@]}"
    echo
    echo "Exclude patterns:"
    for pattern in "${EXCLUDE_PATTERNS[@]}"; do
        echo "  - $pattern"
    done
}

check_remote_host() {
    log "Testing connection to $REMOTE_HOST..."
    if ! ssh -o ConnectTimeout=5 "$REMOTE_HOST" "echo 'Connection successful'" &>/dev/null; then
        error "Cannot connect to $REMOTE_HOST. Check your SSH config and network connection."
    fi
    log "Connection successful!"
}

build_exclude_args() {
    local exclude_args=""
    for pattern in "${EXCLUDE_PATTERNS[@]}"; do
        exclude_args="$exclude_args --exclude='$pattern'"
    done
    echo "$exclude_args"
}

verify_backup() {
    check_remote_host

    echo "Verifying backup on $REMOTE_HOST..."
    echo "=========================================="
    echo

    local all_match=true

    for dir in "${SYNC_DIRS[@]}"; do
        if [ ! -d "$dir" ]; then
            warn "Local directory not found: $dir"
            continue
        fi

        local relative_path="${dir#$HOME/}"

        info "Checking: $relative_path"

        # Get local size
        local local_size=$(du -sb "$dir" 2>/dev/null | awk '{print $1}')

        # Get remote size
        local remote_size=$(ssh "$REMOTE_HOST" "du -sb ~/$relative_path 2>/dev/null | awk '{print \$1}'" 2>/dev/null)

        if [ -z "$remote_size" ]; then
            warn "  Remote directory not found or inaccessible"
            all_match=false
            continue
        fi

        # Calculate percentage difference
        local diff=$((local_size - remote_size))
        local abs_diff=${diff#-}
        local percent_diff=0

        if [ "$local_size" -gt 0 ]; then
            percent_diff=$((abs_diff * 100 / local_size))
        fi

        # Convert to human readable
        local local_human=$(numfmt --to=iec-i --suffix=B $local_size 2>/dev/null || echo "$local_size bytes")
        local remote_human=$(numfmt --to=iec-i --suffix=B $remote_size 2>/dev/null || echo "$remote_size bytes")

        echo "  Local:  $local_human"
        echo "  Remote: $remote_human"

        if [ "$percent_diff" -lt 5 ]; then
            log "  ✓ Match (${percent_diff}% difference)"
        elif [ "$percent_diff" -lt 20 ]; then
            warn "  ⚠ Close (${percent_diff}% difference - likely due to excludes)"
        else
            warn "  ✗ Mismatch (${percent_diff}% difference)"
            all_match=false
        fi
        echo
    done

    echo "=========================================="
    if [ "$all_match" = true ]; then
        log "Verification complete: All directories verified"
    else
        warn "Verification complete: Some directories have issues"
        return 1
    fi
}

sync_file() {
    local file="$1"
    local direction="$2"
    local dry_run="$3"

    if [ ! -f "$file" ] && [ "$direction" = "push" ]; then
        warn "File not found, skipping: $file"
        ERROR_LOG+=("File not found: $file")
        return 1
    fi

    local cmd="rsync -avz --progress"

    if [ "$dry_run" = "true" ]; then
        cmd="$cmd --dry-run"
    fi

    if [ "$BANDWIDTH_LIMIT" -gt 0 ]; then
        cmd="$cmd --bwlimit=$BANDWIDTH_LIMIT"
    fi

    local relative_path="${file#$HOME/}"
    local error_file=$(mktemp)

    if [ "$direction" = "push" ]; then
        info "Syncing file: $file -> $REMOTE_HOST:~/$relative_path"
        cmd="$cmd '$file' '$REMOTE_HOST:~/$relative_path'"
    else
        info "Syncing file: $REMOTE_HOST:~/$relative_path -> $file"
        mkdir -p "$(dirname "$file")"
        cmd="$cmd '$REMOTE_HOST:~/$relative_path' '$file'"
    fi

    set +e
    eval "$cmd" 2>"$error_file"
    local exit_code=$?
    set -e

    if [ $exit_code -eq 0 ]; then
        log "✓ Synced: $file"
    elif [ $exit_code -eq 23 ]; then
        warn "⚠ Partially synced: $file"
        if [ -s "$error_file" ]; then
            ERROR_LOG+=("Partial sync of $file:")
            while IFS= read -r line; do
                ERROR_LOG+=("  $line")
            done < "$error_file"
        fi
    else
        warn "✗ Failed to sync (exit code $exit_code): $file"
        if [ -s "$error_file" ]; then
            ERROR_LOG+=("Failed sync of $file (exit code $exit_code):")
            while IFS= read -r line; do
                ERROR_LOG+=("  $line")
            done < "$error_file"
        fi
    fi

    rm -f "$error_file"
    echo

    return 0  # Always return 0 to continue with other files
}

sync_directory() {
    local dir="$1"
    local direction="$2"
    local dry_run="$3"

    if [ ! -d "$dir" ] && [ "$direction" = "push" ]; then
        warn "Directory not found, skipping: $dir"
        ERROR_LOG+=("Directory not found: $dir")
        return 1
    fi

    local cmd="rsync $RSYNC_OPTS"

    # Only use --delete when pushing (local -> remote)
    # When pulling, we don't want to delete files on remote, and --delete would only affect local anyway
    if [ "$direction" = "push" ]; then
        cmd="$cmd --delete"
    fi

    if [ "$dry_run" = "true" ]; then
        cmd="$cmd --dry-run"
    fi

    if [ "$BANDWIDTH_LIMIT" -gt 0 ]; then
        cmd="$cmd --bwlimit=$BANDWIDTH_LIMIT"
    fi

    cmd="$cmd $(build_exclude_args)"

    local relative_path="${dir#$HOME/}"
    local error_file=$(mktemp)

    if [ "$direction" = "push" ]; then
        info "Syncing: $dir -> $REMOTE_HOST:~/$relative_path"
        cmd="$cmd '$dir/' '$REMOTE_HOST:~/$relative_path/'"
    else
        info "Syncing: $REMOTE_HOST:~/$relative_path -> $dir"
        warn "Note: Files on remote will NOT be deleted. Local files not on remote may be deleted."
        mkdir -p "$dir"
        cmd="$cmd '$REMOTE_HOST:~/$relative_path/' '$dir/'"
    fi

    set +e
    eval "$cmd" 2>"$error_file"
    local exit_code=$?
    set -e

    if [ $exit_code -eq 0 ]; then
        log "✓ Synced: $dir"
    elif [ $exit_code -eq 23 ]; then
        warn "⚠ Partially synced (some files skipped): $dir"
        if [ -s "$error_file" ]; then
            ERROR_LOG+=("Partial sync of $dir:")
            while IFS= read -r line; do
                ERROR_LOG+=("  $line")
            done < "$error_file"
        fi
    elif [ $exit_code -eq 24 ]; then
        warn "⚠ Partially synced (some files vanished): $dir"
        if [ -s "$error_file" ]; then
            ERROR_LOG+=("Files vanished during sync of $dir:")
            while IFS= read -r line; do
                ERROR_LOG+=("  $line")
            done < "$error_file"
        fi
    else
        warn "✗ Failed to sync (exit code $exit_code): $dir"
        if [ -s "$error_file" ]; then
            ERROR_LOG+=("Failed sync of $dir (exit code $exit_code):")
            while IFS= read -r line; do
                ERROR_LOG+=("  $line")
            done < "$error_file"
        fi
    fi

    rm -f "$error_file"
    echo

    return 0  # Always return 0 to continue with other directories
}

perform_sync() {
    local direction="$1"
    local dry_run="${2:-false}"

    # Initialize error log array
    ERROR_LOG=()

    if [ "$direction" = "push" ]; then
        info "Starting backup: Local -> $REMOTE_HOST"
        warn "Note: --delete is enabled. Files on remote that don't exist locally will be deleted."
    else
        info "Starting restore: $REMOTE_HOST -> Local"
        log "Note: Remote files are safe. Only local files will be modified/deleted."
    fi

    if [ "$dry_run" = "true" ]; then
        warn "DRY RUN MODE - No changes will be made"
    fi

    echo
    list_dirs
    echo

    if [ "$dry_run" != "true" ]; then
        read -p "Continue with sync? (y/N): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            echo "Operation cancelled."
            exit 0
        fi
    fi

    check_remote_host

    local total=$((${#SYNC_DIRS[@]} + ${#SYNC_FILES[@]}))
    local current=0
    local failed=0
    local partial=0
    local success=0

    # Sync directories
    for dir in "${SYNC_DIRS[@]}"; do
        current=$((current + 1))
        echo "[$current/$total] Processing directory: $dir"
        sync_directory "$dir" "$direction" "$dry_run"
    done

    # Sync files
    for file in "${SYNC_FILES[@]}"; do
        current=$((current + 1))
        echo "[$current/$total] Processing file: $file"
        sync_file "$file" "$direction" "$dry_run"
    done

    # Count results from error log
    success=$total
    local all_items=("${SYNC_DIRS[@]}" "${SYNC_FILES[@]}")
    for item in "${all_items[@]}"; do
        for error in "${ERROR_LOG[@]}"; do
            if [[ "$error" == *"$item"* ]]; then
                success=$((success - 1))
                if [[ "$error" == "Partial sync"* ]] || [[ "$error" == "Files vanished"* ]]; then
                    partial=$((partial + 1))
                else
                    failed=$((failed + 1))
                fi
                break
            fi
        done
    done

    echo
    echo "=========================================="
    echo "Sync Summary:"
    echo "  Success: $success/$total"
    if [ $partial -gt 0 ]; then
        echo "  Partial: $partial (some files skipped)"
    fi
    if [ $failed -gt 0 ]; then
        echo "  Failed: $failed"
    fi
    echo "=========================================="

    if [ "$dry_run" != "true" ]; then
        log "Timestamp: $(date)"
    fi

    # Display detailed errors at the end
    if [ ${#ERROR_LOG[@]} -gt 0 ]; then
        echo
        echo "=========================================="
        echo "Detailed Error Log:"
        echo "=========================================="
        for error_line in "${ERROR_LOG[@]}"; do
            echo "$error_line"
        done
        echo "=========================================="
        echo
    fi

    if [ $failed -gt 0 ]; then
        return 1
    fi
}

main() {
    local action="push"
    local dry_run="false"
    local verify_mode="false"
    local single_dir=""
    local list_mode="false"

    while [ $# -gt 0 ]; do
        case "$1" in
            -h|--help)
                show_help
                exit 0
                ;;
            -l|--list)
                list_mode="true"
                ;;
            -v|--verify)
                verify_mode="true"
                ;;
            -d|--dir)
                shift
                if [ -z "$1" ]; then
                    error "Missing argument for --dir"
                fi
                single_dir="${1/#\~/$HOME}"
                ;;
            -p|--pull)
                action="pull"
                ;;
            --dry-run)
                dry_run="true"
                ;;
            --bwlimit)
                shift
                if [ -z "$1" ]; then
                    error "Missing argument for --bwlimit"
                fi
                BANDWIDTH_LIMIT="$1"
                ;;
            -*)
                error "Unknown option: $1\nRun with --help for usage information."
                ;;
            *)
                REMOTE_HOST="$1"
                ;;
        esac
        shift
    done

    # Handle --list mode (can work with or without remote host)
    if [ "$list_mode" = "true" ]; then
        list_dirs
        exit 0
    fi

    if [ -z "$REMOTE_HOST" ]; then
        error "Remote host is required.\nUsage: $(basename "$0") [OPTIONS] REMOTE_HOST\nRun with --help for more information."
    fi

    # If single directory specified, validate and override SYNC_DIRS
    if [ -n "$single_dir" ]; then
        local found=false
        for dir in "${SYNC_DIRS[@]}"; do
            if [ "$dir" = "$single_dir" ]; then
                found=true
                break
            fi
        done

        if [ "$found" = false ]; then
            error "Directory not in SYNC_DIRS: $single_dir\nRun with --list to see available directories."
        fi

        SYNC_DIRS=("$single_dir")
        log "Syncing single directory: $single_dir"
    fi

    if [ "$verify_mode" = "true" ]; then
        verify_backup
    else
        perform_sync "$action" "$dry_run"
    fi
}

main "$@"
