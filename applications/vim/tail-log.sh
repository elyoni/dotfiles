#!/usr/bin/env bash
# Enhanced tail with syntax highlighting for log files
# This script provides real-time tail -f with vim syntax highlighting

function _usage() {
    cat << EOF
Usage: $0 [OPTIONS] <file>

Options:
    -f, --follow      Follow file (like tail -f) - default behavior
    -n, --lines N     Show last N lines (default: 50)
    -h, --help        Show this help message

Examples:
    $0 /var/log/messages.log
    $0 -n 100 /var/log/messages.log
    $0 -f /var/log/messages.log

Note: For follow mode, the file will auto-refresh in vim.
      Press 'G' to jump to end, and the file updates automatically.
EOF
}

function _tail_log() {
    local follow_mode=true
    local lines=50
    local file=""
    
    # Parse arguments
    while [[ $# -gt 0 ]]; do
        case "$1" in
            -f|--follow)
                follow_mode=true
                shift
                ;;
            -n|--lines)
                lines="$2"
                follow_mode=false
                shift 2
                ;;
            -h|--help)
                _usage
                return 0
                ;;
            -*)
                echo "Unknown option: $1" >&2
                _usage
                return 1
                ;;
            *)
                if [[ -z "$file" ]]; then
                    file="$1"
                else
                    echo "Error: Multiple files specified" >&2
                    _usage
                    return 1
                fi
                shift
                ;;
        esac
    done
    
    if [[ -z "$file" ]]; then
        echo "Error: No file specified" >&2
        _usage
        return 1
    fi
    
    if [[ ! -f "$file" ]]; then
        echo "Error: File not found: $file" >&2
        return 1
    fi
    
    if [[ "$follow_mode" == true ]]; then
        # Follow mode - open in vim with auto-refresh
        vim -R \
            -c "set filetype=log" \
            -c "set syntax=log" \
            -c "set autoread" \
            -c "set autowriteall" \
            -c "set updatetime=1000" \
            -c "autocmd FocusGained,BufEnter,CursorHold,CursorHoldI * checktime" \
            -c "autocmd FileChangedShellPost * echohl WarningMsg | echo 'File changed on disk. Buffer reloaded.' | echohl None" \
            -c "map <F5> :checktime<CR>" \
            "$file" \
            +"normal G" \
            +"echo 'Press F5 to refresh, or move cursor to auto-refresh'"
    else
        # Show last N lines
        tail -n "$lines" "$file" | vim -R \
            -c "set filetype=log" \
            -c "set syntax=log" \
            -c "set nomodifiable" \
            -
    fi
}

# Main
_tail_log "$@"
