#!/usr/bin/env bash
#
DIR=$(dirname "${BASH_SOURCE[0]}")
DIR=$(cd -P "${DIR}" && pwd)

function has_an_instance(){
    while getopts "s:" flag
    do
        case "${flag}" in
            s) scratchpad_title=${OPTARG};;
            *) ;;
        esac
    done
    unset OPTIND
    : "${scratchpad_title:?Missing scratchpad \'-s\'}"

    res=$(i3-msg -t get_tree | jq --arg var "${scratchpad_title}" '.. | select(.window_properties? | .title == $var) | any')
    if [[ $res == true ]]; then
        return 0
    else
        return 1
    fi
}

function toggle_scratchpad(){
    local scratchpad_title
    local termial_exec_command
    local scratchpad_script_path

    while getopts "s:" flag
    do
        case "${flag}" in
            s) scratchpad_title=${OPTARG};;
            *) ;;
        esac
    done
    unset OPTIND
    scratchpad_title=${scratchpad_title:="wiki"}
    : "${scratchpad_title:?Missing scratchpad \'-s\'}"

    if [[ -f "$(which ghostty)" ]]; then
        termial_exec_command="ghostty --title=${scratchpad_title} --background-opacity=0.95"
    elif [[ -f "$(which gnome-terminal)" ]]; then
        termial_exec_command="gnome-terminal --title ${scratchpad_title}"
    elif [[ -f "$(which wezterm)" ]]; then
        termial_exec_command="wezterm --title ${scratchpad_title}"
    elif [[ -f "$(which kitty)" ]]; then
        termial_exec_command="kitty --title ${scratchpad_title}"
    fi

    if ! i3-msg [title="${scratchpad_title}"] --quiet scratchpad show; then
        # There isn't a scratchpad that response the createrea

        # Check if the scratchpad was replace with a regular window
        if ! has_an_instance -s "${scratchpad_title}"; then
            pushd "${DIR}" &>/dev/null || exit
            echo "instance is not exits will create one" >> /tmp/scratchpad_script.log
            scratchpad_script_path="scratchpad_tmux_${scratchpad_title}"
            if [[ ! -f "${scratchpad_script_path}" ]]; then
                echo "ERROR: the file ${scratchpad_script_path} isn't exists. exit" >> /tmp/scratchpad_script.log
                exit 1
            fi

            # Execute the script in another terminal
            if [[ -f "$(which ghostty)" ]]; then
                ${termial_exec_command} -e "${DIR}/${scratchpad_script_path}" &>>  /tmp/scratchpad_script.log
            else
                ${termial_exec_command} -- "${DIR}/${scratchpad_script_path}" &>>  /tmp/scratchpad_script.log
            fi

            # Wait for window to be created and focused
            while ! i3-msg -t get_tree | jq --arg var "${scratchpad_title}" '.. | select(.window_properties? | .title == $var) | any' | grep -q true; do
                sleep 0.1
            done

            # Additional wait to ensure window is fully initialized
            sleep 10
            popd &>/dev/null || exit
        fi
        {
            i3-msg [title="${scratchpad_title}"] title_format "<b>${scratchpad_title}</b>"
            i3-msg [title="${scratchpad_title}"] border normal 10
            i3-msg [title="${scratchpad_title}"] move scratchpad
            i3-msg [title="${scratchpad_title}"] scratchpad show
        } &>> /tmp/scratchpad_script.log
        #i3-msg -t subscribe  '[ "window" ]' &>>  /tmp/scratchpad_script.log
    fi
}

run_test() {
    scratchpad_title="test"
    if [[ -f "$(which ghostty)" ]]; then
        termial_exec_command="ghostty --title=${scratchpad_title}"
    elif [[ -f "$(which gnome-terminal)" ]]; then
        termial_exec_command="gnome-terminal --title=${scratchpad_title}"
    elif [[ -f "$(which wezterm)" ]]; then
        termial_exec_command="wezterm --title=${scratchpad_title}"
    elif [[ -f "$(which kitty)" ]]; then
        termial_exec_command="kitty --title=${scratchpad_title}"
    fi
    if [[ -f "$(which ghostty)" ]]; then
        ${termial_exec_command} -e "${DIR}/scratchpad_tmux_wiki"
    else
        ${termial_exec_command} -- "${DIR}/scratchpad_tmux_wiki"
    fi
    #${termial_exec_command} -e tmux new-session -s "${scratchpad_title}"
    i3-msg -t subscribe  '[ "window" ]'
    i3-msg [title="test" instance="test"] move scratchpad
    i3-msg [title="test" instance="test"] scratchpad show
}

toggle_scratchpad "$@"
#toggle_scratchpad
