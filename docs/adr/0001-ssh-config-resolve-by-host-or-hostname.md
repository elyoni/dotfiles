# Resolve SSH config entries by alias OR HostName, edit in place

`sshs`/`ssh-add-server` must find a config entry from a raw token the user typed (an alias like `myserver`, or a literal IP/hostname like `172.16.44.7`). We decided to resolve by matching either the `Host` line or the `HostName` line, across `~/.ssh/config` and every file in `~/.ssh/config.d/` — not just the `Host` line. This lets a user connect or rename by either name, and prevents duplicate entries being created when someone re-adds a host they only know by IP.

Once resolved, we edit that config entry in place, in whatever file it's actually in, rather than normalizing everything into `config.d/<alias>`. This preserves hand-maintained "grouped" files (multiple hosts in one file). The one exception: `--rename` also renames the file itself, but only when the file is a "dedicated" file (filename == old alias) — grouped files are never renamed.
