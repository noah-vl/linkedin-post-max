# Workflow: Generate Post Ideas

Generate LinkedIn post ideas for an author from two sources: their durable topics/voice (evergreen) and fresh items in the inspo inbox (anchored). No live research here — external content enters only via `workflows/discover.md`.

**Hard rules — never violate:**

1. **Never generate full drafts here.** Only ideas with hooks. Drafting belongs in `workflows/create-post.md`.
2. **Timely claims may only come from inspo inbox items.** No inbox item → no timeliness → mark the idea `[evergreen]`. Never invent recent events, news, or data points.

Full guardrails: see the "Don't" section at the bottom.

## Input

The user provides the author slug. If missing, ask: "Who should I generate ideas for?"

Optional modifiers:
- A specific topic to focus on (otherwise mix across all their topics)
- A count (default 5-8)
- A vibe ("more spicy," "more grounded," "more personal")

## Step 1: Load context

Run `bash scripts/setup.sh` first and use its `DATA_DIR` output as `$DATA`. All user files below live under `$DATA/` (the `_template`/`.example` files are in the skill folder — see SKILL.md § Where your files live).

1. Read `config/people.yaml`. Find the author.
2. If not found or `active: false`, stop.
3. Read their voice profile (`voice:`).
4. Read **all** their topic files (`topics: [...]`).
5. Read their available templates if any.
6. Read `inspo/inbox.md` if it exists. Run inbox hygiene (`workflows/discover.md` § Inbox hygiene). Eligible fuel = `fresh` items whose `topics` overlap the author's topics.

## Step 2: Generate 5-8 ideas

Each idea must be **rooted in one of the author's topics**, not generic LinkedIn content. Ideas come in two kinds, mixed in one list:

- **`[anchored]`** — reacts to an eligible inbox item: extend it, push back on it, or apply it somewhere new. Cites the item's title + link.
- **`[evergreen]`** — from durable topic angles alone. No timely claims.

Target mix when fuel exists: roughly half anchored. Never pad — one fitting inbox item means one anchored idea. Empty inbox means all evergreen.

For each idea, produce:

- **Hook** — the opening line or angle. One sentence. Should sound like something they'd actually write (check against the voice file's Hooks list).
- **Angle** — what the post argues, explores, or shares. 1-2 sentences.
- **Topic** — which topic file this draws from.
- **Template hint** — if the idea naturally fits one of the author's templates, tag it (e.g., `[hiring]`). Otherwise `[freeform]`. This is a suggestion, not a commitment.
- **Why now** — for `[anchored]` ideas: cite the inbox item ("reacting to *[title]*, saved [date]") with its link. For `[evergreen]` ideas: a durable reason (a pattern, a personal observation) — never a timeliness claim.

## Idea quality bar

- Specific over generic. "Why we stopped doing standups" beats "thoughts on team rituals."
- A point of view, not a topic. "Hiring is a forcing function for figuring out what your team actually does" beats "the importance of hiring."
- Something only this person could credibly write. Cross-reference the voice file's "Why this person cares" sections in topics.
- Varied formats. Mix shorter commentary with longer narrative ideas. Mix evergreen with anchored when fuel exists.
- No competitor name-checking unless the user has explicitly said it's fine.

## Step 3: Present

```
Ideas for [author] across [topic-1, topic-2, topic-3]:

1. **[Hook]**
   Angle: [1-2 sentences]
   Topic: [topic-slug] · Template: [hint] · [anchored|evergreen] — [why now]

2. **[Hook]**
   Angle: [1-2 sentences]
   Topic: [topic-slug] · Template: [hint] · [anchored|evergreen] — [why now]

[...]

Which would you like to develop? Pick one (or more) and I'll move to drafting.
```

If the list came out all/mostly evergreen because no eligible inbox items exist, say so in one line: "Mostly evergreen this time — no fresh inspo for this author. Want a discovery run first?"

## Step 4: Hand off

When the user picks an idea, pass it straight to `workflows/create-post.md`. Use the hook as the idea seed, the template hint as a starting guess (still confirm before applying). For `[anchored]` picks, pass the full inbox item (title, link, gist) along with the hook — the source travels with the seed.

## Don't

- Don't generate full drafts here. Only ideas. The draft workflow exists for a reason.
- Don't repeat ideas across runs in the same session. If the user asks for more, generate *different* angles.
- Don't pad to hit a count. 5 strong ideas beat 8 mediocre ones.
- Don't invent recent events, news, or data points. Timeliness comes from inbox items only; otherwise mark `[evergreen]`.
- Don't fabricate or stretch what an inbox item says — the anchored idea must be honest to the gist and source.
