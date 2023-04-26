#!/bin/bash

ENV_PATH=$HOME/.profile.env

smart_add_env()
{
    local new_env_name="$1"
    local new_env_value="$2"

    # Create ENV_PATH file if not exits
    if [ -f $ENV_PATH ]; then
	echo "Source the file $ENV_PATH"
        source $ENV_PATH
    else
        echo "The file $ENV_PATH is not exits will create new file"
        touch $ENV_PATH
    fi

    # Get the value of the variable name: $new_env_name if exits
    eval "env_value_value=\"\${$new_env_name}\""
    if [[ "$(cat "$ENV_PATH")" != *"${new_env_name}="* ]]; then
        # Will create new variable in $ENV_PATH
        echo "$env_value_value"
        echo "INFO: Create the variable $new_env_name in $ENV_PATH with the value $new_env_value"
        echo "export $new_env_name=\"$new_env_value\"" >> $ENV_PATH
    else
        :
    fi
}
