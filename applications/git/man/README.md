# Man pages for git-* scripts

To make `man git-site` (and `git site --help`) work, add this directory to your `MANPATH`:

```bash
# In .zshrc or .bashrc (adjust if your dotfiles path differs)
export MANPATH="${DOTFILES:-$HOME/.dotfiles}/applications/git/man:${MANPATH}"
```

Alternatively, symlink into a directory already on your MANPATH:

```bash
mkdir -p ~/.local/share/man/man1
ln -sf ~/.dotfiles/applications/git/man/man1/git-site.1 ~/.local/share/man/man1/
```

Then run `man git-site` or `git site --help` to view the manual.
