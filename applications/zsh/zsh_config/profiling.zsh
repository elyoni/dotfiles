local blue="\033[34m"
local red="\033[31m"
local gray="\033[1;30m"
local reset="\033[0m"

if [[ ${DEBUG} == "true" ]]; then
    echo "zshrc started"
fi

export INDENT=''

increment_indent() {
    export INDENT="$INDENT  "
}

decrement_indent() {
    export INDENT="${INDENT[0,-3]}"
}

iecho() {
    echo "${INDENT}$*"
}

# Source a file and on debug print the time it took
source() {
    if [[ ${DEBUG} == "true" ]]; then
        iecho "● $blue$*$reset"
        increment_indent
        local before=$SECONDS
    fi

    # Source the file
    . $*

    if [[ ${DEBUG} == "true" ]]; then
        local duration=$((($SECONDS - $before) * 1000))
        decrement_indent
        if [[ $duration -gt 40.0 ]]; then
            local color="$red"
        else
            local color="$gray"
        fi
        iecho "  $color($(printf '%.2f' $duration)ms)$reset"
        echo
    fi
}
