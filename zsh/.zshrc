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
if [ $USER = "devbox" ]; then
    ZSH_THEME="michelebologna"
else
    ZSH_THEME="yoni"
fi
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
  zsh-syntax-highlighting 
  zsh-autosuggestions
)
source $ZSH/oh-my-zsh.sh
#source $HOME/projects/tools/configurations

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

export PROJECTS_DIR="$HOME/projects"
export BUILDROOT_DIR="$HOME/projects/buildroot"
export IMAGES_DIR="$HOME/projects/buildroot/output/images"
export CORE_DIR="$HOME/projects/sources/apps/core"
export PMANAGER_DIR="$HOME/projects/sources/apps/pmanager"
export WEB_DIR="$HOME/projects/sources/apps/web"
export CURATOR_DIR="$HOME/projects/sources/apps/curator"
export APPS_DIR="$HOME/projects/sources/apps"
export LIBS_DIR="$HOME/projects/sources/libs"
export MQTTC_DIR="$HOME/projects/sources/libs/mqttc"
export SOURCES_DIR="$HOME/projects/sources"
export PROTO_DIR="$HOME/projects/proto"
export TOOLS_DIR="$HOME/projects/tools"
export SHELL_DIR="$HOME/projects/tools/shell"
export UTILS_DIR="$HOME/projects/tools/utils"
export LAB_DIR="$HOME/projects/lab"
export REG_DIR="$HOME/projects/lab/applications/regression"
export PORTIA_LATEST_VER_DTB=""
export PORTIA_LATEST_VER_SPFF=""  
export PORTIA_LATEST_VER_ZIMAGE=""

function sscp(){ 
    #Simple SCP 
    scp -r -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no ${@:1:(($#)-1)} "${@: -1}"
}

function sssh(){
    #Simple SCP 
    ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no "${@: -1}"
}

function rt(){
    # Run test
    python3.4 $@ ; ssh -p 2222 -i ~/.ssh/yoni_laptop yoni@localhost 'DISPLAY=:0 notify-send -u critical Test: "test has finished"'
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
alias cdproto="cd ~/projects/proto"
alias tm0="tmux a -t minicom0"
alias tm1="tmux a -t minicom1"
alias tm_jupiter="tm1"
alias tm_jj="tm0"
alias tt="tmux a -t test"
alias vm="vifm $PWD"
alias gip="source ~/projects/tools/env/zsh/update_ip.sh"
alias vi="nvim"


# ======= Docker ================
alias drm="docker rm"
alias dps="docker ps"
alias boxclean="docker container prune"

function run_docker() {
    mkdir $PROJECTS -p
    echo $PROJECTS

    docker run -it \
    --name ${SYSTEM}${NUMBER} \
    --hostname ${USER}-docker_sys:${SYSTEM}_#:${NUMBER}\
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
function rund()  {
    PROJECTS=~/projects
    docker run -it \
    --name "TestBuild" \
    --hostname ${USER}-docker_sys:testbuild\
    -v ${PROJECTS}:/home/devbox/projects \
    -v ${HOME}/.ssh:/home/devbox/.ssh \
    -v ${HOME}/.gitconfig:/home/devbox/.gitconfig \
    -v ${HOME}/.zshrc:/home/devbox/.zsh_host/.zshrc \
    -v ${HOME}/.dotfiles/zsh/yoni.zsh-theme:/home/devbox/.oh-my-zsh/themes/yoni.zsh-theme \
    -v ${HOME}/.dotfiles/tmux/tmux.conf:/home/devbox/.tmux.conf \
    -v ${HOME}/.zsh_history:/home/devbox/.zsh_host/.zsh_history \
    -v ${HOME}/mnt/m_drive/:/home/devbox/mnt/m_drive/ \
    --network=host \
    -e DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix \
    ${1}
    #emb-jenk-slv01:5000/devbox:python3.5
}

function sip(){
    export PORTIA_IP=$1
    export PORTIA_PORT=80
}
#function newbox() {
    #IMAGE="devbox"
    #DEVICE="/dev/null"
    #while getopts i:d: option
    #do
    #case "${option}"
    #in
    #i) IMAGE=${OPTARG};;
    #d) DEVICE=${OPTARG};;
    #esac
    #done
  
    #docker run -it \
    #-v ${HOME}/.zshrc:/home/devbox/.zshrc2 \
    #-v ${HOME}/docker/${IMAGE}/shared:/home/${IMAGE}/shared \
    #emb-jenk-slv01:5000/${IMAGE}:dev
#}

    #--mount type=bind,src=${HOME}/docker/${IMAGE}/shared,target=/home/${IMAGE}/shared \
    #--mount type=bind,src=${HOME}/.ssh,target=/home/${IMAGE}/.ssh \
    #--mount type=bind,src=${HOME}/.gitconfig,target=/home/${IMAGE}/.gitconfig \
    #--mount type=bind,src=${HOME}/projects/,target=/home/${IMAGE}/projects \
    #--mount type=bind,src=${HOME}/.zsh_history,target=/home/${IMAGE}/.zsh_history \
    #--mount type=bind,src=/mnt,target=/mnt \
    #--device=${DEVICE} \
    #--network="host" \
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
    echo $PROJECTS

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
if [ $COLUMNS -gt 125 ]; then
    echo -e "\e[95m\e[1m     .--.     \e[93m +#++:++#++:++ +#++:++#++:++ +#++:++#++:++ +#++:++#++:++ +#++:++#++:++ +#++:++#++:++ +#++:++#++  \e[0m   \e[95m\e[1m    .--.      "
    echo -e "\e[95m\e[1m    | o_o|    \e[34m ██╗   ██╗ ██████╗ ███╗   ██╗██╗    ███████╗██╗     ███████╗███╗   ██╗████████╗ ██████╗ ██╗  ██╗ \e[0m   \e[95m\e[1m   |o_o |     "
    echo -e "\e[95m\e[1m    | \_/|    \e[34m ╚██╗ ██╔╝██╔═══██╗████╗  ██║██║    ██╔════╝██║     ██╔════╝████╗  ██║╚══██╔══╝██╔═══██╗██║ ██╔╝ \e[0m   \e[95m\e[1m   |\_/ |     "  
    echo -e "\e[95m\e[1m   //   \ \   \e[34m  ╚████╔╝ ██║   ██║██╔██╗ ██║██║    █████╗  ██║     █████╗  ██╔██╗ ██║   ██║   ██║   ██║█████╔╝  \e[0m   \e[95m\e[1m  //   \ \    "
    echo -e "\e[95m\e[1m  (|     | )  \e[34m   ╚██╔╝  ██║   ██║██║╚██╗██║██║    ██╔══╝  ██║     ██╔══╝  ██║╚██╗██║   ██║   ██║   ██║██╔═██╗  \e[0m   \e[95m\e[1m (|     | )   "
    echo -e "\e[95m\e[1m /\`\_   _/'\  \e[34m    ██║   ╚██████╔╝██║ ╚████║██║    ███████╗███████╗███████╗██║ ╚████║   ██║   ╚██████╔╝██║  ██╗ \e[0m  \e[95m\e[1m /'\_   _/\`\  "
    echo -e "\e[95m\e[1m \___)=(___/  \e[34m    ╚═╝    ╚═════╝ ╚═╝  ╚═══╝╚═╝    ╚══════╝╚══════╝╚══════╝╚═╝  ╚═══╝   ╚═╝    ╚═════╝ ╚═╝  ╚═╝ \e[0m   \e[95m\e[1m\___)=(___/   " 
    echo -e "\e[95m\e[1m              \e[93m +#++:++#++:++ +#++:++#++:++ +#++:++#++:++ +#++:++#++:++ +#++:++#++:++ +#++:++#++:++ +#++:++#++\e[0m"
elif [ $COLUMNS -gt 79 ]; then
    echo -e "\e[95m\e[1m     .--.     \e[93m +#++:++#++:++ +#++:++#++:++ +#++:++#++:++ +#++:+ \e[0m   \e[95m\e[1m    .--.      "
    echo -e "\e[95m\e[1m    | o_o|    \e[34m ██╗   ██╗ ██████╗ ███╗   ██╗██╗      ███████╗    \e[0m   \e[95m\e[1m   |o_o |     "
    echo -e "\e[95m\e[1m    | \_/|    \e[34m ╚██╗ ██╔╝██╔═══██╗████╗  ██║██║      ██╔════╝    \e[0m   \e[95m\e[1m   |\_/ |     "  
    echo -e "\e[95m\e[1m   //   \ \   \e[34m  ╚████╔╝ ██║   ██║██╔██╗ ██║██║      █████╗      \e[0m   \e[95m\e[1m  //   \ \    "
    echo -e "\e[95m\e[1m  (|     | )  \e[34m   ╚██╔╝  ██║   ██║██║╚██╗██║██║      ██╔══╝      \e[0m   \e[95m\e[1m (|     | )   "
    echo -e "\e[95m\e[1m /\`\_   _/'\  \e[34m    ██║   ╚██████╔╝██║ ╚████║██║   ██╗███████╗██╗ \e[0m  \e[95m\e[1m /'\_   _/\`\  "
    echo -e "\e[95m\e[1m \___)=(___/  \e[34m    ╚═╝    ╚═════╝ ╚═╝  ╚═══╝╚═╝   ╚═╝╚══════╝╚═╝ \e[0m   \e[95m\e[1m\___)=(___/   "
    echo -e "\e[95m\e[1m              \e[93m +#++:++#++:++ +#++:++#++:++ +#++:++#++:++ +#++:+\e[0m"
elif [ $COLUMNS -gt 66 ]; then
    echo -e "\e[93m\e[1m                                                  \e[0m   \e[95m\e[1m    .--.     "
    echo -e "\e[34m\e[1m ██╗   ██╗ ██████╗ ███╗   ██╗██╗      ███████╗    \e[0m   \e[95m\e[1m   |o_o |    "
    echo -e "\e[34m\e[1m ╚██╗ ██╔╝██╔═══██╗████╗  ██║██║      ██╔════╝    \e[0m   \e[95m\e[1m   |\_/ |    "  
    echo -e "\e[34m\e[1m  ╚████╔╝ ██║   ██║██╔██╗ ██║██║      █████╗      \e[0m   \e[95m\e[1m  //   \ \   "
    echo -e "\e[34m\e[1m   ╚██╔╝  ██║   ██║██║╚██╗██║██║      ██╔══╝      \e[0m   \e[95m\e[1m (|     | )  "
    echo -e "\e[34m\e[1m    ██║   ╚██████╔╝██║ ╚████║██║   ██╗███████╗██╗ \e[0m  \e[95m\e[1m /'\_   _/\`\ "
    echo -e "\e[34m\e[1m    ╚═╝    ╚═════╝ ╚═╝  ╚═══╝╚═╝   ╚═╝╚══════╝╚═╝ \e[0m   \e[95m\e[1m\___)=(___/  "
elif [ $COLUMNS -gt 50 ]; then
    echo -e "\e[93m\e[1m                                                  \e[0m"
    echo -e "\e[34m\e[1m ██╗   ██╗ ██████╗ ███╗   ██╗██╗      ███████╗    \e[0m"
    echo -e "\e[34m\e[1m ╚██╗ ██╔╝██╔═══██╗████╗  ██║██║      ██╔════╝    \e[0m"  
    echo -e "\e[34m\e[1m  ╚████╔╝ ██║   ██║██╔██╗ ██║██║      █████╗      \e[0m"
    echo -e "\e[34m\e[1m   ╚██╔╝  ██║   ██║██║╚██╗██║██║      ██╔══╝      \e[0m"
    echo -e "\e[34m\e[1m    ██║   ╚██████╔╝██║ ╚████║██║   ██╗███████╗██╗ \e[0m"
    echo -e "\e[34m\e[1m    ╚═╝    ╚═════╝ ╚═╝  ╚═══╝╚═╝   ╚═╝╚══════╝╚═╝ \e[0m"
elif [ $COLUMNS -gt 32 ]; then
    echo -e "\e[93m\e[1m                                \e[0m"
    echo -e "\e[34m\e[1m ██╗   ██╗ ██████╗ ███╗   ██╗██╗\e[0m"
    echo -e "\e[34m\e[1m ╚██╗ ██╔╝██╔═══██╗████╗  ██║██║\e[0m"  
    echo -e "\e[34m\e[1m  ╚████╔╝ ██║   ██║██╔██╗ ██║██║\e[0m"
    echo -e "\e[34m\e[1m   ╚██╔╝  ██║   ██║██║╚██╗██║██║\e[0m"
    echo -e "\e[34m\e[1m    ██║   ╚██████╔╝██║ ╚████║██║\e[0m"
    echo -e "\e[34m\e[1m    ╚═╝    ╚═════╝ ╚═╝  ╚═══╝╚═╝\e[0m"
fi
BLACK='\e[40m'
WHITE='\e[107m'
YELLOW='\e[103m'
GRAY='\e[100m'
NC='\e[0m'
