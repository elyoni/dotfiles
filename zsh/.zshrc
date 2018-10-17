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
VISUAL=nvim; export VISUAL EDITOR=nvim; export EDITOR

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

alias mini0="sudo minicom -D /dev/ttyUSB0 -C ~/projects/minicom0.log"
alias mini1="sudo minicom -D /dev/ttyUSB1 -C ~/projects/minicom1.log"

alias cdpman="cd ~/projects/sources/apps/pmanager"
alias cdcore="cd ~/projects/sources/apps/core"
alias cdbuildroot="cd ~/projects/buildroot"
alias cdtools="cd ~/projects/tools"
alias cdshell="cd ~/projects/tools/shell"
alias cdlab="cd ~/projects/lab/client_emulators"

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
        python3.4 ~/projects/tools/configure.py -i "$IP" -p "80"
        unset IP
    elif [[ -n "$SPFF" ]]; then
        python3.4 ~/projects/tools/shell/upgrade.py -s $SPFF
        unset SPFF
    else
        echo "example: pup -s <upgrade_file.spff> (-i 0.0.0.0)"
    fi
}

function read_pb(){
    while [[ $# -gt 0 ]]
    do
    key="$1"
    case $key in
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
    if [[ -n "$SPFF" ]]; then
        python3.4 ~/projects/tools/utils/spff_tools/read_pb_spff_file/read_pb_spff_file.py -s $SPFF -p ~/project/proto
        unset SPFF
    else
        echo "example: read_pb -s <file.spff>"
    fi
}

function id() {
    python3.4 ~/projects/tools/shell/identity.py
}

function id_dsp() {
    python3.4 ~/projects/tools/shell/dsps_identity.py
}


function params() {
    while [[ $# -gt 0 ]]
    do
    arg="$1"
    case $arg in
        -p|--param)
        params_index="$2"
        shift
        shift
        ;;
        -v|--val)
        value="$2"
        shift
        shift
        ;;
        *)
        shift
        ;;
    esac
    done
    if [[ -n "$params_index" ]]; then
        python3.4 ~/projects/tools/shell/params.py -p "$params_index"
        unset params_index
        unset value
    elif [[ -n "$value" ]]; then
        python3.4 ~/projects/tools/shell/params.py -p "$params_index" -v "$value"
        unset params_index
        unset value
    else
        echo "example: params -p <param_index> -v [value]"
    fi
}

function smake(){
    cd ~/projects/buildroot/
    make clean
    rm ~/projects/buildroot/dl/*
    make menuconfig
    make 
}
function sscp(){ 
    #Simple SCP 
    scp -r -o ConnectTimeout=5 -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no $1 $2 
}

function make_core(){
    cd ~/projects/sources/apps/core
    make clean
    make PLATFROM=sama5d2 PROTO_PATH=~/projects/proto
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


