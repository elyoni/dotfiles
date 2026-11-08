# Save piped completion script as ~/.zfunc/_<cli>
# Usage: jcli completion zsh | zsh-add-comp [cli]
# No arg: cli name is taken from the first "#compdef <name>" line.
function zsh-add-comp() {
    if [[ -t 0 ]]; then
        echo "usage: <cli> completion zsh | zsh-add-comp [cli]" >&2
        return 1
    fi

    local content name
    content="$(cat)"
    name="${1:-}"
    if [[ -z "$name" ]]; then
        # 1) "#compdef <name>"  2) "# <shell> completion for <name>"
        if [[ "$content" =~ $'(^|\n)#compdef[[:space:]]+([^[:space:]]+)' ]]; then
            name="${match[2]}"
        elif [[ "$content" =~ $'(^|\n)#[^\n]*completion for[[:space:]]+([^[:space:]]+)' ]]; then
            name="${match[2]}"
        fi
    fi
    if [[ -z "$name" ]]; then
        echo "zsh-add-comp: no cli name given and no '#compdef' line found" >&2
        return 1
    fi

    local dest="$HOME/.zfunc/_${name}"
    mkdir -p "$HOME/.zfunc"
    printf '%s\n' "$content" > "$dest"
    echo "wrote $dest"

    # Activate in this shell
    autoload -Uz "_${name}"
    (( $+functions[compdef] )) && compdef "_${name}" "$name"
}
