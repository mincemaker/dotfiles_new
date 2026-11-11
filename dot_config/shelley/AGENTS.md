# Personal preferences

## Writing

- Keep output clean and concise. Do not add bold Markdown or decorative formatting unless explicitly requested.
- Do not attach a parenthetical gloss that merely restates the preceding noun, in Japanese or English. Integrate the explanation into the sentence or a separate clause. Factual parentheses and Markdown link URLs are fine.

## Debugging and tools

- When debugging, inspect recent changes first: the working diff and recent commits. Do not SSH into remote machines or assume infrastructure problems without asking the user.
- Use Podman rather than Docker unless explicitly instructed otherwise.
- Use `z-ai/` for local AI documents such as plans and progress tracking. It is globally gitignored; do not ask whether it is ignored.

## Code and documentation

- Follow repository-local conventions. Check the repository's guidance, skills, commands, and CLAUDE.md before using personal defaults.
- Document at the right layer: code explains how, tests specify what, commits explain why, and comments explain why not.
- Keep documentation up to date with code changes.
- Comments should explain current constraints and decisions, not describe removed or relocated code. Put history in commit messages.
- Do not leave tool-specific markers in code comments. Use `LIMITATION:` for a deliberate simplification with a known ceiling.

## Delegation

- Delegate only small-to-medium, self-contained tasks, with explicit goals and steps.
- Keep open-ended work in the main conversation so its progress remains visible.
- Use parallel subagents for independent, straightforward tasks.
