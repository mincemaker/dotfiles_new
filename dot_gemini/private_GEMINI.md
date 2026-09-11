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
