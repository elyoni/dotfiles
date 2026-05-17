Commit dotfiles changes following the project's commit policy: one commit per application, split further by feature/bug concern.

## Step 1 — Analyze changes

Run `git status --porcelain` to get all changed, untracked, and staged files.

## Step 2 — Group by application

Map each file path to an application name using these rules (first match wins):

| Path | Application name |
|------|-----------------|
| `applications/<app>/...` | `<app>` |
| `system/terminal/<app>/...` | `<app>` (e.g. `ghostty`) |
| `system/regolith/...` | `regolith` |
| `system/<other>/...` | `<other>` |
| `programming-languages/<lang>/...` | `<lang>` |
| `scripts/...` | `scripts` |
| Root-level files | `chore` |

## Step 3 — Sub-group by concern within each application

For each application group, run `git diff HEAD -- <files>` (and `git diff -- <untracked-files>` for new files) to read the actual changes. Determine whether the files represent **distinct concerns** — for example, a new feature and an unrelated bug fix in the same app should be separate commits.

Propose a split into sub-groups. Example for neovim with mixed changes:
- Sub-group A: `feat(neovim): add AI coding plugins` → `ai_plugs.lua`
- Sub-group B: `fix(neovim): update LSP keybindings` → `lsp.lua`, `which-key.lua`

Show the user the proposed grouping and sub-groups for **all applications at once**, then ask them to confirm or request adjustments before committing anything. The user can:
- Accept the plan as-is
- Merge sub-groups within an app
- Re-split or reassign files
- Change a proposed commit message

## Step 4 — Commit each sub-group

Once the user approves the plan, process sub-groups one at a time:

1. Show the files and the commit message
2. `git add <file1> <file2> ...` (use explicit file paths, never `git add .`)
3. `git commit -m "type(app): short description"`
4. Confirm success before moving to the next sub-group

## Step 5 — Summary

After all commits, show `git log --oneline -10` so the user can verify.

## Rules

- **Never commit binary files** — warn and skip any binary or non-text files
- **One application per commit** — never mix two different applications in one commit
- **Commit message format**: `type(app): short description` (conventional commits)
  - Types: `feat`, `fix`, `refactor`, `chore`, `config`, `docs`
- **Untracked directories**: include all files inside them when staging
- **No `git add .`** — always stage explicit file paths
