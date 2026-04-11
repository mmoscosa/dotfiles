#!/usr/bin/env bash
# git-branch.sh — returns the current git branch for a given path
# Usage: git-branch.sh <path>

DIR="$1"
if [ -z "$DIR" ]; then
  exit 0
fi

BRANCH=$(git -C "$DIR" symbolic-ref --short HEAD 2>/dev/null)
if [ -n "$BRANCH" ]; then
  echo " $BRANCH"
fi
