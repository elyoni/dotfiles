# Dotfiles

Personal dotfiles and shell tooling. This context currently covers the SSH config-management tooling (`sshs`, `ssh-add-server`).

## Language

**Alias**:
The `Host` label in an SSH config entry (e.g. `Host myserver`) — the short name typed to connect, distinct from the underlying `HostName` (IP/FQDN).
_Avoid_: Host (ambiguous with the SSH keyword), name

**Config entry**:
The full block for one alias — `Host <alias>` plus `HostName` and optionally `User`/`IdentityFile` — living either in `~/.ssh/config` or inside a file under `~/.ssh/config.d/`.
_Avoid_: Host block, stanza

**Dedicated file**:
A `~/.ssh/config.d/` file whose name equals the alias it contains, holding exactly one config entry. Created by default when `ssh-add-server` adds a new alias.

**Grouped file**:
A `~/.ssh/config.d/` file, not necessarily named after any single alias, that a user hand-maintains to hold multiple config entries together (e.g. by project or environment).

**Resolve**:
Finding the config entry (and which file it lives in) for a raw token the user typed to `sshs`, by matching the token against either the `Host` line (alias) or the `HostName` line (IP/hostname) across `~/.ssh/config` and every file in `~/.ssh/config.d/`.
_Avoid_: Lookup, find
