# Global instructions

## Git

- NEVER run `git commit` or `git push` unless I explicitly ask for it in that same message.
  "Continue", "proceed", "go ahead", "once you're done", and approving a plan are NOT
  permission to commit or push. Do the work, leave the changes in the working tree, tell me
  what's ready, and stop. I will commit and push myself, or ask you to.

## External services (Jira, Confluence, GitHub, cloud, messaging, etc.)

- Treat any command that creates, edits, deletes, transitions, assigns, moves, archives, or
  otherwise changes state on an external service as a WRITE action.
- NEVER perform a write action on an external service unless I explicitly ask for that specific
  action in the same message. Approving a plan, "continue", "proceed", "go ahead", or general
  permission to use a tool is NOT permission to mutate external state.
- When a task appears to need an external write, stop and show me the exact command(s) you would
  run, then wait for my explicit confirmation.
- Prefer read-only / dry-run flags when they exist. If you're unsure whether an operation writes,
  assume it does and ask first.

## Worktrees

- When opening a new worktree, prefer opening in a subdirectory of the original
  repo (`<repo>/.claude/worktrees/`)

## Config Path

- Note that the path to Claude global settings is `~/.config/claude/`, not
  `~/.claude`

## Text preparation

- When you draft text in-thread that I intend to paste into another system
  (Jira, GitHub, etc.), put it in a fenced code block so I can copy the raw
  source verbatim — do not render it as formatted markdown. If the text itself
  contains a code fence, use a longer outer fence (e.g. ~~~~) so it doesn't break.

## Config Path

- My Claude config root is `~/.config/claude/`, **not** `~/.claude`. The
  `~/.claude` directory may exist but is empty and unused — never read from or
  write to it.
- Key locations under `~/.config/claude/`: `settings.json` (+ `policy-limits.json`,
  `remote-settings.json`), `skills/`, `hooks/`, `projects/`, `plans/`, `sessions/`.
- When writing a path into a skill, script, hook, or settings file, always use
  `~/.config/claude/…` (or `$XDG_CONFIG_HOME/claude/…`). Never hardcode `~/.claude`
  — a wrong path there fails silently instead of erroring, which is hard to debug.
