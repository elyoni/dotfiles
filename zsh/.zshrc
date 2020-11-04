autoload -U +X bashcompinit && bashcompinit
autoload -U +X compinit && compinit
fpath=(~/.zsh/completion $fpath) 
zstyle ":completion:*:descriptions" format "%B%d%b"
# If you come from bash you might have to change your $PATH.
export PATH=$HOME/.local/bin:/usr/local/go/bin:$PATH

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
#ENABLE_CORRECTION="true"

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
  docker
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
export LIBSUITE_PATH="$HOME/projects/sources/libsuite"
export PORTIA_LATEST_VER_DTB=""
export PORTIA_LATEST_VER_SPFF=""  
export PORTIA_LATEST_VER_ZIMAGE=""
export PORTIA_LATEST_VER_ZIP=""

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
alias py=python3.8

alias mini0="sudo minicom -D /dev/ttyUSB0 -C ~/projects/minicom0.log"
alias mini1="sudo minicom -D /dev/ttyUSB1 -C ~/projects/minicom1.log"

alias cdpman="cd ~/projects/sources/apps/pmanager"
alias cdcore="cd ~/projects/sources/apps/core"
alias cdbuildroot="cd ~/projects/buildroot"
alias cdtools="cd ~/projects/tools"
alias cdshell="cd ~/projects/tools/shell"
alias cdlab="cd ~/projects/lab/"
alias cdutils="cd ~/projects/tools/utils/"
alias cdproto="cd ~/projects/sources/libsuite/modules/proto/"
alias cdlibsuite="cd ~/projects/sources/libsuite/"
alias tm0="tmux a -t minicom0"
alias tm1="tmux a -t minicom1"
alias tm_jupiter="tm1"
alias tm_jj="tm0"
alias tt="tmux a -t test"
alias vm="vifm $PWD"
alias gip="source ~/projects/tools/env/zsh/update_ip.sh"
alias vi="nvim"
alias box="bash ${HOME}/.se_dotfiles/docker/box.sh"


# ======= Docker ================
alias drm="docker rm"
alias dps="docker ps"
alias boxclean="docker container prune"

function run_docker() {
    mkdir $PROJECTS -p
    echo $PROJECTS

    docker run -it -d \
    --name ${SYSTEM} \
    --hostname ${USER}-d>${SYSTEM}\
    -v ${PROJECTS}:/home/devbox/projects \
    -v ${HOME}/.ssh:/home/devbox/.ssh \
    -v ${HOME}/.gitconfig:/home/devbox/.gitconfig \
    -v ${HOME}/.zshrc:/home/devbox/.zsh_host/.zshrc \
    -v ${HOME}/.dotfiles/zsh/yoni.zsh-theme:/home/devbox/.oh-my-zsh/themes/yoni.zsh-theme \
    -v ${HOME}/.dotfiles/tmux/tmux.conf:/home/devbox/.tmux.conf \
    -v ${HOME}/.zsh_history:/home/devbox/.zsh_history \
    -v ${HOME}/projects/karamba/sign_tool:/etc/karamba/sign_tool \
    -p ${PORT}:22 \
    -e DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix \
    ${IMAGE}

}

function reset_ssh(){
	docker exec -dt "${SYSTEM}" sudo service ssh restart # Restart after updating /etc/environment just in case
    sleep 0.5
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
    -e DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix \
    -p 5000:5001 \
    $1
}
    #-v ${HOME}/mnt/m_drive/:/home/devbox/mnt/m_drive/ \
    #--network=host \
    #emb-jenk-slv01:5000/devbox:python3.5

function sip(){
    export PORTIA_IP=$1
    export PORTIA_PORT=80
}

function boxnew() {
    SYSTEM="devbox"
    PORT="220"
    IMAGE="emb-jenk-slv01:5000/devbox:latest"

    while [[ $# -gt 0 ]]; do
        key="$1"
        case $key in
            -s|--system)
            SYSTEM="$2"
            shift # past value
            shift # past value
            ;;
            -p|--port)
            PORT="$2"
            shift # past argument
            shift # past value
            ;;
            -i|--image)
            IMAGE="$2"
            shift # past argument
            shift # past value
            ;;
            *)    # unknown option
            shift # past argument
            ;;
        esac
    done
    if [ $SYSTEM = "local" ]; then
        PROJECTS="${HOME}/projects"
    else
        PROJECTS=${HOME}/docker/${SYSTEM}/projects
    fi

    echo The project will be found in: $PROJECTS
    if [ ! "$(docker ps -a | grep -w " ${SYSTEM}")" ]; then
        # There is not container run
        echo System: ${SYSTEM} Listen on Port ${PORT}
        run_docker

    elif docker inspect -f '{{.State.Status}}' ${SYSTEM} | grep -qiE 'exited|Created'; then
        if [ ! "$(docker ps -a | grep -w ${SYSTEM} | grep ${IMAGE})" ]; then
            echo "The image is diffrenct from what you ask for, will run with the previce image $(docker inspect -f '{{.Config.Image}}' ${SYSTEM})[Press any key to continue]"
            read
        fi
        docker start ${SYSTEM}
        port=$(docker inspect --format='{{(index (index .NetworkSettings.Ports "22/tcp") 0).HostPort}}' ${SYSTEM})
        echo System: ${SYSTEM} Listen on Port ${port}
    elif docker inspect -f '{{.State.Status}}'  ${SYSTEM}| grep -q running; then
        if [ ! "$(docker ps -a | grep -w ${SYSTEM} | grep ${IMAGE})" ]; then
            echo "The image is diffrenct from what you ask for, will run with the previce image[Press any key to continue]"
            read
        fi
        #docker attach ${SYSTEM}
        port=$(docker inspect --format='{{(index (index .NetworkSettings.Ports "22/tcp") 0).HostPort}}' ${SYSTEM})
        echo System: ${SYSTEM} Listen on Port ${port}
    else 
        echo Unknown what to do
        exit 1
    fi

    reset_ssh
    current_path=$(echo $PWD | sed -e "s#\(.*\)$USER\(.*\)#\1devbox\2#")
    ssh devbox@localhost -p ${PORT} -t "cd $current_path; zsh --login" 
}
#docker run -it --name debox --hostname ${USER}-docker -v ${HOME}/docker/debox/projects:/home/devbox/projects -v ${HOME}/.ssh:/home/devbox/.ssh -v ${HOME}/.gitconfig:/home/devbox/.gitconfig -v ${HOME}/.zshrc:/home/devbox/.zsh_host/.zshrc -v ${HOME}/.dotfiles/zsh/yoni.zsh-theme:/home/devbox/.oh-my-zsh/themes/yoni.zsh-theme -v ${HOME}/.dotfiles/tmux/tmux.conf:/home/devbox/.tmux.conf emb-jenk-slv01:5000/devbox:latest


function boxpull() {
    IMAGE=${1:-devbox}
    docker pull emb-jenk-slv01:5000/${IMAGE}
}

function boxrun(){
    current_path=$(echo $PWD | sed -e "s#\(.*\)$USER\(.*\)#\1devbox\2#")
    #ssh devbox@localhost -p ${PORT} -t "cd $current_path; zsh --login" 
    echo ssh devbox@localhost -p 221 -t "cd $current_path; zsh --login; $@" 
    ssh devbox@localhost -p 221 -t "cd $current_path; zsh --login; $@" 
    echo $@
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

zle     -N   fzf-test
_shell_complete(){
    local output 
    #output=$(_fzf_complete '+m' "$@" < <(command ls))
    output=$(_shell_complete_loop | fzf)
    # need to remove after ##
    output=$( echo $output | sed -e "s@##.*@@g" | sed -r 's/^\s+$//' )
    echo $output"yoni"
}

_shell_complete_loop(){
    local file_list y 
    for x in $(find $SHELL_DIR -type f -name "*.py"); do
        file_list=$( echo $x | sed "s#$SHELL_DIR/##g" )
        #base=$(echo $x | sed -e 's/\(.*\)\///' -e 's/.py//')
        y=$(sed -n '2p' $x | grep "##")
        #echo $file_list
        echo -e $file_list "\t" $y
    done
}


function fzf-test(){
    zle reset-prompt
    #LBUFFER="${LBUFFER}$(_shell_complete)"
    LBUFFER="p $(_shell_complete)"
    return 0
}
bindkey '^W' fzf-test

function ssh-auto-retry()
{
    false
    while [ $? -ne 0 ]; do
        sshpass -p $1 ssh "${@:2}" || (sleep 1;false)
    done
}
function retry-command()
{
    false
    while [ $? -ne 0 ]; do
        "${@}" || (sleep 1;false)
    done
}

function newbox() {
        IMAGE="devbox"
    DEVICE="/dev/null"
        while getopts i:d: option
        do
        case "${option}"
        in
        i) IMAGE=${OPTARG};;
        d) DEVICE=${OPTARG};;
        esac
        done

    docker run -it \
    --cpus=1 \
    --mount type=bind,src=${HOME}/docker/${IMAGE}/shared,target=/home/${IMAGE}/shared \
    --mount type=bind,src=${HOME}/.ssh,target=/home/${IMAGE}/.ssh \
    --mount type=bind,src=${HOME}/.gitconfig,target=/home/${IMAGE}/.gitconfig \
    --mount type=bind,src=${HOME}/.zshrc,target=/home/${IMAGE}/.zsh_host/.zshrc \
    --mount type=bind,src=${HOME}/projects/,target=/home/${IMAGE}/projects \
    --mount type=bind,src=${HOME}/.config/se/,target=/home/${IMAGE}/.config/se/ \
    --device=${DEVICE} \
    --network="host" \
    -e DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix \
    emb-jenk-slv01:5000/${IMAGE}:latest
}

function newbox() {
    IMAGE="devbox"
    DEVICE="/dev/null"
    docker run -it \
    --mount type=bind,src=${HOME}/docker/${IMAGE}/shared,target=/home/${IMAGE}/shared \
    --mount type=bind,src=${HOME}/.ssh,target=/home/${IMAGE}/.ssh \
    --mount type=bind,src=${HOME}/.gitconfig,target=/home/${IMAGE}/.gitconfig \
    --mount type=bind,src=${HOME}/.zshrc,target=/home/${IMAGE}/.zsh_host/.zshrc \
    --mount type=bind,src=${HOME}/projects/,target=/home/${IMAGE}/projects \
    --mount type=bind,src=${HOME}/.config/se/,target=/home/${IMAGE}/.config/se/ \
    --device=${DEVICE} \
    --network="host" \
    -e DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix \
    emb-jenk-slv01:5000/${IMAGE}:latest
}
