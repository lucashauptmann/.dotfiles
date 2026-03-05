#!/bin/sh
input=$(cat)

cwd=$(echo "$input" | jq -r '.workspace.current_dir // .cwd')
dir=$(echo "$cwd" | sed "s|$HOME|~|")
model=$(echo "$input" | jq -r '.model.display_name')
remaining=$(echo "$input" | jq -r '.context_window.remaining_percentage // empty')

# git branch + dirty state
git_branch=$(git -C "$cwd" symbolic-ref --short HEAD 2>/dev/null || git -C "$cwd" rev-parse --short HEAD 2>/dev/null)
git_dirty=$(git -C "$cwd" status --porcelain 2>/dev/null | head -1)

# ANSI colors via printf interpretation
blue=$(printf '\033[38;5;75m')
green=$(printf '\033[38;5;78m')
purple=$(printf '\033[38;5;183m')
ctx_green=$(printf '\033[38;5;114m')
reset=$(printf '\033[0m')

# detect worktree name
worktree_name=""
case "$cwd" in
  */.claude/worktrees/*) worktree_name=$(basename "$cwd") ;;
esac

if [ -n "$git_branch" ]; then
  wt=""
  if [ -n "$worktree_name" ]; then
    wt=" (worktree: ${worktree_name})"
  fi
  if [ -n "$git_dirty" ]; then
    git_info="  🌿 ${green}${git_branch}${wt} *${reset}"
  else
    git_info="  🌿 ${green}${git_branch}${wt}${reset}"
  fi
else
  git_info=""
fi

# Line 1: dir (blue) | branch (green) | model (purple)
printf '%s' "📁 ${blue}${dir}${reset}${git_info}  🤖 ${purple}${model}${reset}"
printf '\n'

# Line 2: context bar
if [ -n "$remaining" ]; then
  used=$((100 - remaining))
  filled=$((used / 10))
  empty=$((10 - filled))
  bar=""
  i=0; while [ $i -lt $filled ]; do bar="${bar}="; i=$((i + 1)); done
  i=0; while [ $i -lt $empty ]; do bar="${bar}-"; i=$((i + 1)); done
  if [ "$used" -ge 70 ]; then
    ctx_color=$(printf '\033[38;5;203m')
  elif [ "$used" -ge 40 ]; then
    ctx_color=$(printf '\033[38;5;220m')
  else
    ctx_color=$ctx_green
  fi
  printf '%s' "🧠 ${ctx_color}Context: ${used}% [${bar}]${reset}"
fi
