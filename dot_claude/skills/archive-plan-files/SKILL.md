---
name: archive-plan-files
description: Moves SPEC.md, tasks/plan.md, and tasks/todo.md out of the repo root into .tmp/<branch-name>/. Use when the user asks to archive, stash, or clean up spec/plan/todo files, or when wrapping up a branch.
---

# Archive plan files

Moves planning files into `.tmp/<branch>/`, keeping their relative layout:

- `SPEC.md` → `.tmp/<branch>/SPEC.md`
- `tasks/plan.md` → `.tmp/<branch>/tasks/plan.md`
- `tasks/todo.md` → `.tmp/<branch>/tasks/todo.md`

## Steps

1. Run from the repo root:

   ```bash
   root=$(git rev-parse --show-toplevel) && cd "$root"
   branch=$(git branch --show-current)
   dest=".tmp/${branch//\//-}"
   for f in SPEC.md tasks/plan.md tasks/todo.md; do
     [ -f "$f" ] || continue
     if [ -e "$dest/$f" ]; then echo "EXISTS: $dest/$f"; continue; fi
     mkdir -p "$dest/$(dirname "$f")" && mv "$f" "$dest/$f" && echo "moved: $f -> $dest/$f"
   done
   rmdir tasks 2>/dev/null || true
   ```

2. If any line says `EXISTS`, stop. Show the user both files and ask whether to overwrite, merge, or skip. Never overwrite silently.
3. Report what moved and the destination folder.

## Notes

- Slashes in branch names become dashes (`pm-matching/foo` → `.tmp/pm-matching-foo`).
- If `git branch --show-current` is empty (detached HEAD), ask the user for a folder name.
- `tasks/` is removed only if it is empty afterward.
- Missing files are skipped without error.
