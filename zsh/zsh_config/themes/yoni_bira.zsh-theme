#setopt PROMPT_SUBST

# General Color
local green="%{$fg_bold[green]%}"
local red="%{$fg_bold[red]%}"
local cyan="%{$fg_bold[cyan]%}"
local yellow="%{$fg_bold[yellow]%}"
local blue="%{$fg_bold[blue]%}"
local magenta="%{$fg_bold[magenta]%}"
local white="%{$fg_bold[white]%}"
local reset="%{$reset_color%}"

local -a color_array
#color_array=($green $red $cyan $yellow $blue $magenta $white)

# Field Color
local username_normal_color=$yellow
local username_root_color=$red
local hostname_root_color=$magenta


## calculating hostname color with hostname characters
#for i in `hostname`; local hostname_normal_color=$color_array[$[((#i))%7+1]]
local -a hostname_color
hostname_color=$hostname_root_color

local current_dir_color=$blue
local username_command="%n"
local hostname_command="%m"
local current_dir="%~"
local jobs_bg="${red}fg: %j$reset"

local username_output="${username_normal_color}${username_command}${reset}@"
local return_code="%(?..%{$fg[red]%}%? ↵%{$reset_color%})"
local hostname_output="$hostname_color$hostname_command$reset"
local user_symbol='%(!.#.$)'
local current_dir_output="$current_dir_color$current_dir$reset"

# local vcs_branch='$(git_prompt_info)$(git_prompt_status)$(git_remote_status)$(hg_prompt_info)${white})${reset}'
local rvm_ruby='$(ruby_prompt_info)'
local ranger_background='$(ps -fp $PPID | grep -q ranger && echo 📂)'
local venv_prompt='$(virtualenv_prompt_info)'

ZSH_THEME_RVM_PROMPT_OPTIONS="i v g"
local vcs_branch='$(out=$(git_prompt_info)$(git_prompt_status)$(git_remote_status)$(hg_prompt_info);if [[ -n $out ]]; then printf %s " $white($green$out$white)$reset";fi)'
PROMPT+="$GIT_PROMPT"

PROMPT="╭─${username_output}${hostname_output}: ${current_dir}${rvm_ruby} ${vcs_branch}${venv_prompt} ${ranger_background}%1(j. [$jobs_bg].)
╰─%B${user_symbol}%b "
RPROMPT="%B[%*]%b %B${return_code}%b"
# [%*]"

ZSH_THEME_GIT_PROMPT_PREFIX=""    # %{$fg[yellow]%}‹"
ZSH_THEME_GIT_PROMPT_SUFFIX=""     # ") %{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY=""      #"%{$fg[red]%}●%{$fg[yellow]%}"
ZSH_THEME_GIT_PROMPT_CLEAN=""      #%{$fg[yellow]%}"


ZSH_THEME_GIT_PROMPT_UNTRACKED="$red☐ "
ZSH_THEME_GIT_PROMPT_MODIFIED="$red☒ "
ZSH_THEME_GIT_PROMPT_ADDED="$yellow☑ "
ZSH_THEME_GIT_PROMPT_STASHED="$blue"
ZSH_THEME_GIT_PROMPT_EQUAL_REMOTE="$green✓"
ZSH_THEME_GIT_PROMPT_AHEAD_REMOTE="🌞"  #>"
ZSH_THEME_GIT_PROMPT_BEHIND_REMOTE="🌙"
ZSH_THEME_GIT_PROMPT_DIVERGED_REMOTE="$red<>"

ZSH_THEME_HG_PROMPT_PREFIX="$ZSH_THEME_GIT_PROMPT_PREFIX"
ZSH_THEME_HG_PROMPT_SUFFIX="$ZSH_THEME_GIT_PROMPT_SUFFIX"
ZSH_THEME_HG_PROMPT_DIRTY="$ZSH_THEME_GIT_PROMPT_DIRTY"
ZSH_THEME_HG_PROMPT_CLEAN="$ZSH_THEME_GIT_PROMPT_CLEAN"

ZSH_THEME_RUBY_PROMPT_PREFIX="%{$fg[red]%}‹"
ZSH_THEME_RUBY_PROMPT_SUFFIX="› %{$reset_color%}"

ZSH_THEME_VIRTUAL_ENV_PROMPT_PREFIX="%{$fg[green]%}‹"
ZSH_THEME_VIRTUAL_ENV_PROMPT_SUFFIX="› %{$reset_color%}"
ZSH_THEME_VIRTUALENV_PREFIX="$ZSH_THEME_VIRTUAL_ENV_PROMPT_PREFIX"
ZSH_THEME_VIRTUALENV_SUFFIX="$ZSH_THEME_VIRTUAL_ENV_PROMPT_SUFFIX"
