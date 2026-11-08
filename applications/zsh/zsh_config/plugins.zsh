# Load custom plugins
if [[ -n "$ZSH_CUSTOM_PLUGIN" && -d "$ZSH_CUSTOM_PLUGIN" ]]; then
    for plugin_dir in "$ZSH_CUSTOM_PLUGIN"/*/; do
        for plugin_file in "$plugin_dir"*.zsh(N); do
            [[ "$plugin_file" == *".plugin.zsh" ]] && continue
            source "$plugin_file" || echo "Error sourcing $plugin_file"
        done
    done
fi

source "${ZSH_CUSTOM_PLUGIN}"/zsh-autosuggestions/zsh-autosuggestions.zsh

# Starship prompt
# Optimized: cache starship init to avoid subprocess on every shell start
if [[ "$CURSOR_AGENT" != "1" ]]; then
    local starship_cache="${XDG_CACHE_HOME:-$HOME/.cache}/starship_init.zsh"
    if [[ ! -f "$starship_cache" || "$starship_cache" -ot "${commands[starship]}" ]]; then
        starship init zsh > "$starship_cache"
    fi
    source "$starship_cache"
fi
