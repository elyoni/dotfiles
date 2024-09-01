#!/usr/bin/env zsh

# === WTF is my project ===
# This is a simple script to help you find your project and cd into it.
# It also can open GitLab or GitHub page of the project on the current branch.
# Copy The Path to the clipboard.
# Key bindings:
#  Ctrl+G - To Run the script.
#  Ctrl+Y ; Ctrl+C - Copy the path to the clipboard (Only in the fzf window).
#  Ctrl+X - Open GitLab or GitHub page of the project on the current branch (Only in the fzf window).
#
# Requirements:
# - fzf
# - fd
# - xclip
# - tree
# - git
# - ranger
# - zsh
#
# Configuration:
# - WIMP_EXCLUDE_PATH: Array of paths to exclude from the search. Example: ('**/yocto-setup/**/*' '**/buildroot/dl/' '**private/rust_book/' '**/buildroot/support')
# - WIMP_PROJECTS_PATH: Array of paths to search for projects. Example: ("${HOME}"/Private/my_projects/ "${HOME}"/projects)


WIMP_HISTORY_DIR=${WIMP_HISTORY_DIR:-"${HOME}"/.config/wimp}
mkdir -p "${WIMP_HISTORY_DIR}"


enter_to_project_path() {
    if [ -z "${WIMP_PROJECTS_PATH+x}" ]; then
        echo ""
        echo " =============== WIMP =============== "
        echo "WIMP_PROJECTS_PATH is not set. Please set it in your .zshrc file."
        echo " =============== ==== =============== "
        return 0
    fi

    VALID_PATHS=()
    for dir in "${WIMP_PROJECTS_PATH[@]}"; do
        if [ -d "$dir" ]; then
            echo WIMP add $dir to the valid paths
            VALID_PATHS+=("$dir")
        fi
    done

    if [ ${#VALID_PATHS[@]} -eq 0 ]; then
        echo "There is no valid path in the variable WIMP_PROJECTS_PATH. Please check in your .zshrc file"
        return 0
    fi
    # Update WIMP_PROJECTS_PATH with only valid paths
    WIMP_PROJECTS_PATH=("${VALID_PATHS[@]}")

    output=$(fdfind \
        --no-ignore \
        --type directory \
        --hidden \
        $(printf " --search-path %s" "${WIMP_PROJECTS_PATH[@]}") \
        "\.git$" \
        $(printf " --exclude %s" "${WIMP_EXCLUDE_PATH[@]}") \
        --absolute-path \
        --exec bash -c 'dd=$(dirname {}) && echo ${dd}' | \
        fzf \
        -m \
        --height 30 \
        --header-first --header "Keymap: Enter(cd),Ctrl-Y(yank) or Ctrl-C(copy project dir),Ctrl-X(Open in Browser),Ctrl-O(Open in file manager), ?(Show Me) " \
        --border --border-label="╢ Where is my project! ╟" \
        --info=right \
        --prompt="🔍 Project>" \
        --history="${WIMP_HISTORY_DIR}"/history \
        --bind 'ctrl-y:execute-silent(echo -n {} | xclip -sel clip)+abort' \
        --bind 'ctrl-c:execute-silent(echo -n {} | xclip -sel clip)+abort' \
        --bind 'ctrl-x:execute-silent(cd {} && git site)+abort' \
        --bind 'ctrl-o:execute-silent(xdg-open {} &)+abort' \
        --bind '?:preview:echo "Help: \n\tUse arrow keys to navigate,\n\tEnter to cd into project.\n\tCtrl-Y or Ctrl-C to yank/copy project directory.\n\tCtrl-X for open in browser. \n\tCtrl-O to open in file manager."' \
        --preview-window=up \
        --preview 'tree -d -L 1 -C {} | head -200' \
    )

    # I am using cd this way and not cd with fzf because it is much faster.
    ## --bind "enter:become(cd {} && \$SHELL)+abort" \

    if [ -n "${output}" ]; then
        cd ${output}
        zle send-break #reset-prompt
    fi
}

# Bind Ctrl+G to the defined widget function
zle -N enter_to_project_path
bindkey '^G' enter_to_project_path


cd..(){}

go_to_project_path() {
  # Check if the current input line starts with "go_to" and a space
  if [[ $BUFFER == "cd.."* ]]; then
      enter_to_project_path
      zle reset-prompt
      #zle accept-line
  else
    zle expand-or-complete
  fi
}
cd..(){}

# Bind the custom widget to the Tab key
zle -N go_to_project_path
bindkey '\t' go_to_project_path
