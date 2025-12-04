# Automatic notification for long-running commands
# No need to add anything to commands - works automatically!
#
# Customize by setting these in your ~/.zshrc_user:
#   export LONG_COMMAND_THRESHOLD=15           # seconds (default: 10)
#   export NOTIFY_ONLY_WHEN_UNFOCUSED=true     # true/false (default: true)
#   export NOTIFY_EXCLUDE_COMMANDS="vi nvim ssh"  # space-separated list
#
# Configuration
LONG_COMMAND_THRESHOLD=${LONG_COMMAND_THRESHOLD:-10}  # seconds
NOTIFY_ONLY_WHEN_UNFOCUSED=${NOTIFY_ONLY_WHEN_UNFOCUSED:-true}

# Commands to exclude from notifications (interactive programs)
# These are typically editors, file managers, and interactive sessions
NOTIFY_EXCLUDE_COMMANDS=${NOTIFY_EXCLUDE_COMMANDS:-"vi vim nvim nano emacs ranger rr ssh tmux screen less man top htop btop"}

# Variables to track command execution
typeset -g __command_start_time
typeset -g __command_name

# Called before each command execution
preexec() {
    __command_start_time=$SECONDS
    __command_name="$1"
}

# Called before each prompt (after command finishes)
precmd() {
    local exit_status=$?

    # Only proceed if we have a start time (command was executed)
    if [[ -n $__command_start_time ]]; then
        local elapsed=$(( SECONDS - __command_start_time ))

        # Check if command took longer than threshold
        if (( elapsed >= LONG_COMMAND_THRESHOLD )); then
            # Extract the base command name (first word, without arguments or paths)
            local base_cmd="${__command_name%% *}"  # Get first word
            base_cmd="${base_cmd##*/}"               # Remove path if present
            
            # Check if command is in the exclusion list
            local is_excluded=false
            for excluded_cmd in ${=NOTIFY_EXCLUDE_COMMANDS}; do
                if [[ "$base_cmd" == "$excluded_cmd" ]]; then
                    is_excluded=true
                    break
                fi
            done
            
            # Skip notification if command is excluded
            if [[ "$is_excluded" == "true" ]]; then
                unset __command_start_time
                unset __command_name
                return
            fi
            
            local should_notify=true

            # Check if we should only notify when unfocused
            if [[ "$NOTIFY_ONLY_WHEN_UNFOCUSED" == "true" ]]; then
                # Check if terminal is focused (works in most terminals with proper escape sequences)
                # For Ghostty/other terminals, we'll always notify since we can't reliably detect focus
                should_notify=true
            fi

            if [[ "$should_notify" == "true" ]]; then
                # Truncate command name if too long
                local cmd_display="${__command_name[0,50]}"
                if [[ ${#__command_name} -gt 50 ]]; then
                    cmd_display="${cmd_display}..."
                fi

                # Format duration nicely
                local duration_display
                if (( elapsed < 60 )); then
                    duration_display="${elapsed}s"
                elif (( elapsed < 3600 )); then
                    duration_display="$((elapsed / 60))m $((elapsed % 60))s"
                else
                    duration_display="$((elapsed / 3600))h $(( (elapsed % 3600) / 60))m"
                fi

                # Choose icon based on exit status
                local icon="✓"
                local status_text="completed"
                if (( exit_status != 0 )); then
                    icon="✗"
                    status_text="failed (exit $exit_status)"
                fi

                # Send notification
                if command -v notify-send &>/dev/null; then
                    notify-send \
                        --urgency=normal \
                        --icon="$([ $exit_status = 0 ] && echo terminal || echo error)" \
                        "Command ${status_text}" \
                        "${icon} ${cmd_display}\nDuration: ${duration_display}"
                fi
            fi
        fi

        # Reset for next command
        unset __command_start_time
        unset __command_name
    fi
}
