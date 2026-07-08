import os
from typing import Any, Optional


def _find_git_root(path: str) -> Optional[str]:
    while True:
        if os.path.isdir(os.path.join(path, '.git')):
            return path
        parent = os.path.dirname(path)
        if parent == path:
            return None
        path = parent


def _git_branch(git_root: str) -> Optional[str]:
    try:
        with open(os.path.join(git_root, '.git', 'HEAD')) as f:
            head = f.read().strip()
    except OSError:
        return None
    if head.startswith('ref:'):
        return head.rsplit('/', 1)[-1]
    return head[:7]


def draw_title(data: dict[str, Any]) -> str:
    tab = data['tab']
    cwd = tab.active_wd
    git_root = _find_git_root(cwd)
    if git_root:
        branch = _git_branch(git_root)
        folder = os.path.basename(git_root)
        location = f'{folder}:{branch}' if branch else folder
    else:
        location = cwd.replace(os.path.expanduser('~'), '~', 1)
    return f'{location} — {data["title"]}'
