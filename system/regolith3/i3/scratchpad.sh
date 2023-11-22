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

    res=$(i3-msg -t get_tree | jq --arg var "${scratchpad_title}" '.. | select(.window_properties? | .instance == $var and .title == $var) | any')
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

    termial_exec_command="kitty --detach --name ${scratchpad_title} --title ${scratchpad_title}"
    echo "termial_exec_command: ${termial_exec_command}"

    if ! i3-msg [title="${scratchpad_title}" instance="${scratchpad_title}"] --quiet scratchpad show; then
        # There isn't a scratchpad that response the createrea 
        
        # Check if the scratchpad was replace with a regular window
        if ! has_an_instance -s "${scratchpad_title}"; then
            pushd "${DIR}" || exit
            echo "instance is not exits will create one" >> /tmp/scratchpad_script.log
            scratchpad_script_path="scratchpad_tmux_${scratchpad_title}"
            if [[ ! -f "${scratchpad_script_path}" ]]; then
                echo "ERROR: the file ${scratchpad_script_path} isn't exists. exit" >> /tmp/scratchpad_script.log
                exit 1
            fi

            # Execute the script in another terminal
            ${termial_exec_command} -e "${DIR}/${scratchpad_script_path}" &>>  /tmp/scratchpad_script.log

            i3-msg -t subscribe  '[ "window" ]' &>>  /tmp/scratchpad_script.log
            popd || exit
        fi
        i3-msg [title="${scratchpad_title}" instance="${scratchpad_title}"] title_format "<b>${scratchpad_title}</b>"  &>>  /tmp/scratchpad_script.log
        i3-msg [title="${scratchpad_title}" instance="${scratchpad_title}"] border normal 10 &>>  /tmp/scratchpad_script.log
        i3-msg [title="${scratchpad_title}" instance="${scratchpad_title}"] move scratchpad &>>  /tmp/scratchpad_script.log
        i3-msg [title="${scratchpad_title}" instance="${scratchpad_title}"] scratchpad show &>>  /tmp/scratchpad_script.log
        #i3-msg -t subscribe  '[ "window" ]' &>>  /tmp/scratchpad_script.log
    fi
}

run_test() {
    scratchpad_title="test"
    termial_exec_command="kitty --detach --name ${scratchpad_title} --title ${scratchpad_title}"
    ${termial_exec_command} -e "${DIR}/scratchpad_tmux_wiki"
    #${termial_exec_command} -e tmux new-session -s "${scratchpad_title}"
    i3-msg -t subscribe  '[ "window" ]'
    i3-msg [title="test" instance="test"] move scratchpad
    i3-msg [title="test" instance="test"] scratchpad show
}

toggle_scratchpad "$@"
#toggle_scratchpad
