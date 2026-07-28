#!/bin/sh
# Claude Code PreToolUse hook: block `git commit` / `git push`, even when
# buried inside a chained command (foo && git commit ..., (git push), etc.).
#
# Contract: reads the tool-call JSON on stdin; exit 2 blocks the tool and
# feeds stderr back to Claude; exit 0 allows. Only ever blocks git commit/push.

input=$(cat)

# Pull the Bash command out of the tool input. Fall back to the raw payload
# if jq isn't on PATH (still safe — we only ever match, never mutate).
if command -v jq >/dev/null 2>&1; then
  cmd=$(printf '%s' "$input" | jq -r '.tool_input.command // ""')
else
  cmd=$input
fi

# Match a `git` invocation whose subcommand is commit or push, tolerating
# global options and their args (git -C path commit, git --no-pager push) and
# any command chaining (; && || | newline, subshells). Anchored so it won't
# fire on `mygit`, and the trailing boundary avoids `git commit-graph`.
if printf '%s' "$cmd" | grep -Eiq '(^|[^[:alnum:]._/-])git[[:space:]]+([^;&|]*[[:space:]])?(commit|push)([[:space:]]|$)'; then
  echo "Blocked by local hook: 'git commit' and 'git push' are disabled in this setup." >&2
  echo "Leave the changes staged/working and let the user commit and push themselves." >&2
  exit 2
fi

exit 0
