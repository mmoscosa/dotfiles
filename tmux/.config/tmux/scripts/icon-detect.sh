#!/usr/bin/env bash
# icon-detect.sh — returns an icon based on the running process in the current pane
# Usage: icon-detect.sh <pane_current_command> [window_name]

CMD="$1"
WNAME="${2:-}"

case "$CMD" in
  claude|claudio)  echo "🤖" ;;
  nvim|vim|vi)     echo "" ;;
  lazygit)         echo "" ;;
  node|npm|npx)    echo "" ;;
  python|python3)  echo "" ;;
  docker|docker-*) echo "" ;;
  ssh|scp)         echo "" ;;
  git)             echo "" ;;
  make|cargo|go)   echo "" ;;
  *)
    # Fallback: use window name if it has a known keyword
    case "$WNAME" in
      *claude*) echo "🤖" ;;
      *shell*)  echo "" ;;
      *logs*)   echo "" ;;
      *edit*)   echo "" ;;
      *)        echo "" ;;
    esac
    ;;
esac
