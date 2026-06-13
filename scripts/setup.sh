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
set -euo pipefail

# 1. Resolve the data directory.
#    - On Claude Code plugin installs, $CLAUDE_PLUGIN_DATA is a persistent dir
#      that survives updates.
#    - Everywhere else (clone, npx, other agents), use a stable home folder.
DATA="${CLAUDE_PLUGIN_DATA:-$HOME/.linkedin-post-max}"

# 2. Resolve the skill folder (where the shipped templates/examples live).
SKILL_DIR="${CLAUDE_PLUGIN_ROOT:-$(cd "$(dirname "$0")/.." && pwd)}"

# 3. Create the data layout.
mkdir -p "$DATA/config" "$DATA/voices" "$DATA/topics" "$DATA/templates" "$DATA/inspo"

# 4. One-time migration: older versions stored user data inside the skill
#    folder. Move any such files into the data dir (never overwrite, never
#    touch the shipped _template.md files).
if [ -f "$SKILL_DIR/config/people.yaml" ] && [ ! -f "$DATA/config/people.yaml" ]; then
  mv "$SKILL_DIR/config/people.yaml" "$DATA/config/people.yaml"
fi
for d in voices topics templates; do
  for f in "$SKILL_DIR/$d"/*.md; do
    [ -e "$f" ] || continue
    b="$(basename "$f")"
    [ "$b" = "_template.md" ] && continue
    [ -e "$DATA/$d/$b" ] || mv "$f" "$DATA/$d/$b"
  done
done
for f in inbox.md archive.md; do
  if [ -f "$SKILL_DIR/inspo/$f" ] && [ ! -f "$DATA/inspo/$f" ]; then
    mv "$SKILL_DIR/inspo/$f" "$DATA/inspo/$f"
  fi
done

# 5. Bootstrap the author registry from the shipped example if still missing.
if [ ! -f "$DATA/config/people.yaml" ]; then
  cp "$SKILL_DIR/config/people.example.yaml" "$DATA/config/people.yaml"
fi

echo "DATA_DIR=$DATA"
