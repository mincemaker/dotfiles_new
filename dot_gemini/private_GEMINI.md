# AI Coding & Operation Guidelines

## Documentation & Code Conventions
- Document at the right layer:
  - Code → How (implementation details)
  - Tests → What (specifications and behavior)
  - Commits → Why (rationale for the change)
  - Comments → Why not (why alternative approaches were not taken)
- Keep documentation up to date with code changes.
- Repo-local conventions win: Always check the workspace's own rules (`GEMINI.md`, `AGENTS.md`), configs, and conventions before falling back to global defaults.
- Clean comments: Do not document removed or relocated code in comments. Commit history carries the past; comments explain the present design.
- No tool-specific markers: Never leave temporary or tool-specific markers in code comments. Use `LIMITATION:` for deliberate simplifications with known constraints.

## Subagent Delegation
- Scope: Delegate only small-to-medium, self-contained tasks to subagents.
- Clear Prompts: Provide explicit steps and concrete goals so subagents stay focused and do not get lost.
- Open-ended Tasks: Do NOT delegate ambiguous or open-ended exploration to subagents. Keep open-ended tasks in the main context to closely track progress.
- Parallelization: Launch subagents in parallel for independent, simple tasks.

## Git & Commit Workflow
- Commit as a deliberate user action: Committing triggers physical authentication (YubiKey on Linux, Secretive on macOS). Always present the staged diff and proposed commit message in chat, then wait for explicit user approval before committing.
- Shell compatibility: Fish shell does not support heredoc; use `-m "..."` directly.

## Debugging
- Check immediate changes first: Inspect recent diffs and commits before exploring broader or remote hypotheses. Do not SSH into remote systems or assume infrastructure issues without explicit confirmation.

## Execution & Workflow
- Deliver working implementations: Prioritize minimal working code over exhaustive planning so sessions conclude with functional progress rather than stalled plans.

## System & Infrastructure
- Safe system changes: For NixOS and home-manager modifications, always verify builds and test on actual hardware. Exercise extreme caution with authentication, screen lock, and session management configurations to prevent lockouts.
- Container runtime: Default to `podman` rather than `docker`.

## Communication & Output Style
- Minimal and clean formatting: Avoid decorative or excessive bold styling.
- Natural phrasing: Do not use appositive parentheticals that restate preceding nouns. Express context naturally within the sentence flow.

## Workspace Conventions
- AI workspace: `z-ai/` is globally ignored and intended for local AI scratch files, plans, and tracking documents.
- Browser inspection: When using `agent-browser`, include `--allow-private` for local addresses and use `--args "--no-sandbox"` if sandbox nesting is detected.
