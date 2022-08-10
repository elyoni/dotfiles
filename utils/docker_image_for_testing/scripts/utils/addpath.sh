#!/bin/bash

PROFILE_PATH=$HOME/.profile.path

create_profile_path(){
    local profile_path="$PROFILE_PATH"
    cat <<PATH_EOF > "$profile_path"
#!/usr/bin/env bash
function _add_to_path {
  local new_path="\$1"
  case ":\$PATH:" in
      *":\$new_path:"*) :;; # already there
      *) export PATH="\$PATH:\$new_path";;
  esac
}
PATH_EOF
}

smart_add_to_path()
{
    local new_path=$1
    if [ -f $PROFILE_PATH ]; then
        source $PROFILE_PATH
    else
        touch $PROFILE_PATH
    fi

    if [[ "$PATH" != *"$new_path"* ]]; then
        echo "INFO: the path: $new_path wasn't found in PATH variable will add it to .profile_path"
        echo _add_to_path \"$new_path\" >> $PROFILE_PATH
    fi

    source $PROFILE_PATH
}
