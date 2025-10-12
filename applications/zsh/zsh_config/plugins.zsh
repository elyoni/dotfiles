source "${ZSH_CUSTOM_PLUGIN}"/zsh-autosuggestions/zsh-autosuggestions.zsh

# Temporarily testing Starship instead of P10k
if [[ "$TERM_PROGRAM" != "vscode" ]]; then
    # source ~/.powerlevel10k/powerlevel10k.zsh-theme
    eval "$(starship init zsh)"
fi
