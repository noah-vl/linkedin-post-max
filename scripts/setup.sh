#!/usr/bin/env bash
# Resolve and prepare the linkedin-post-max data directory.
#
# User content (voices, topics, templates, the author registry, the inspo
# inbox) lives OUTSIDE the skill folder so that updates — including the
# Claude Code plugin cache refresh, which replaces the skill folder wholesale —
# can never overwrite it.
#
# Idempotent: safe to run at the start of every session. Prints the resolved
# data directory as the last line, e.g. `DATA_DIR=/Users/you/.linkedin-post-max`.
#
# No shell? Do the equivalent by hand: create the data directory (below) with
# config/ voices/ topics/ templates/ inspo/ subfolders, and copy
# config/people.example.yaml to <data>/config/people.yaml.
set -uo pipefail

# 1. Resolve the data directory.
#    - On Claude Code plugin installs, $CLAUDE_PLUGIN_DATA is a persistent dir
#      that survives updates.
#    - Everywhere else (clone, npx, other agents), use a stable home folder.
DATA="${CLAUDE_PLUGIN_DATA:-$HOME/.linkedin-post-max}"

# 2. Resolve the skill folder (where the shipped templates/examples live).
#    Follow symlinks so invocation via a symlinked path still finds the tree.
if [ -n "${CLAUDE_PLUGIN_ROOT:-}" ]; then
  SKILL_DIR="$CLAUDE_PLUGIN_ROOT"
else
  src="${BASH_SOURCE[0]:-$0}"
  while [ -h "$src" ]; do
    dir="$(cd -P "$(dirname "$src")" && pwd)"
    src="$(readlink "$src")"
    case "$src" in /*) ;; *) src="$dir/$src" ;; esac
  done
  SKILL_DIR="$(cd -P "$(dirname "$src")/.." && pwd)"
fi

# 3. Create the data layout. This must succeed; if it can't, stop loudly
#    (without it, nothing else works) and do NOT print a DATA_DIR line.
if ! mkdir -p "$DATA/config" "$DATA/voices" "$DATA/topics" "$DATA/templates" "$DATA/inspo"; then
  echo "ERROR: could not create data directory at $DATA" >&2
  exit 1
fi

# 4. One-time migration: older versions stored user data inside the skill
#    folder. Move any such files into the data dir. Never overwrite, never move
#    shipped files (_template.md, *.example.*). Migration is best-effort: a
#    failed move warns but does not abort, so the DATA_DIR contract line below
#    always prints.
[ -f "$SKILL_DIR/config/people.yaml" ] && [ ! -f "$DATA/config/people.yaml" ] && \
  { mv "$SKILL_DIR/config/people.yaml" "$DATA/config/people.yaml" || echo "WARN: could not migrate config/people.yaml" >&2; }
for d in voices topics templates; do
  for f in "$SKILL_DIR/$d"/*.md; do
    [ -e "$f" ] || continue
    b="$(basename "$f")"
    case "$b" in _template.md | *.example.* ) continue ;; esac
    [ -e "$DATA/$d/$b" ] || mv "$f" "$DATA/$d/$b" || echo "WARN: could not migrate $d/$b" >&2
  done
done
for f in inbox.md archive.md; do
  [ -f "$SKILL_DIR/inspo/$f" ] && [ ! -f "$DATA/inspo/$f" ] && \
    { mv "$SKILL_DIR/inspo/$f" "$DATA/inspo/$f" || echo "WARN: could not migrate inspo/$f" >&2; }
done

# 5. Bootstrap the author registry from the shipped example if still missing.
[ -f "$DATA/config/people.yaml" ] || \
  cp "$SKILL_DIR/config/people.example.yaml" "$DATA/config/people.yaml" || \
  echo "WARN: could not bootstrap config/people.yaml" >&2

echo "DATA_DIR=$DATA"
