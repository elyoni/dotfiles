# vim: foldmethod=marker

# Zsh completion {{{1
# skip_global_compinit=1 (~/.zshenv) suppresses the system compinit so fpath is
# complete first. compinit must run before any file that calls compdef, so it
# lives here (loads before plugins.zsh, git_completion.zsh, kubectl_aliases.zsh...).
fpath=(~/.zsh/completions ~/.zfunc $fpath)
autoload -U +X bashcompinit && bashcompinit
autoload -Uz compinit
{
    local _zcompdump="${ZDOTDIR:-$HOME}/.zcompdump"
    # Full check once a day (mh+24 = modified >24h ago), otherwise skip it (-C).
    if [[ ! -f "$_zcompdump" || -n ${_zcompdump}(#qN.mh+24) ]]; then
        compinit
        { zcompile "$_zcompdump" } &!
    else
        compinit -C
    fi
}

# Register ~/.zfunc/_<cmd> files that lack a #compdef header (compinit skips them).
for _f in ~/.zfunc/_*(N.); do
    autoload -Uz "${_f:t}"
    (( $+commands[${${_f:t}#_}] )) && compdef "${_f:t}" "${${_f:t}#_}"
done
unset _f

(( $+commands[aws_completer] )) && complete -C "${commands[aws_completer]}" aws

# Use caching to make completion for commands such as dpkg and apt usable.
zstyle ':completion::complete:*' use-cache on
zstyle ':completion::complete:*' cache-path "$HOME/.local/share/zcompcache"

# Completion behavior
zstyle ':completion:*' menu select
zstyle ':completion:*:*:*:*:*' menu select

# Case-insensitive (all), partial-word, and then substring completion.
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
# Path/file completion: only case-insensitive; avoid r:|=* so paths with # or : don't break compadd.
zstyle ':completion:*:paths' matcher-list 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*:files' matcher-list 'm:{a-zA-Z}={A-Za-z}'
unsetopt CASE_GLOB

# Colors for completion
_ls_colors="di=1;34:ex=01;32:ln=01;36:so=01;35:pi=33:bd=40;33:cd=40;33;01:su=37;41:sg=30;43:tw=30;42:ow=34;42"
zstyle ':completion:*:default' list-colors "${(s.:.)_ls_colors}"
LS_COLORS+=$_ls_colors

# Completion formatting
zstyle ':completion:*:messages' format ' %F{purple} -- %d --%f'
zstyle ':completion:*:warnings' format ' %F{red}-- no matches found --%f'
zstyle ':completion:*:default' list-prompt '%S%M matches%s'
zstyle ':completion:*' format ' %F{yellow}-- %d --%f'

# Use ssh completion for smart wrappers
compdef sshs=ssh
compdef sshpasss=ssh
