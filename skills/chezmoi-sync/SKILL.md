---
name: chezmoi-sync
description: Sync updates from chezmoi source directory to a git-tracked dotfiles repository. Use this skill when the user mentions syncing chezmoi updates, importing from chezmoi, or incorporating changes from their chezmoi-managed dotfiles into their repository. This applies to phrases like 'sync from chezmoi', 'import chezmoi changes', 'take updates from chezmoi', or any task involving transferring dotfile changes from the live chezmoi source to a workspace repository.
---

# Chezmoi Sync Skill

Sync configuration changes from your chezmoi source directory back to your git-tracked dotfiles repository.

## Overview

Chezmoi manages your dotfiles in a source directory (typically `~/.local/share/chezmoi`), which may differ from your git-tracked dotfiles repository. This skill helps you identify and apply those differences.

**Important**: This skill compares files and applies updates from chezmoi to the workspace - it does NOT run `chezmoi apply` (which would apply changes in the opposite direction).

## Workflow

### 1. Determine Paths

- **Chezmoi source directory**: Usually `~/.local/share/chezmoi`
  - If the user specifies a different path, use that
  - Expand `~` to the user's home directory
- **Workspace directory**: Current working directory (typically a dotfiles repo)

### 2. Identify Differences

Use `diff -r --brief` to get a summary of all differences at once (excluding version control metadata):

```bash
diff -r --brief \
  --exclude='.git' --exclude='.jj' --exclude='.crush' \
  <chezmoi-dir> <workspace>
```

This produces three categories:
- **Files differ**: exist in both but content differs → will be updated
- **Only in chezmoi**: new files not yet in workspace → prompt user to add
- **Only in workspace**: files deleted from chezmoi → prompt user to remove

### 3. Show User the Changes

For each changed file, show the detailed diff:

```bash
diff <chezmoi-file> <workspace-file>
# or
rtk diff <chezmoi-file> <workspace-file>
```

Present a clear summary of all three categories before asking for confirmation.

### 4. Apply Updates

After user confirmation, for each file in each category:

**Files that differ** — overwrite workspace file with chezmoi version using the Edit tool, then restore permissions if needed:
```bash
# If filename has executable_ prefix, set execute permission after writing
chmod +x <workspace-file>
```

**Only in chezmoi** — copy to workspace:
```bash
cp <chezmoi-file> <workspace-file>
# Apply chmod +x if executable_ prefix
```

**Only in workspace** — confirm with user before removing (may be intentional local addition).

### 5. Stage Changes

After all updates are applied:
```bash
rtk git add <updated-files>
```

## Example Output

```
Found 2 files with differences:

1. dot_config/aerospace/aerospace.toml
   - Updated outer.top to monitor-specific gaps
   - Added workspace-to-monitor-force-assignment section

2. dot_config/sketchybar/executable_sketchybarrc
   - Added display=all option

Changes applied and staged. Ready to commit.
```

## Safety Notes

- **Never run `chezmoi apply`** - this would overwrite the chezmoi source with workspace files (opposite direction)
- Always show diffs before applying changes
- Get user confirmation for batch updates
- Preserve file permissions (especially executable files with `executable_` prefix)

## Common Chezmoi Path Conventions

- `dot_*` prefix → file in `~/`
- `dot_config/` → `~/.config/`
- `executable_*` prefix → executable file
- `private_*` prefix → private file (permissions 0600)

## Troubleshooting

**No differences found**: The workspace may already be up to date, or the files might be in different locations.

**Permission errors**: Ensure you have read access to the chezmoi source directory.

**Binary files**: Binary files should be handled carefully - show file size changes rather than content diffs.
