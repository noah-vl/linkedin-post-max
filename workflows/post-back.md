# Workflow: Post-Back

The user pastes a LinkedIn post they actually published. The skill reads it against the author's voice file, identifies patterns and deviations, and proposes additions: a new example post and any pattern observations.

**Hard rules — never violate:**

1. **Never compare to a stored draft.** Post-back operates on the published version alone. There is no diff against anything the skill produced earlier.
2. **Never auto-edit the voice file.** Always show the proposed updates and wait for explicit approval.
3. **Never fabricate patterns.** If a deviation has no clear interpretation, surface it to the user as a question — not as a proposed rule.

Full guardrails: see "Things to never do" at the bottom.

## When this fires

The user invokes with phrases like:
- "Post-back for <author>: <text>"
- "I published this for <author>: <text>"
- "Here's the actual posted version for <author>: <text>"

If the user pastes a long block of text without context, ask: "Is this a post-back? Which author?"

## Step 1: Confirm author + read inputs

1. Identify the author slug from the user's message. If unclear, ask.
2. Read `config/people.yaml` to confirm the author is active.
3. Read `voices/<slug>.md` (canonical voice).
   - **If the file doesn't exist or contains only template placeholders** (e.g., `[Name]`, `[Adjective]`), stop and tell the user: *"No voice profile for <name> yet — run onboarding first so post-back has something to read against."* Post-back without a voice baseline produces nonsense deviations, so we don't proceed.
4. Read `voices/<slug>-learnings.md` if it exists (for context — what patterns are already being tracked).
5. Read the published post text the user pasted.

## Step 2: Read against the voice file

Examine the published post and produce observations across these dimensions:

- **Word count** vs the voice file's typical range
- **Hook style** vs the documented hooks list (declarative? question? observation? anecdote?)
- **Vocabulary** — any voice-tagged signature phrases used? Any avoided words used?
- **Structure** — paragraph length, line breaks, presence/absence of arrow lists or other signature elements
- **Length and rhythm** — sentence variety, density
- **Anchor** — does the post have a concrete real-world anchor (number, person, moment, observation)?

For each observation, note: is this **consistent with the voice file**, **a documented pattern**, or **a deviation**?

## Step 3: Present observations

Format:

```
Got it — reading this against <name>'s voice.

Observations:
- **<word count>** (typical range is <range> — <comparison: matches / sharper than usual / longer than usual>)
- **Hook style: <type>** — "<first line>" (<comparison to documented hooks>)
- **<other notable patterns>** (consistent / deviation)
- **<anchor observation>**

Voice rules echoed:
- <rule from voice file that this post follows>
- <another>

Possible deviations:
- <something that doesn't match the voice file, if any>
```

## Step 4: Propose updates

Based on observations, propose specific updates to `voices/<slug>.md`. Common categories:

- **New example post** — if the post is a strong representative of the voice, propose adding it to the "Example Posts" section with a brief "why this captures their voice" note.
- **Pattern observations** — if the post repeatedly shows a pattern not yet codified, propose adding it as a voice rule.
- **Length range tightening** — if the post (combined with recent learnings) suggests the user is writing shorter/longer than the documented range, propose tightening.
- **Hook/close style** — if the hook is a clear new pattern, propose adding it to Hooks.

Format:

```
Proposed updates to voices/<slug>.md:
  1. Add this post as Example N under "Example Posts" with note: "<reason>"
  2. <pattern observation as voice rule>: add to "<section>"
  3. <another if applicable>

Approve all / pick / skip?
```

## Step 5: Apply approved updates

For each approved item:

1. Locate the target section.
2. Apply the edit, preserving surrounding content.
3. For example posts, format as the existing examples in the voice file (with "Why this captures their voice:" note).

Report to the user:

> Applied N updates to voices/<slug>.md.

## Things to never do

- Don't auto-edit the voice file without showing the proposed updates first.
- Don't compare against a stored draft. Post-back stands alone.
- Don't add the post as an example if the user is correcting it ("here's how it should have been written" — but the user actually published something different). Always confirm: "Add this as a strong example?" before assuming.
- Don't propose a length range change based on a single post. Reference at least 3+ recent data points (the post + recent learnings or earlier examples).
- Don't fabricate patterns. If a deviation has no clear interpretation, surface it as a question to the user, not as a proposed rule.
