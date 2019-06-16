autoload -U +X bashcompinit && bashcompinit
autoload -U +X compinit && compinit
fpath=(~/.zsh/completion $fpath) 
zstyle ":completion:*:descriptions" format "%B%d%b"
# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
user=$(whoami)
  export ZSH=/home/$user/.oh-my-zsh

TRAPWINCH() {
  zle && { zle reset-prompt; zle -R }
}

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
source $HOME/projects/tools/configurations

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

# Source
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
[ -f ~/.zsh/portia_functions ] && source ~/.zsh/portia_functions

export PROJECTS_DIR="~/projects"
export BUILDROOT_DIR="~/projects/buildroot"
export IMAGES_DIR="~/projects/buildroot/output/images"
export CORE_DIR="~/projects/sources/apps/core"
export PMANAGER_DIR="~/projects/sources/apps/pmanager"
export WEB_DIR="~/projects/sources/apps/web"
export CURATOR_DIR="~/projects/sources/apps/curator"
export APPS_DIR="~/projects/sources/apps"
export LIBS_DIR="~/projects/sources/libs"
export MQTTC_DIR="~/projects/sources/libs/mqttc"
export SOURCES_DIR="~/projects/sources"
export PROTO_DIR="~/projects/proto"
export TOOLS_DIR="~/projects/tools"
export SHELL_DIR="~/projects/tools/shell"
export UTILS_DIR="~/projects/tools/utils"
export LAB_DIR="~/projects/lab"
export REG_DIR="~/projects/lab/applications/regression"

function sscp(){ 
    #Simple SCP 
    scp -r -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no ${@:1:(($#)-1)} "${@: -1}"
}

function sssh(){
    #Simple SCP 
    ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no "${@: -1}"
}

# ========= Aliases =============
alias py=python3.4

alias mini0="sudo minicom -D /dev/ttyUSB0 -C ~/projects/minicom0.log"
alias mini1="sudo minicom -D /dev/ttyUSB1 -C ~/projects/minicom1.log"

alias cdpman="cd ~/projects/sources/apps/pmanager"
alias cdcore="cd ~/projects/sources/apps/core"
alias cdbuildroot="cd ~/projects/buildroot"
alias cdtools="cd ~/projects/tools"
alias cdshell="cd ~/projects/tools/shell"
alias cdlab="cd ~/projects/lab/"
alias cdutils="cd ~/projects/tools/utils/"
alias tm="tmux a -t minicom"
alias tt="tmux a -t test"
alias vm="vifm $PWD"
alias pip="source ~/projects/tools/env/zsh/update_ip.sh"
alias vi="nvim"


# ======= Docker ================
alias drm="docker rm"
alias dps="docker ps"
alias boxclean="docker container prune"

function run_docker() {
    mkdir $PROJECTS -p

    docker run -it \
    --name ${SYSTEM}${NUMBER} \
    --hostname ${USER}-docker\
    -v ${PROJECTS}:/home/devbox/projects \
    -v ${HOME}/.ssh:/home/devbox/.ssh \
    -v ${HOME}/.gitconfig:/home/devbox/.gitconfig \
    -v ${HOME}/.zshrc:/home/devbox/.zsh_host/.zshrc \
    -v ${HOME}/.dotfiles/zsh/yoni.zsh-theme:/home/devbox/.oh-my-zsh/themes/yoni.zsh-theme \
    -v ${HOME}/.dotfiles/tmux/tmux.conf:/home/devbox/.tmux.conf \
    -v ${HOME}/.zsh_history:/home/devbox/.zsh_host/.zsh_history \
    --network=host \
    -p 22:22${NUMBER} \
    -e DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix \
    emb-jenk-slv01:5000/devbox:latest
}

function boxnew() {
    SYSTEM="devbox"
    NUMBER="0"

    while [[ $# -gt 0 ]]; do
        key="$1"
        case $key in
            -s|--system)
            SYSTEM="$2"
            shift # past value
            shift # past value
            ;;
            -n|--number)
            NUMBER="$2"
            shift # past argument
            shift # past value
            ;;
            *)    # unknown option
            shift # past argument
            ;;
        esac
    done
    echo ${SYSTEM}${NUMBER}
    if [ $SYSTEM = "local" ]; then
        PROJECTS="${HOME}/projects"
    else
        PROJECTS=${HOME}/docker/${SYSTEM}/projects
    fi

    if [ ! "$(docker ps -a | grep ${SYSTEM}${NUMBER})" ]; then
        run_docker 
    elif docker inspect -f '{{.State.Status}}' ${SYSTEM}${NUMBER} | grep -q exited; then
        docker start ${SYSTEM}${NUMBER}
        docker attach ${SYSTEM}${NUMBER}
    elif docker inspect -f '{{.State.Status}}'  ${SYSTEM}${NUMBER}| grep -q running; then
        docker attach ${SYSTEM}${NUMBER}
    else 
        echo Unknown what to do
    fi
}
#docker run -it --name debox --hostname ${USER}-docker -v ${HOME}/docker/debox/projects:/home/devbox/projects -v ${HOME}/.ssh:/home/devbox/.ssh -v ${HOME}/.gitconfig:/home/devbox/.gitconfig -v ${HOME}/.zshrc:/home/devbox/.zsh_host/.zshrc -v ${HOME}/.dotfiles/zsh/yoni.zsh-theme:/home/devbox/.oh-my-zsh/themes/yoni.zsh-theme -v ${HOME}/.dotfiles/tmux/tmux.conf:/home/devbox/.tmux.conf emb-jenk-slv01:5000/devbox:latest


function boxpull() {
    IMAGE=${1:-devbox}
    docker pull emb-jenk-slv01:5000/${IMAGE}:latest
}


function ip_temp(){
    python3.4 ~/projects/tools/configure.py -i $1
    #source ~/projects/tools/configurations
}
