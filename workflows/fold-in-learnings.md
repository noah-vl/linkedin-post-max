# Workflow: Fold In Learnings

Promote accumulated observations from `voices/<slug>-learnings.md` into the canonical voice file `voices/<slug>.md`. User-invoked only — never automatic.

**Hard rules — never violate:**

1. **Never auto-edit the voice file.** Always show the proposed edits to the user and wait for explicit approval.
2. **Never delete the learnings file.** Always archive (rename with a date suffix). Preserves history.
3. **Never silently swallow contradictions.** If a proposed rule conflicts with an existing canonical rule, flag it inline so the user can decide.

Full guardrails: see "Things to never do" at the bottom.

## When this fires

The user invokes with phrases like:
- "Fold in <author>'s learnings"
- "Review <author>'s learnings"
- "Promote <author>'s learnings"

If the author slug isn't given, ask. If multiple authors exist and the user said only "fold in learnings", list active authors and ask which.

## Step 1: Load and check

1. Read `config/people.yaml`. Find the author by slug. If not found or `active: false`, stop and tell the user.
2. Check that `voices/<slug>-learnings.md` exists.
   - If missing or empty (no entries below the header), tell the user: "Nothing to fold in for <name> — the learnings file is empty or doesn't exist yet."
   - If present, read it.
3. Read the canonical voice file `voices/<slug>.md` so you know its section structure.

## Step 2: Group entries by voice-file section

Read every entry in the learnings file. For each, decide which voice-file section it would update:

- Hook style observations → **Hooks** section
- Patterns the user rejects → **Constructions to Avoid** / **Things They'd Never Say**
- Word/phrase preferences → **Vocabulary Patterns**
- Length preferences → **Length** section
- Tone shifts → **Tone** section

If an observation doesn't clearly map to a section, place it under an "Other / unclassified" group and surface it explicitly.

## Step 3: Propose specific edits

For each group, draft a specific markdown edit to the voice file. Include the source observations as evidence. **Before proposing each rule, scan the existing canonical voice file for contradictions.** If the proposed rule contradicts an existing canonical rule, flag the conflict so the user can decide whether to replace, keep both, or drop the new rule.

Format your proposal like:

```
**Group: Hooks** (3 observations)

  1. Add to bullet list: "Opens with declaration or observation, never a question."
     Source: 2026-05-20 — picked Option 2 for declarative hook; 2026-05-22 — iterated to rewrite a question hook; 2026-05-23 — active feedback "hook felt more like me"
     Confidence: medium

**Group: Constructions to Avoid** (1 observation)

  2. Add bullet: "Arrow lists unless they're carrying real information — not decorative."
     Source: 2026-05-20 — active feedback "arrow list felt forced"
     Confidence: low
     ⚠ Conflicts with existing rule under "Vocabulary Patterns": "Frequently uses arrow lists (→) for takeaways, steps, features." Replace, keep both, or drop?
```

Present groups in order: highest-confidence first. Surface conflicts inline with the rule that triggered them — don't bury them in a separate section.

## Step 4: Get user approval

Ask the user:

> Approve all / pick which (e.g., "1, 3, 4") / skip a group ("skip group 2") / edit a rule before approving ("change #2 to: 'no decorative arrow lists ever'") / cancel

Process the response. If the user edits a rule before approving, use their wording in the final edit.

## Step 5: Apply approved edits to the voice file

For each approved item:

1. Locate the target section in `voices/<slug>.md`.
2. Append the new bullet/sentence to that section in the appropriate style.
3. Preserve all hand-written content above and below.

If the target section doesn't exist in the voice file (e.g., no "Length" subsection yet), create it in the natural place (after Sentence Structure, before Hooks).

## Step 6: Archive the active learnings file

After all approved edits are applied:

1. Rename `voices/<slug>-learnings.md` to `voices/<slug>-learnings-archived-YYYY-MM-DD.md`. Use today's date.
   - If a file with that name already exists (multiple fold-ins in one day), append `-2`, `-3`, etc.
2. The active log is now empty (it doesn't exist). Next passive capture will recreate it.

Report to the user:

> Folded N rules into voices/<slug>.md. Archived previous learnings to voices/<slug>-learnings-archived-YYYY-MM-DD.md.

## Things to never do

- Don't auto-edit the voice file without showing the proposed edits first.
- Don't delete the learnings file. Always archive.
- Don't bundle multiple observations into a single rule unless they really are the same preference.
- Don't drop the "Other / unclassified" group silently. Always surface unmappable observations so the user can decide.
- Don't fold in low-confidence observations without flagging the confidence to the user.
