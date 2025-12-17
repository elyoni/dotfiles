source "${ZSH_CUSTOM_PLUGIN}"/zsh-autosuggestions/zsh-autosuggestions.zsh

# Temporarily testing Starship instead of P10k
# Optimized: cache starship init to avoid subprocess on every shell start
if [[ "$TERM_PROGRAM" != "vscode" ]]; then
    # source ~/.powerlevel10k/powerlevel10k.zsh-theme
    local starship_cache="${XDG_CACHE_HOME:-$HOME/.cache}/starship_init.zsh"
    if [[ ! -f "$starship_cache" || "$starship_cache" -ot "${commands[starship]}" ]]; then
        starship init zsh > "$starship_cache"
    fi
    source "$starship_cache"
fi
