#!/usr/bin/env bash
# Bidirectional sync of ~/.ssh with the remote machine (ypc).
# Conflicts (file differs on both sides) are reported and NOT overwritten
# unless you resolve them interactively with --meld or --nvim.
#
# Usage:
#   sync_ssh.sh sync                -- preview only (dry run by default)
#   sync_ssh.sh sync --apply        -- actually sync (still skips conflicts)
#   sync_ssh.sh sync --meld         -- open each conflict in meld
#   sync_ssh.sh sync --nvim         -- open each conflict in nvim -d (vimdiff)

set -euo pipefail

REMOTE="ypc"
LOCAL_DIR="$HOME/.ssh"
REMOTE_DIR=""         # resolved to absolute path after SSH connection
DRY_RUN=true
RESOLVE_TOOL="none"   # none | meld | nvim
BULK_CHOICE=""        # l or r — set when user picks L/R to apply to all remaining

EXCLUDES=(
    --exclude="sockets/"
    --exclude="*.sock"
    --exclude="ssh-copy-id.*"
    --exclude="known_hosts"
    --exclude="known_hosts.old"
)

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
RESET='\033[0m'

usage() {
    echo "Usage: $0 <subcommand> [options]"
    echo
    echo "Subcommands:"
    echo "  sync          Sync ~/.ssh with remote '$REMOTE'"
    echo
    echo "Options for sync:"
    echo "  --dry-run     Preview changes only (default)"
    echo "  --apply       Write changes to disk"
    echo "  --meld        Open conflicts in meld for interactive resolution"
    echo "  --nvim        Open conflicts in nvim -d (vimdiff) for interactive resolution"
    exit 1
}

parse_sync_args() {
    for arg in "$@"; do
        case "$arg" in
            --apply)   DRY_RUN=false ;;
            --dry-run) DRY_RUN=true ;;
            --meld)    RESOLVE_TOOL="meld"; DRY_RUN=false ;;
            --nvim)    RESOLVE_TOOL="nvim"; DRY_RUN=false ;;
            *)
                echo "Unknown option: $arg"
                usage
                ;;
        esac
    done
}

check_remote_reachable() {
    if ! ssh -o ConnectTimeout=5 -o BatchMode=yes "$REMOTE" true 2>/dev/null; then
        echo -e "${RED}ERROR: Cannot reach remote '$REMOTE'. Make sure you are on the office network or VPN.${RESET}"
        exit 1
    fi
    # Resolve the remote home directory to an absolute path so ~ never causes
    # issues inside single-quoted ssh commands or rsync --files-from paths.
    REMOTE_DIR=$(ssh "$REMOTE" 'printf "%s/.ssh" "$HOME"')
}

# Returns a newline-separated list of file paths that rsync would transfer.
get_changed_files() {
    local src="$1"
    local dst="$2"
    rsync -n -a --checksum --itemize-changes "${EXCLUDES[@]}" "$src/" "$dst/" 2>/dev/null \
        | grep '^[><c]f' \
        | awk '{print $2}' \
        || true
}

find_conflicts_and_uniq() {
    local list_a="$1"
    local list_b="$2"

    comm -12 <(sort "$list_a") <(sort "$list_b") > /tmp/ssh_sync_conflicts
    comm -23 <(sort "$list_a") <(sort "$list_b") > /tmp/ssh_sync_push
    comm -13 <(sort "$list_a") <(sort "$list_b") > /tmp/ssh_sync_pull
}

print_file_list() {
    local label="$1"
    local color="$2"
    local file="$3"

    if [[ -s "$file" ]]; then
        echo -e "${color}${label}${RESET}"
        while IFS= read -r f; do
            echo "  $f"
        done < "$file"
        echo
    fi
}

do_sync() {
    local src="$1"
    local dst="$2"
    local files_file="$3"
    local label="$4"

    [[ -s "$files_file" ]] || return 0

    echo -e "${CYAN}>>> $label${RESET}"

    local rsync_opts=(-a --checksum "${EXCLUDES[@]}" --files-from="$files_file")
    if $DRY_RUN; then
        rsync_opts+=(--dry-run)
    fi

    rsync "${rsync_opts[@]}" "$src/" "$dst/"
    echo
}

show_conflict_diff() {
    local file="$1"
    local local_path="$LOCAL_DIR/$file"
    local remote_tmp
    remote_tmp=$(mktemp)

    echo -e "${RED}--- local/$file${RESET}"
    echo -e "${RED}+++ remote/$file${RESET}"

    if ssh "$REMOTE" "cat '$REMOTE_DIR/$file'" > "$remote_tmp" 2>/dev/null; then
        if file "$local_path" | grep -q "text"; then
            diff --color=always -u "$local_path" "$remote_tmp" || true
        else
            local local_size remote_size
            local_size=$(wc -c < "$local_path")
            remote_size=$(wc -c < "$remote_tmp")
            echo "  [binary file] local size: ${local_size} bytes, remote size: ${remote_size} bytes"
        fi
    else
        echo "  (could not fetch remote file for diff)"
    fi

    rm -f "$remote_tmp"
    echo
}

# Push local file to remote or pull remote file to local — no tool needed.
apply_side() {
    local file="$1"
    local choice="$2"   # l or r
    local local_path="$LOCAL_DIR/$file"

    case "$choice" in
        l)
            rsync -a --checksum "$local_path" "$REMOTE:$REMOTE_DIR/$file"
            echo -e "${GREEN}Pushed local -> remote: $file${RESET}"
            ;;
        r)
            rsync -a --checksum "$REMOTE:$REMOTE_DIR/$file" "$local_path"
            echo -e "${GREEN}Pulled remote -> local: $file${RESET}"
            ;;
    esac
}

# Open the conflict in nvim -d using scp:// for the remote side.
# Both panes are live files — saving either pane writes directly to disk/remote.
# No temp file or extra rsync step needed after closing.
resolve_conflict_nvim() {
    local file="$1"
    local local_path="$LOCAL_DIR/$file"
    # scp://host//absolute/path — double slash because REMOTE_DIR is absolute
    local remote_scp="scp://$REMOTE/$REMOTE_DIR/$file"

    echo -e "${CYAN}[nvim] Opening:${RESET} $file"
    echo "  left  (local)  = $local_path"
    echo "  right (remote) = $remote_scp"
    echo "  Save left (:w) to update local. Save right (:w) to update remote."
    echo "  Use 'do' / 'dp' to copy hunks between panes."
    echo

    nvim -d "$local_path" "$remote_scp" </dev/tty

    echo -e "${YELLOW}Mark as resolved?${RESET}"
    echo "  y) yes, move to next file"
    echo "  L) local wins for ALL remaining (no tool, direct rsync)"
    echo "  R) remote wins for ALL remaining (no tool, direct rsync)"
    echo "  s) skip (leave both sides unchanged)"
    printf "Choice [y/L/R/s]: "
    read -r choice </dev/tty

    case "$choice" in
        y|Y) echo -e "${GREEN}Resolved: $file${RESET}" ;;
        L)   BULK_CHOICE="l"; echo -e "${GREEN}Bulk local set. Remaining files will skip the tool.${RESET}" ;;
        R)   BULK_CHOICE="r"; echo -e "${GREEN}Bulk remote set. Remaining files will skip the tool.${RESET}" ;;
        *)   echo -e "${YELLOW}Skipped: $file${RESET}" ;;
    esac
    echo
}

# Fetch the remote copy of $file into a temp file, open in meld,
# then ask the user which side to keep.
resolve_conflict_meld() {
    local file="$1"
    local local_path="$LOCAL_DIR/$file"
    local remote_tmp
    remote_tmp=$(mktemp --suffix=".$(basename "$file").REMOTE")

    if ! ssh "$REMOTE" "cat '$REMOTE_DIR/$file'" > "$remote_tmp" 2>/dev/null; then
        echo -e "${RED}Could not fetch remote '$file'. Skipping.${RESET}"
        rm -f "$remote_tmp"
        return
    fi

    echo -e "${CYAN}[meld] Opening:${RESET} $file"
    echo "  left  (local)  = $local_path"
    echo "  right (remote) = $remote_tmp"
    echo "  Edit either side, save, then close."
    echo

    meld "$local_path" "$remote_tmp" 2>/dev/null

    echo -e "${YELLOW}Tool closed. Which version do you want to keep?${RESET}"
    echo "  l) local  -> push local to remote"
    echo "  r) remote -> pull remote to local"
    echo "  L) local  -> push local to remote for ALL remaining"
    echo "  R) remote -> pull remote to local for ALL remaining"
    echo "  s) skip   -> leave both sides unchanged"
    printf "Choice [l/r/L/R/s]: "
    read -r choice </dev/tty

    case "$choice" in
        L) BULK_CHOICE="l"; apply_side "$file" "l" ;;
        R) BULK_CHOICE="r"; apply_side "$file" "r" ;;
        l) apply_side "$file" "l" ;;
        r) apply_side "$file" "r" ;;
        *) echo -e "${YELLOW}Skipped: $file${RESET}" ;;
    esac

    rm -f "$remote_tmp"
    echo
}

resolve_conflict() {
    local file="$1"
    local tool="$2"
    case "$tool" in
        nvim) resolve_conflict_nvim "$file" ;;
        meld) resolve_conflict_meld "$file" ;;
    esac
}

cmd_sync() {
    parse_sync_args "$@"

    case "$RESOLVE_TOOL" in
        meld) echo -e "${CYAN}[MELD MODE] Conflicts will open in meld.${RESET}" ;;
        nvim) echo -e "${CYAN}[NVIM MODE] Conflicts will open in nvim -d.${RESET}" ;;
        *)
            if $DRY_RUN; then
                echo -e "${YELLOW}[DRY RUN] No files will be written. Run with --apply to sync.${RESET}"
            else
                echo -e "${GREEN}[APPLY MODE] Changes will be written.${RESET}"
            fi
            ;;
    esac
    echo

    echo "Checking remote connection..."
    check_remote_reachable
    echo "Remote '$REMOTE' is reachable."
    echo

    echo "Comparing ~/.ssh on local and remote (this may take a moment)..."

    get_changed_files "$LOCAL_DIR"        "$REMOTE:$REMOTE_DIR" > /tmp/ssh_sync_local_diff
    get_changed_files "$REMOTE:$REMOTE_DIR" "$LOCAL_DIR"        > /tmp/ssh_sync_remote_diff

    find_conflicts_and_uniq /tmp/ssh_sync_local_diff /tmp/ssh_sync_remote_diff

    local conflicts_count push_count pull_count
    conflicts_count=$(wc -l < /tmp/ssh_sync_conflicts || echo 0)
    push_count=$(wc -l < /tmp/ssh_sync_push || echo 0)
    pull_count=$(wc -l < /tmp/ssh_sync_pull || echo 0)

    [[ "$conflicts_count" -gt 0 && -s /tmp/ssh_sync_conflicts ]] || conflicts_count=0
    [[ "$push_count"      -gt 0 && -s /tmp/ssh_sync_push      ]] || push_count=0
    [[ "$pull_count"      -gt 0 && -s /tmp/ssh_sync_pull      ]] || pull_count=0

    if [[ $conflicts_count -eq 0 && $push_count -eq 0 && $pull_count -eq 0 ]]; then
        echo -e "${GREEN}Everything is in sync. Nothing to do.${RESET}"
        exit 0
    fi

    print_file_list "FILES TO PUSH (local -> remote):"          "$GREEN"  /tmp/ssh_sync_push
    print_file_list "FILES TO PULL (remote -> local):"          "$CYAN"   /tmp/ssh_sync_pull
    print_file_list "CONFLICTS (differ on both sides - SKIPPED):" "$RED"  /tmp/ssh_sync_conflicts

    if [[ $conflicts_count -gt 0 ]]; then
        if [[ "$RESOLVE_TOOL" != "none" ]]; then
            echo -e "${YELLOW}Resolving conflicts with $RESOLVE_TOOL (L/R to apply same choice to all remaining):${RESET}"
            echo
            while IFS= read -r f; do
                if [[ -n "$BULK_CHOICE" ]]; then
                    echo -e "${CYAN}[bulk] $f${RESET}"
                    apply_side "$f" "$BULK_CHOICE"
                else
                    resolve_conflict "$f" "$RESOLVE_TOOL"
                fi
            done < /tmp/ssh_sync_conflicts
        else
            echo -e "${YELLOW}Showing diffs for conflicting files:${RESET}"
            echo
            while IFS= read -r f; do
                show_conflict_diff "$f"
            done < /tmp/ssh_sync_conflicts
            echo -e "${RED}Fix conflicts manually, or use --meld / --nvim to resolve interactively.${RESET}"
            echo
        fi
    fi

    do_sync "$LOCAL_DIR"          "$REMOTE:$REMOTE_DIR" /tmp/ssh_sync_push "Pushing local files to remote"
    do_sync "$REMOTE:$REMOTE_DIR" "$LOCAL_DIR"          /tmp/ssh_sync_pull "Pulling remote files to local"

    if $DRY_RUN; then
        echo -e "${YELLOW}This was a dry run. Run with --apply to apply the changes above.${RESET}"
    else
        echo -e "${GREEN}Sync complete.${RESET}"
        if [[ $conflicts_count -gt 0 && "$RESOLVE_TOOL" == "none" ]]; then
            echo -e "${RED}${conflicts_count} conflict(s) were skipped. Fix them manually.${RESET}"
        fi
    fi

    rm -f /tmp/ssh_sync_local_diff /tmp/ssh_sync_remote_diff \
          /tmp/ssh_sync_conflicts /tmp/ssh_sync_push /tmp/ssh_sync_pull
}

main() {
    local subcommand="${1:-}"
    shift || true

    case "$subcommand" in
        sync) cmd_sync "$@" ;;
        ""|--help|-h) usage ;;
        *)
            echo "Unknown subcommand: $subcommand"
            usage
            ;;
    esac
}

main "$@"
