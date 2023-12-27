#!/usr/bin/env bash

PX=$(which pulsemixer)
MAIN_MICROPHONE_SOURCR="source-5"



function get-source-list()
{
    "$PX" --list-source | awk '/source-[0-9+]/{print substr($3, 1, length($3)-1)}'
}

function get-source-default-id()
{
    "$PX" --list-source | grep Default | awk '/source-[0-9+]/{print substr($3, 1, length($3)-1)}'
}

function toggle-source-default()
{
    local default_source
    default_source=$(get-source-default-id)
    "$PX" --id "$default_source" --toggle-mute
}

function mute-source() {
    local source
    read source
    # PX=$(which pulsemixer)
    echo "$PX" --id "$source" --get-mute
    "$PX" --id "$source" --get-mute

}

function mute-source-all()
{
    get-source-list | xargs -n1 -I {} bash -c ""$PX" --id {} --get-mute"
}


toggle-source-default
