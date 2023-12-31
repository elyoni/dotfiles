# vim: foldmethod=marker

# Zsh completion {{{1
autoload -Uz compinit

# On slow systems, checking the cached .zcompdump file to see if it must be
# regenerated adds a noticable delay to zsh startup.  This little hack restricts
# it to once a day.  It should be pasted into your own completion file.
#
# The globbing is a little complicated here:
# - '#q' is an explicit glob qualifier that makes globbing work within zsh's [[ ]] construct.
# - 'N' makes the glob pattern evaluate to nothing when it doesn't match (rather than throw a globbing error)
# - '.' matches "regular files"
# - 'mh+24' matches files (or directories or whatever) that are older than 24 hours.
if [[ -n ${ZDOTDIR}/.zcompdump(#qN.mh+24) ]]; then
  compinit
else
  compinit -C
fi

# Use caching to make completion for cammands such as dpkg and apt usable.
zstyle ':completion::complete:*' use-cache on
zstyle ':completion::complete:*' cache-path "$HOME/.local/share/zcompcache"

# Case-insensitive (all), partial-word, and then substring completion.
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
unsetopt CASE_GLOB

# === Ls Colors === {{{2
# di = directory,
# ln = symbolic link,
# so = socket,
# pi = fifo,
# ex = executable,
# bd = block device,
# cd = character device,
# su = executable with setuid bit set,
# sg = executable with setgid bit set,
# tw = directory writable to others,
# ow = directory writable to others with sticky bit,
# st = directory writable to others with sticky bit and group execution bit set.
_ls_colors="di=1;34"
_ls_colors=${_ls_colors}:"ex=01;32"
_ls_colors=${_ls_colors}:"ln=01;36"
_ls_colors=${_ls_colors}:"so=01;35"
_ls_colors=${_ls_colors}:"pi=33"
_ls_colors=${_ls_colors}:"bd=40;33"
_ls_colors=${_ls_colors}:"cd=40;33;01"
_ls_colors=${_ls_colors}:"su=37;41"
_ls_colors=${_ls_colors}:"sg=30;43"
_ls_colors=${_ls_colors}:"tw=30;42"
_ls_colors=${_ls_colors}:"ow=34;42"

zstyle ':completion:*:default' list-colors "${(s.:.)_ls_colors}"
LS_COLORS+=$_ls_colors
# Group matches and describe.
zstyle ':autocomplete:*' default-context ''
zstyle ':autocomplete:tab:*' widget-style menu-select
zstyle ':completion:*:*:*:*:*' menu select  # Mark the selection with a line highlight.
#zstyle ':completion:*:matches' group 'yes'
#zstyle ':completion:*:options' description 'yes'
#zstyle ':completion:*:options' auto-description '%d'
#zstyle ':completion:*:corrections' format ' %F{green}-- %d (errors: %e) --%f'
#zstyle ':completion:*:descriptions' format ' %F{yellow}-- %d --%f'
zstyle ':completion:*:messages' format ' %F{purple} -- %d --%f'
zstyle ':completion:*:warnings' format ' %F{red}-- no matches found --%f'
zstyle ':completion:*:default' list-prompt '%S%M matches%s'
zstyle ':completion:*' format ' %F{yellow}-- %d --%f'
#zstyle ':completion:*' group-name ''
#zstyle ':completion:*' verbose yes
#zstyle ':completion:*' complete-options true
