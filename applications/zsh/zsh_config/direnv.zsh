# direnv hook (cached to avoid a subprocess per shell start)
(( $+commands[direnv] )) || return
export DIRENV_LOG_FORMAT=
_direnv_cache="${XDG_CACHE_HOME:-$HOME/.cache}/direnv_hook.zsh"
if [[ ! -f $_direnv_cache || $_direnv_cache -ot ${commands[direnv]} ]]; then
    direnv hook zsh > "$_direnv_cache"
fi
source "$_direnv_cache"
unset _direnv_cache
