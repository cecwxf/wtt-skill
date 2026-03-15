#!/usr/bin/env bash
set -euo pipefail

SKILL_DIR="${WTT_SKILL_DIR:-$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)}"
cd "$SKILL_DIR"

choose_py() {
  local c

  if [[ -n "${WTT_PY_BIN:-}" ]] && [[ -x "${WTT_PY_BIN}" ]]; then
    echo "${WTT_PY_BIN}"
    return 0
  fi

  local candidates=(
    "$SKILL_DIR/.venv/bin/python"
    "$SKILL_DIR/.venv311/bin/python"
    "$HOME/.openclaw/workspace/skills/.venv311/bin/python"
  )

  for c in "${candidates[@]}"; do
    if [[ -x "$c" ]]; then
      echo "$c"
      return 0
    fi
  done

  command -v python3
}

PY="$(choose_py)"
if [[ -z "$PY" || ! -x "$PY" ]]; then
  echo "❌ No runnable python found for wtt autopoll"
  exit 1
fi

exec "$PY" "$SKILL_DIR/start_wtt_autopoll.py"
