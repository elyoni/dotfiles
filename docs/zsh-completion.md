# Writing Zsh Completions

Reference for writing and installing custom zsh completion scripts, based on the
setup in this dotfiles repo.

---

## How it works in this repo

Custom completions live in `~/.zsh/completions/` (in `fpath` before `compinit`).
Each file must be named `_<command>` and start with `#compdef <command>`.

`compinit` runs early in `~/.zshrc` (before any config file that calls `compdef`),
with `skip_global_compinit=1` in `~/.zshenv` suppressing Ubuntu's system-level call.

---

## File skeleton

```zsh
#compdef mycommand

_mycommand() {
    local context state state_descr line
    typeset -A opt_args

    _arguments -s -S \
        '(-h --help)'{-h,--help}'[show help]' \
        '(-v --verbose)'{-v,--verbose}'[verbose output]' \
        '(-o --output)'{-o,--output}'[output file]:file:_files' \
        '*:input file:_files'
}
```

The `#compdef mycommand` tag on line 1 is **required** — without it compinit
doesn't know which command the file handles.

---

## Subcommands

```zsh
#compdef mycommand

_mycommand() {
    local context state state_descr line
    typeset -A opt_args

    _arguments -C \
        '(-h --help)'{-h,--help}'[show help]' \
        '1: :->cmd' \
        '*:: :->args'

    case $state in
        cmd)
            local -a subcommands=(
                'start:start the service'
                'stop:stop the service'
                'status:show status'
            )
            _describe 'subcommand' subcommands
            ;;
        args)
            case $words[1] in
                start) _arguments '--port[port number]:port:' ;;
                stop)  _arguments '--force[force stop]' ;;
            esac
            ;;
    esac
}
```

For simpler cases (no per-subcommand options), `compadd` after `_arguments` is enough:

```zsh
_arguments -s -S \
    '(-h --help)'{-h,--help}'[show help]'

if (( CURRENT == 2 )) && [[ ${words[CURRENT]} != -* ]]; then
    compadd start stop status
fi
```

---

## Common completers

| Completer | What it completes |
|---|---|
| `_files` | Files and directories |
| `_files -g '*.log'` | Files matching a glob |
| `_directories` | Directories only |
| `_hosts` | Hosts from known_hosts / /etc/hosts |
| `_users` | Local users |
| `_describe 'label' array` | Items from an array with descriptions |
| `compadd item1 item2` | Plain list, no descriptions |

Dynamic values example:

```zsh
_mycommand_names() {
    local -a names
    names=( $(mycommand list 2>/dev/null) )
    _describe 'name' names
}

_arguments '(-n --name)'{-n,--name}'[name]:name:_mycommand_names'
```

---

## Installing a completion

### In this repo (preferred)

Put the file in `apps/<tool>/script/` and call `completion zsh --install` if your
script supports it (see `ssh-add-server` for an example), or symlink manually:

```sh
ln -s "$(pwd)/apps/mytool/script/_mytool" ~/.zsh/completions/_mytool
```

### Via install subcommand pattern

The pattern used in `ssh-add-server`:

```bash
print_zsh_completion() {
    cat <<'ZSHCOMP'
#compdef mycommand
_mycommand() { ... }
ZSHCOMP
}

cmd_install() {
    local dest="${HOME}/.zsh/completions/_mycommand"
    mkdir -p "$(dirname "$dest")"
    print_zsh_completion > "$dest"
    echo "Installed: $dest"
    echo "Reload with: exec zsh"
}
```

---

## Rebuilding the completion dump

The dump (`~/.zcompdump`) is regenerated automatically on first shell start after
it goes missing or is older than 24 hours.

To force an immediate rebuild:

```sh
rm -f ~/.zcompdump ~/.zcompdump.zwc && exec zsh
```

---

## Debugging

```sh
# Is the completion registered?
whence -v _mycommand

# Is it in the dump?
grep mycommand ~/.zcompdump

# What does compaudit flag as insecure?
compaudit

# Trace what compinit finds (clean test, no zshrc)
zsh --no-rcs -c '
  fpath=(~/.zsh/completions $fpath)
  autoload -Uz compinit && compinit -d /tmp/test_dump
  grep mycommand /tmp/test_dump && echo FOUND || echo MISSING
  rm -f /tmp/test_dump /tmp/test_dump.zwc
'
```

---

## Common pitfalls

**No `#compdef` tag** — compinit silently skips the file; the command gets no
completion. Always put `#compdef <command>` on line 1.

**System compinit running before your fpath is set** — Ubuntu's `/etc/zsh/zshrc`
calls `compinit` before `~/.zshrc`. Set `skip_global_compinit=1` in `~/.zshenv`
to suppress it, then call `compinit` yourself early in `~/.zshrc` (after fpath).

**Stale dump after adding a new file** — delete `~/.zcompdump*` and `exec zsh`.

**`compdef` errors at shell start** — means `compdef` is being called before
`compinit`. Move the `compinit` call to before the config files that use `compdef`.
