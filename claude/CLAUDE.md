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
