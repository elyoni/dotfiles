# ======= Docker ================
alias drm="docker rm"
alias dps="docker ps"
alias boxclean="docker container prune"

function newbox {
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

function newbox() {
    # Original function with some changes
    function _help()
    {
        echo "-i set image"
        echo "-d set device, use in minicom"
        echo "-h print this help"
    }
    local image="devbox"
    local device="/dev/null"
    local projects="$HOME/projects"

    while getopts i:d:h option
    do
        case "${option}"
            in
            i) IMAGE=${OPTARG};;
            d) DEVICE=${OPTARG};;
            h) _help && return;;
        esac
    done

    docker run -it \
    --name "TestBuild" \
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
