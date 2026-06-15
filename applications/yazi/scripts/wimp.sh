#!/usr/bin/env bash
# Jump to a project using wimp-style git-repo detection, then navigate yazi there.
# Paths mirror WIMP_PROJECTS_PATH / WIMP_EXCLUDE_PATH in zsh/zshrc.

PROJECTS_PATHS=("${HOME}/private" "${HOME}/projects")
EXCLUDE_PATHS=('**/yocto-setup/**/*' '**/buildroot/dl/' '**private/rust_book/' '**/buildroot/support')

SEARCH_ARGS=()
for p in "${PROJECTS_PATHS[@]}"; do
  [ -d "$p" ] && SEARCH_ARGS+=(--search-path "$p")
done

if [ ${#SEARCH_ARGS[@]} -eq 0 ]; then
  echo "No valid project paths found."
  read -r
  exit 1
fi

EXCLUDE_ARGS=()
for e in "${EXCLUDE_PATHS[@]}"; do
  EXCLUDE_ARGS+=(--exclude "$e")
done

output=$(fdfind \
  --no-ignore \
  --type directory \
  --hidden \
  "${SEARCH_ARGS[@]}" \
  "\.git$" \
  "${EXCLUDE_ARGS[@]}" \
  --absolute-path \
  --exec bash -c 'dirname {}' | \
  fzf \
    --height 30 \
    --header-first --header "Enter(jump), Ctrl-C(cancel)" \
    --border --border-label="╢ Where is my project! ╟" \
    --info=right \
    --prompt="🔍 Project>" \
    --history="${HOME}/.config/wimp/history" \
    --preview 'tree -d -L 1 -C {} | head -200' \
    --preview-window=up)

[ -n "$output" ] && ya emit cd "$output"
