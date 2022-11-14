# Set name of the theme to load. Optionally, if you set this to "random"
# it'll load a random theme each time that oh-my-zsh is loaded.
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
#"spaceship"
#michelebologna/af-magic"
#powerlevel9k/powerlevel9k"
#"robbyrussell"

if [ "$USER" = "devbox" ]; then
    ZSH_THEME="michelebologna"
else
    # ZSH_THEME="yoni"
    ZSH_THEME="yoni_bira"
    if [[ "$RECORDING" == "true"  ]]; then
        ZSH_THEME="record"
    fi
fi

