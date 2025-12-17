# Profiling configuration:
#   DEBUG=true        -> enables zprof (lightweight, shows summary at end)
#   VERBOSE_DEBUG=true -> enables per-file source timing (verbose output)
#
# This file intentionally does nothing unless VERBOSE_DEBUG is explicitly "true"
# to avoid any overhead during normal shell startup.

if [[ "${VERBOSE_DEBUG:-false}" == "true" ]]; then
    # Verbose source profiling - wraps source to show per-file timing
    typeset -g _PROFILE_INDENT=''
    
    _profile_source() {
        local file="$1"
        local blue=$'\033[34m' red=$'\033[31m' gray=$'\033[1;30m' reset=$'\033[0m'
        
        echo "${_PROFILE_INDENT}● ${blue}${file}${reset}"
        _PROFILE_INDENT="${_PROFILE_INDENT}  "
        
        local before=$EPOCHREALTIME
        builtin source "$file"
        local duration=$(( (EPOCHREALTIME - before) * 1000 ))
        
        _PROFILE_INDENT="${_PROFILE_INDENT[1,-3]}"
        local color=$([[ $duration -gt 40 ]] && echo "$red" || echo "$gray")
        echo "${_PROFILE_INDENT}  ${color}$(printf '%.2f' $duration)ms${reset}"
    }
    
    # Only override source in verbose mode
    source() { _profile_source "$@"; }
    .() { _profile_source "$@"; }
    
    echo "=== Verbose profiling enabled ==="
fi
