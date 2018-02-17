# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
user=$(whoami)
  export ZSH=/home/$user/.oh-my-zsh

# Set name of the theme to load. Optionally, if you set this to "random"
# it'll load a random theme each time that oh-my-zsh is loaded.
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
#ZSH_THEME="michelebologna"
ZSH_THEME="yoni"
#"powerlevel9k/powerlevel9k"


#"spaceship"
#michelebologna/af-magic"
#powerlevel9k/powerlevel9k"
#"robbyrussell"

# Set list of themes to load
# Setting this variable when ZSH_THEME=random
# cause zsh load theme from this variable instead of
# looking in ~/.oh-my-zsh/themes/
# An empty array have no effect
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
  git
)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/rsa_id"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

#alias pu="python3.4 ~/projects/tools/shell/upgrade.py"
alias py=python3.4

alias mini0="sudo minicom -D /dev/ttyUSB0 -C ~/projects/minicom.log"
alias mini1="sudo minicom -D /dev/ttyUSB1 -C ~/projects/minicom.log"

alias pman="cd ~/projects/sources/apps/pmanager && nvim"
alias core="cd ~/projects/sources/apps/core && nvim"
alias buildroot="cd ~/projects/buildroot"
alias tools="cd ~/projects/tools && nvim"
alias lab="cd ~/projects/lab/client_emulators && nvim"



function pup() {
    while [[ $# -gt 0 ]]
    do
    key="$1"
    case $key in
        -i|--ip)
        IP="$2"
        shift
        shift
        ;;
        -s|--spff)
        SPFF="$2"
        shift
        shift
        ;;
        *)
        shift
        ;;
    esac
    done
    
    if [[ -n "$IP" ]]; then
        python3.4 ~/projects/tools/configure.py -i $IP -p 80
    fi

    if [[ -n "$SPFF" ]]; then
        python3.4 ~/projects/tools/shell/upgrade.py -s $SPFF
    else
        echo "example: pup -s <upgrade_file.spff> (-i 0.0.0.0)"
    fi
}

function smake(){
    cd ~/projects/buildroot/
    make clean
    rm ~/projects/buildroot/dl/*
    make menuconfig
    make 
}

function help() {
	echo "********************* pup ***********************"
	echo "The command 'pup' send an spff file to the porita"
	echo "The argument -i, --ip is optional, It will change the configuration.json file"
	echo "example: pup -s <upgrade_file.spff> (-i 0.0.0.0)"
	echo 

	echo "********************* py ***********************"
	echo "Run python3.4"

	echo "********************* mini0 / mini1***********************"
	echo "Run minicom on ttyUSBX and save to log in ~/project/minicom.log"
}
