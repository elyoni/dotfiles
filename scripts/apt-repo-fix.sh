#!/bin/bash
# Interactive APT repository GPG key / signature fixer
# Usage: sudo apt-repo-fix.sh [--dry-run]

set -euo pipefail

DRY_RUN=false
[[ "${1:-}" == "--dry-run" ]] && DRY_RUN=true

# ── colours ──────────────────────────────────────────────────────────────────
RED='\033[0;31m'; YELLOW='\033[1;33m'; GREEN='\033[0;32m'
CYAN='\033[0;36m'; BOLD='\033[1m'; RESET='\033[0m'

info()    { echo -e "${CYAN}ℹ  $*${RESET}"; }
ok()      { echo -e "${GREEN}✓  $*${RESET}"; }
warn()    { echo -e "${YELLOW}⚠  $*${RESET}"; }
err()     { echo -e "${RED}✗  $*${RESET}"; }
header()  { echo -e "\n${BOLD}$*${RESET}"; }
run()     { if $DRY_RUN; then echo -e "${YELLOW}[dry-run] $*${RESET}"; else eval "$*"; fi; }

# ── privilege check ───────────────────────────────────────────────────────────
if [[ $EUID -ne 0 ]]; then
  echo -e "${RED}This script must be run as root (use sudo).${RESET}"
  exit 1
fi

# ── helpers ───────────────────────────────────────────────────────────────────

# Find the sources file(s) that reference a given URL fragment
find_source_files() {
  local url_fragment="$1"
  grep -rls "$url_fragment" \
    /etc/apt/sources.list \
    /etc/apt/sources.list.d/ \
    /etc/apt/sources.list.d/*.sources 2>/dev/null || true
}

# Fetch a GPG key from keyservers and install it
fetch_and_install_key() {
  local key_id="$1"
  local keyring_dir="/usr/share/keyrings"
  local keyring_file="${keyring_dir}/apt-fix-${key_id}.gpg"

  local keyservers=(
    "hkps://keyserver.ubuntu.com"
    "hkps://keys.openpgp.org"
    "hkps://pgp.mit.edu"
  )

  for ks in "${keyservers[@]}"; do
    info "Trying keyserver: $ks"
    if gpg --no-default-keyring \
           --keyring "gnupg-ring:${keyring_file}" \
           --keyserver "$ks" \
           --recv-keys "$key_id" 2>/dev/null; then
      run "chmod 644 '${keyring_file}'"
      ok "Key ${key_id} saved to ${keyring_file}"
      return 0
    fi
  done
  err "Could not fetch key ${key_id} from any keyserver."
  return 1
}

# Fetch a key from the repo's own keyring URL (common pattern: /gpg or /KEY.gpg)
fetch_key_from_repo() {
  local repo_url="$1"
  local key_id="$2"
  local base_url

  # Strip path, keep scheme + host
  base_url=$(echo "$repo_url" | grep -oP '^https?://[^/]+')

  local candidates=(
    "${base_url}/gpg"
    "${base_url}/KEY.gpg"
    "${base_url}/key.gpg"
    "${base_url}/repo.gpg"
    "${base_url}/pubkey.gpg"
  )

  local keyring_dir="/usr/share/keyrings"
  local keyring_file="${keyring_dir}/apt-fix-${key_id}.gpg"

  for url in "${candidates[@]}"; do
    info "Trying repo key URL: $url"
    if curl -fsSL "$url" 2>/dev/null | gpg --dearmor > /tmp/apt-fix-key.gpg 2>/dev/null; then
      if [[ -s /tmp/apt-fix-key.gpg ]]; then
        run "install -o root -g root -m 644 /tmp/apt-fix-key.gpg '${keyring_file}'"
        ok "Key from repo URL saved to ${keyring_file}"
        rm -f /tmp/apt-fix-key.gpg
        return 0
      fi
    fi
  done

  rm -f /tmp/apt-fix-key.gpg
  return 1
}

# Wire a signed-by= directive into the source file for a given key
update_signed_by() {
  local source_file="$1"
  local keyring_file="$2"

  if grep -q "signed-by=" "$source_file" 2>/dev/null; then
    warn "${source_file} already has a signed-by= entry — update it manually if needed."
    return
  fi

  # For .list format: insert signed-by into the options bracket
  if [[ "$source_file" == *.list ]]; then
    # deb [arch=...] URL  →  deb [arch=... signed-by=<keyring>] URL
    if grep -qP '^deb\s+\[' "$source_file"; then
      run "sed -i 's|\] |\] signed-by=${keyring_file} |' '${source_file}'"
    else
      run "sed -i 's|^deb |deb [signed-by=${keyring_file}] |' '${source_file}'"
    fi
    ok "Added signed-by=${keyring_file} to ${source_file}"
  else
    warn "Cannot auto-patch ${source_file} — add 'Signed-By: ${keyring_file}' manually."
  fi
}

# Disable a source file (rename .list → .list.disabled)
disable_repo() {
  local source_file="$1"
  local disabled="${source_file}.disabled"
  run "mv '${source_file}' '${disabled}'"
  ok "Disabled: ${source_file} → ${disabled}"
}

# Delete a source file outright
remove_repo() {
  local source_file="$1"
  run "rm -f '${source_file}'"
  ok "Removed: ${source_file}"
}

# ── collect apt update errors ─────────────────────────────────────────────────

header "Running apt update to detect repository problems…"
apt_output=$(apt-get update 2>&1 || true)

# Only pick lines that contain an actual URL — informational-only lines (no URL) are skipped
problem_lines=$(echo "$apt_output" | grep -P 'NO_PUBKEY|is not signed' | grep -P 'https?://' || true)

if [[ -z "$problem_lines" ]]; then
  ok "No GPG or signature problems detected — all repositories are fine."
  exit 0
fi

echo ""
warn "Found the following issues:"
echo "$problem_lines" | sed 's/^/   /'

# ── parse problems ────────────────────────────────────────────────────────────

# Collect unique (repo_url, key_id) pairs
declare -A seen_repos
declare -a repo_urls=()
declare -a key_ids=()

while IFS= read -r line; do
  # Extract URL — stop at first space (the suite/distro follows the URL)
  url=$(echo "$line" | grep -oP 'https?://\S+' | head -1 || true)
  [[ -z "$url" ]] && continue

  # Extract key IDs after NO_PUBKEY; fall back to UNKNOWN for unsigned repos
  keys=$(echo "$line" | grep -oP '(?<=NO_PUBKEY )[0-9A-Fa-f ]+' | tr ' ' '\n' | grep -v '^$' || true)
  [[ -z "$keys" ]] && keys="UNKNOWN"

  while IFS= read -r key; do
    combo="${url}|${key}"
    if [[ -z "${seen_repos[$combo]+_}" ]]; then
      seen_repos["$combo"]=1
      repo_urls+=("$url")
      key_ids+=("$key")
    fi
  done <<< "$keys"
done <<< "$problem_lines"

# ── interactive fix loop ──────────────────────────────────────────────────────

total=${#repo_urls[@]}
fixed=0
skipped=0

for (( i=0; i<total; i++ )); do
  url="${repo_urls[$i]}"
  key="${key_ids[$i]}"

  header "Problem $((i+1))/${total}"
  echo -e "  Repository : ${BOLD}${url}${RESET}"
  echo -e "  Missing key: ${BOLD}${key}${RESET}"

  # Find which source files reference this repo
  url_fragment=$(echo "$url" | grep -oP '(?<=://).+' | head -1)
  source_files=()
  while IFS= read -r f; do
    [[ -n "$f" ]] && source_files+=("$f")
  done < <(find_source_files "$url_fragment")

  if [[ ${#source_files[@]} -gt 0 ]]; then
    info "Defined in:"
    for f in "${source_files[@]}"; do echo "     $f"; done
  else
    warn "Could not locate the source file for this repository."
  fi

  echo ""
  echo "  What would you like to do?"
  echo "  1) Fix GPG key — fetch from keyserver"
  echo "  2) Fix GPG key — fetch from repo URL"
  echo "  3) Disable repository (rename .list → .list.disabled)"
  echo "  4) Remove repository (delete source file)"
  echo "  5) Show source file content"
  echo "  6) Skip"
  echo ""

  while true; do
    read -r -p "  Choice [1-6]: " choice
    case "$choice" in
      1)
        if [[ "$key" == "UNKNOWN" ]]; then
          err "No key ID detected — cannot fetch from keyserver. Try option 2."
        elif fetch_and_install_key "$key"; then
          keyring_file="/usr/share/keyrings/apt-fix-${key}.gpg"
          for sf in "${source_files[@]}"; do
            update_signed_by "$sf" "$keyring_file"
          done
          (( fixed++ ))
        fi
        break
        ;;
      2)
        if [[ -z "$url" ]]; then
          err "No URL detected — cannot try repo key URL."
        elif fetch_key_from_repo "$url" "${key}"; then
          keyring_file="/usr/share/keyrings/apt-fix-${key}.gpg"
          for sf in "${source_files[@]}"; do
            update_signed_by "$sf" "$keyring_file"
          done
          (( fixed++ ))
        fi
        break
        ;;
      3)
        if [[ ${#source_files[@]} -eq 0 ]]; then
          err "No source file found to disable."
        else
          for sf in "${source_files[@]}"; do disable_repo "$sf"; done
          (( fixed++ ))
        fi
        break
        ;;
      4)
        if [[ ${#source_files[@]} -eq 0 ]]; then
          err "No source file found to remove."
        else
          echo -e "  ${RED}This will permanently delete:${RESET}"
          for sf in "${source_files[@]}"; do echo "     $sf"; done
          read -r -p "  Are you sure? [y/N]: " confirm
          if [[ "${confirm,,}" == "y" ]]; then
            for sf in "${source_files[@]}"; do remove_repo "$sf"; done
            (( fixed++ ))
          else
            warn "Aborted."
          fi
        fi
        break
        ;;
      5)
        for sf in "${source_files[@]}"; do
          echo -e "\n  ${BOLD}--- ${sf} ---${RESET}"
          cat "$sf" 2>/dev/null | sed 's/^/  /'
        done
        # loop again so they can still pick an action
        ;;
      6)
        warn "Skipped."
        (( skipped++ ))
        break
        ;;
      *)
        warn "Please enter a number between 1 and 6."
        ;;
    esac
  done
done

# ── summary ───────────────────────────────────────────────────────────────────

header "Summary"
echo "  Processed : $total"
ok "Fixed/removed: $fixed"
[[ $skipped -gt 0 ]] && warn "Skipped: $skipped"

if [[ $fixed -gt 0 ]]; then
  echo ""
  info "Re-running apt update to verify fixes…"
  if apt-get update 2>&1 | grep -qP 'NO_PUBKEY|is not signed'; then
    warn "Some issues may still remain — run this script again."
  else
    ok "apt update completed without GPG errors."
  fi
fi
