# Lazy load NVM to improve startup time
export NVM_DIR="$HOME/.config/nvm"

for _c in nvm node npm npx; do
    eval "$_c() {
        unset -f nvm node npm npx
        [ -s \"\$NVM_DIR/nvm.sh\" ] && \\. \"\$NVM_DIR/nvm.sh\"
        [ -s \"\$NVM_DIR/bash_completion\" ] && \\. \"\$NVM_DIR/bash_completion\"
        $_c \"\$@\"
    }"
done
unset _c
