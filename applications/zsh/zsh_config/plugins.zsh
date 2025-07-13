source "${ZSH_CUSTOM_PLUGIN}"/zsh-autosuggestions/zsh-autosuggestions.zsh

if [[ "$TERM_PROGRAM" != "vscode" ]]; then
    source ~/.powerlevel10k/powerlevel10k.zsh-theme
fi
