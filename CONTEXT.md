# Dotfiles

Personal dotfiles and shell tooling. This context currently covers the SSH config-management tooling (`sshs`, `ssh-add-server`) and the Pomodoro i3xrocks blocklet.

## Language

### SSH config management

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

### Pomodoro

**State**:
One stage of the pomodoro cycle — `work`, `awaiting_break`, `break`, or `awaiting_return` — persisted in `STATE_FILE` and advanced by a phase timing out or by user action.
_Avoid_: Phase, mode

**Away**:
No keyboard/mouse input for ≥5 minutes, detected via `xprintidle`. Going Away during the `awaiting_break` state auto-starts the break, backdated to when Away began (not when it's detected), and dismisses the pending "Start Break" dialog.
_Avoid_: Idle, AFK

**Retarget**:
Changing a running phase's total planned length from the left-click menu while it's counting down, preserving elapsed time — e.g. entering 40 on a work phase already 10 minutes in leaves 30 minutes remaining, rather than resetting the elapsed clock.
_Avoid_: Reschedule, resize
