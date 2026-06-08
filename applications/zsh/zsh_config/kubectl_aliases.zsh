# Load kubectl completion (cached to avoid slow startup)
if (( $+commands[kubectl] )); then
    local kubectl_cache="${XDG_CACHE_HOME:-$HOME/.cache}/kubectl_completion.zsh"
    if [[ ! -f "$kubectl_cache" || "$kubectl_cache" -ot "${commands[kubectl]}" ]]; then
        kubectl completion zsh > "$kubectl_cache"
    fi
    source "$kubectl_cache"
fi

alias k='kubectl'
compdef k=kubectl
alias kl='kubectl logs'
alias kg='kubectl get'
alias kgn='kubectl get nodes'
alias kgp='kubectl get pods'
alias kgp_containers="kubectl get pods -o jsonpath='{.spec.containers[*].name}'"
alias kgd='kubectl get deployments.apps'
alias kgr='kubectl get replicasets.apps'
alias kgns='kubectl get namepspaces'
alias kc='kubectl config'
alias kcc='kubectl config current-context'
alias kcg='kubectl config get-contexts'
alias kcs='kubectl config set-context'



alias kd='kubectl describe'
alias kdp='kubectl describe pod'
alias kdn='kubectl describe nodes'
alias kdelpod='kubectl delete pod'
alias kgall='kubectl get all,pv,pvc,secrets,configmaps,ingress'
