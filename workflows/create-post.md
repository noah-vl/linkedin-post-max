# Workflow: Create a Post

Turn an idea into a publish-ready LinkedIn post. Auto-routes between a develop-idea dialogue (for vague ideas) and direct drafting (for already-specific ideas).

**Hard rules — never violate:**

1. **Never fabricate** metrics, customers, partners, integrations, features, or quotes. Use `<ASSUMPTION: [what you need]>` placeholders if information is missing.
2. **Never wrap post bodies in code blocks.** They render with indentation in the CLI and break copy-paste — which is the marquee delivery feature.
3. **Never ask "ready to draft?"** after develop-idea. Termination is decisive: announce *"I have what I need — drafting"* and go.

Full guardrails: see "Things to never do" at the bottom.

## Input

The user provides:
- **The idea** — a hook, observation, angle, or topic
- **The author** — whose voice to use (slug from `config/people.yaml`)

If either is missing, ask. Accept input in any natural form.

**No-seed entry:** if the user gave no idea at all and `inspo/inbox.md` has `fresh` items, offer once before asking what the post is about: "You have N fresh inspo items — draft from one, or start from scratch?" Stay silent about the inbox when it's empty or has no fresh items. When opening the inbox, run inbox hygiene (`workflows/discover.md` § Inbox hygiene). If the author is also missing, make the offer first — a picked item's single `suggested:` author becomes the author (multiple → ask which).

## Step 1: Load the author's voice

1. Read `config/people.yaml`. Find the author by slug.
2. If `active: false` or the author doesn't exist, stop and tell the user.
3. Read the voice profile from the path in `voice:`.
4. Also read `voices/<slug>-learnings.md` if it exists. This file contains observations from recent drafting sessions, kept as soft hints until the user folds them into the canonical voice file.
5. When generating drafts in Step 5, use BOTH files:
   - The canonical voice file is **law**. Its rules always win on conflicts.
   - The learnings file is **soft hints**. It supplements the canonical voice in areas the canonical voice is silent on.
   - High-confidence learnings (3+ occurrences) carry more weight than low-confidence ones.
   - If the canonical voice says "X" and a learning says "not X", the draft follows the canonical voice. The learning will only bite after fold-in.
6. If the voice file still contains template placeholders (e.g., `[Name]`, `[Adjective]`), warn the user: "Heads up — this voice profile is thin. The draft will be more generic than usual. Consider running onboarding again or editing the file by hand."

## Step 2: Auto-detect template (only if templates exist)

1. Read the author's `templates:` list from `people.yaml`. If empty, skip to Step 3 (freeform).
2. For each available template, read `templates/<slug>.md` and scan its **Detection keywords** against the idea text.
3. **If a match is found:** surface it. "This looks like a hiring post — want me to use the hiring template, or go freeform?" Wait for confirmation. Never apply silently.
4. **If no match:** proceed freeform. Don't mention the templates.
5. **If the user specified a template explicitly** in the input, use that one regardless of detection.

## Step 3: Assess richness and route

Read the idea text. Decide which path:

**Route to direct draft (Step 5) when the idea has both:**
1. A specific entity — a named person, a number, a named event, a concrete moment or observation, AND
2. A clear take — an actual point of view, not just a topic.

**Route to develop-idea (Step 4) otherwise.**

### Worked examples — direct draft

- "Killing the JD this quarter — we replaced it with a one-page taste doc, and it worked on our last hire." → specific take + concrete anchor (the hire).
- "Speaking at a finance ops conference next month about agentic AI in production." → specific event + topic.
- "Hot take from yesterday's podcast I was on: control isn't what limits growth — bad controls do." → specific source + sharp take.

### Worked examples — develop-idea

- "Post about hiring." → no take, no anchor.
- "Something about AI in finance." → topic without angle.
- "I want to write something this week." → no idea content at all.

### Announce the routing decision

Always tell the user in one short line:

- Direct draft: "Specific enough — drafting now. Say 'develop first' if you want to shape it more."
- Develop-idea: "Open one — let me develop this with you. Say 'just draft' to skip."

### Honor explicit overrides

If the user's input contains "just draft" or "rough draft", force direct draft regardless of richness.
If the user's input contains "develop first" or "develop this", force develop-idea regardless of richness.

## Step 4: Develop-idea mode (if routed here)

Adaptive coach loop. Ask one focused question at a time. The skill aims to land two ingredients before drafting:

- **Angle** — the specific take the user wants to make (not the topic)
- **Anchor** — a concrete real thing the post stands on (number, person, moment, observation)

After each user response, judge whether you have both. When you do, stop and draft.

### How to open the dialogue

Open with what you have, then ask one question. If the user's input is vague, lead with proposed angles before asking.

Template:

> Here's what I've got so far: [reflect the idea in one line].
>
> [If angle is unclear] I see three ways you could land this:
>   1. [Angle A — 1 line]
>   2. [Angle B — 1 line]
>   3. [Angle C — 1 line]
>
> Which one speaks to you, or pitch yours?

### How to keep the dialogue moving

Each turn, the skill decides: ask for missing ingredient, or actively propose. The rule: **more user information → fewer proposals from the skill. Less user information → more proposals.**

### The three suggestion types

Use these when the user hasn't filled in a blank:

**Alternative angles** — Propose 3 different framings of the topic when the angle is vague. Example:
> "Post about hiring" → contrarian ("We killed the JD"), build-in-public ("Notes from rewriting our hiring process"), anecdotal ("How our last hire never saw a JD").

**Hook drafts** — Once the angle is clear, propose 3 specific opening lines for the user to pick or use as inspiration. Example:
> Angle = "Taste docs replaced our JDs."
> Hooks:
>   1. "We killed the job description this quarter."
>   2. "Our last three hires didn't have a JD to read."
>   3. "What if you stopped writing JDs and started writing taste docs?"

**Counter-angles** — When a take feels one-sided, push back as a coach would. Frame as the pushback the user would face, not a lecture. Example:
> "The pushback you'd get on this: 'doesn't scale past 20 people.' Want to address it head-on, or let it ride?"

### Termination

Decisive. When both angle and anchor are clear, stop asking and draft. Announce in one line:

> "I have what I need — drafting."

Do NOT ask "ready to draft?" or "shall I proceed?". Just go.

### Hard cap

After **4 user turns** in develop-idea (not counting the initial idea), force the draft. If ingredients are still missing, use `<ASSUMPTION: [what's missing]>` placeholders in the draft.

A "user turn" = one user message in the develop-idea phase. Skill replies don't count.

**Approaching the cap (turn 3-4):** name it before forcing. Say something like *"One more turn, then I'll draft with what we have."* This avoids a jarring mid-conversation draft when the user feels they were about to say something useful.

### Escape hatches

The user can break out of develop-idea at any time:
- "Just draft" / "Draft it" / "Stop, draft now" → skip to Step 5 immediately.
- "Back up" / "Different angle" → reset the dialogue, propose fresh angles.

## Step 5: Generate the draft

Write the LinkedIn post following this priority:

- **Voice first.** Match the person's tone, vocabulary, sentence structure, and perspective from their voice profile. Read their example posts carefully and mirror the style. Use the hooks list to inspire the opening line — don't copy verbatim, but write something that could belong on that list.
- **Template second (if applicable).** Follow the template's structure and incorporate its tone modifiers. Voice always wins on tone; template shapes format.
- **Anchor.** If develop-idea surfaced a specific anchor (person, number, moment), use it in the post. If it's missing, use `<ASSUMPTION: ...>` placeholders rather than inventing.
- **Inbox-item seed.** If the seed is an inspo inbox item — including an `[anchored]` idea handed off from `workflows/ideas.md` — fetch the actual source (use your agent's web-fetch capability) before drafting; the gist is too thin to write from honestly. Claims about the piece must come from the piece; quote or paraphrase faithfully. Name the source in the body but keep the URL out of the post text. If the fetch fails, draft from the gist with `<ASSUMPTION: source unverified>` and say so.
- **Length.** Use the voice file's typical length range. If absent, aim for 150-250 words. Short and punchy beats long and thorough.
- **Format.** Text only. No carousels, polls, or images. Generous line breaks between paragraphs (LinkedIn scannability).
- **No hashtags, em-dashes, bold text, or emoji** unless the voice file explicitly says the author uses them.

## Step 6: De-slop the draft

**Mandatory.** Every draft passes through de-slop before output.

Try the `stop-slop` skill first if your agent can invoke other skills. If it's not available, run this inline checklist on the draft:

### Inline de-slop checklist

Strip or rewrite any of these:

- **Filler openers:** "In today's [adjective] world," "More than ever," "In an era where," "It's no secret that"
- **AI assistant tells:** "I hope this helps," "It's worth noting that," "It's important to remember"
- **Hedging:** "arguably," "perhaps," "in some ways," "could be considered"
- **Generic transitions:** "Here's the thing," "But here's why," "The truth is," "Let me explain"
- **LinkedIn influencer hooks:** "I'll say it again," "Hot take:", "Unpopular opinion:", "Nobody talks about this but"
- **Marketing-speak:** unlock, leverage, synergy, revolutionize, game-changing, cutting-edge, next-gen, paradigm shift
- **Fake intimacy:** "Let's be honest," "Real talk," "Between you and me"
- **Rhetorical question transitions:** "Why does this matter?" — go straight to the answer.
- **"It's not X, it's Y"** constructions — just say what it is.
- **Em-dashes** — replace with commas, periods, or colons.
- **Empty closes:** "Food for thought," "What do you think?", "Thoughts?" unless the voice file uses them.

Then cross-check against the voice file's **Constructions to Avoid** and **Things They'd Never Say** sections. Remove anything that violates them.

## Step 7: Present 2-3 variations

Produce **2-3 variations** of the draft. Each takes the same core message but varies one of: hook, structure, emphasis.

**Output format — important:** Present each variation as **plain prose** under a markdown heading. Do NOT wrap the post body in code blocks. This is the copy-paste fix: code blocks render with indentation in the CLI, which corrupts copy-paste. Plain prose under headings renders flush left.

Use this exact format:

```
## Option 1 — [hook angle in one short label]

[post body, plain prose, blank lines between paragraphs]

---

## Option 2 — [hook angle]

[post body]

---

## Option 3 — [hook angle]

[post body]
```

After the variations, in plain prose (not a code block), include:

- A short metadata line: `Author: <name> · Template: <name or "freeform"> · Word counts: <N / N / N>`
- If the seed was an inbox item, one line: `Source link: in the post / first comment / leave out — say which.` (Default if unspecified: first comment.)
- A `Missing details / assumptions:` section if any `<ASSUMPTION: ...>` placeholders appeared.
- The question: `Which do you want? I'll copy it to your clipboard. ("Option 2" / "the contrarian one" / "the second" all work.)`

## Step 8: Deliver to clipboard

Once the user picks a variation by number, label, or natural-language reference ("the contrarian one", "option 2", "the second"), resolve the selection to the exact draft text.

Then copy it to the clipboard.

### Try pbcopy first (macOS)

Pass the chosen draft text via a heredoc so apostrophes, quotes, and newlines survive intact:

```bash
pbcopy <<'POST_EOF'
[draft text goes here exactly, with all original formatting]
POST_EOF
```

Use the literal sentinel `POST_EOF` (with the single-quoted opener `<<'POST_EOF'` so the heredoc body is taken verbatim — no variable expansion, no quote escaping). If the chosen draft happens to contain the exact line `POST_EOF`, pick a different sentinel like `END_OF_POST`.

If `pbcopy` returns exit code 0, report:

> Copied Option N to clipboard.

### Fall back to xclip (Linux)

If `pbcopy` is missing or fails, try the same heredoc pattern piped to xclip:

```bash
xclip -selection clipboard <<'POST_EOF'
[draft text goes here exactly]
POST_EOF
```

If `xclip` succeeds, report:

> Copied Option N to clipboard (via xclip).

### Graceful failure

If both commands fail (Windows, neither tool installed, etc.), reprint the chosen variation in plain prose under a single heading and tell the user:

> Couldn't reach the clipboard. Here's Option N again — select and copy manually:
>
> [chosen draft text in plain prose]

### Mark inbox item used

If the seed was an inspo inbox item, update its `status` in `inspo/inbox.md` to `used` now. Delivery counts whether it went via pbcopy, xclip, or the manual reprint. If the user says another author should still take their own angle on it, leave it `fresh` instead. Link placement: "first comment" (or unspecified) → print the URL on its own line after the copy confirmation so the user can paste it; "in the post" → add the URL to the chosen draft before copying.

### Active 1-line check

After reporting the successful clipboard copy, ask one short question:

> Quick one — what made you pick #N over the others? (or `skip`)

Replace `#N` with the option number the user actually picked.

**Skip handling:** if the user types "skip", says nothing for a beat, or moves to a new request (e.g., "now draft another"), do NOT capture. Do not re-ask later in the same session — if they skipped once, respect that for the rest of the session.

**Engagement handling:** if the user gives a substantive answer:

**What counts as substantive:** the answer references something about the draft — hook, structure, vocabulary, tone, length, close, anchor, voice. If the user's message is instead a new request (e.g., "now draft another for <author>," "brainstorm ideas next," "fold in <author>'s learnings"), route to that request and treat the active check as skipped — do NOT try to interpret a new request as an answer to the 1-line question.

1. Interpret the answer in voice-rule terms. Identify 1-3 specific rules at most. Be conservative — don't over-interpret.
2. Propose specific edits to `voices/<slug>.md` (the canonical voice file — this signal is strong enough to update law directly, not just learnings).
3. Present each proposed edit with its target section in the voice file.
4. Ask: "Approve all / pick which (e.g., '1, 3') / skip?"

**Example:**

> You: "The hook felt more like me. The arrow list in Option 1 felt forced."
>
> Skill: I hear two things. Proposed edits to `voices/<slug>.md`:
>   1. Under **Hooks**: add "Opens with declaration or observation, never a question."
>   2. Under **Constructions to Avoid**: add "Arrow lists unless they're carrying real information — not decorative."
>
>   Approve all / pick / skip?

**Apply approved edits.** For each approved item:

1. Append the new bullet to the named section of the canonical voice file, preserving surrounding content.
2. **Append a source-trace comment** directly after the new bullet, on its own line, using the markdown comment syntax:

   ```markdown
   <!-- Added YYYY-MM-DD from active check: "<one-line paraphrase of the user's answer>". -->
   ```

   This lets the user trace any canonical rule back to its origin when reviewing the voice file later. Use today's date and quote the user's answer (or a faithful one-line paraphrase).

Report:

> Updated voices/<slug>.md with N rules.

**Never:**
- Never propose an edit that contradicts an existing rule without flagging it: "Your voice file currently says X — this would replace it. Confirm?"
- Never bundle multiple rules into one if they're actually separate (e.g., a hook preference and a vocabulary preference go to different sections).
- Never re-ask the check after a skip in the same session.

### Iteration (with passive learning capture)

If the user asks for a tweak instead of picking (e.g., "shorter," "sharper hook," "drop the close," "mix Option 1's hook with Option 3's close"), do two things:

**1. Silently log the iteration to the learnings file.**

Append an entry to `voices/<slug>-learnings.md`. Create the file with the header below if it doesn't exist yet. Do this WITHOUT asking the user — no confirmation, no prompt.

File header (only written when creating the file for the first time):

```markdown
# Voice Learnings: <Name>

> Append-only log of observations from drafting sessions, active feedback, and post-back. The `create-post.md` workflow reads this file as soft hints during drafting. Run `fold in <slug>'s learnings` to promote rules into the canonical voice file.
```

Entry format (append below the most recent date heading, or add a new dated heading if today isn't represented):

```markdown
## YYYY-MM-DD

- **Iteration: "<exact words the user used>"** on <one-line topic of the draft> → <your interpretation of the voice rule this implies>. _Confidence: <low|medium|high> (<reasoning>)._
```

Confidence rule:
- `low` — first time seeing this pattern in the learnings file
- `medium` — corroborated by 2-3 similar observations in the file
- `high` — 4+ similar observations

Scan the existing file for similar patterns before assigning. Don't be precious — loose similarity counts.

**Reverts:** if the user reverts an iteration in the same session ("no, go back to option 1"), do NOT log the iteration. It's net-zero signal.

**2. Apply the tweak and re-present.**

Edit the draft per the user's request, re-run Step 6 (de-slop), and re-present using the same plain-prose format. Do not narrate the capture — the user shouldn't see "logged to learnings" or any sign of the silent capture.

## Things to never do

- Don't wrap post bodies in code blocks — it breaks copy-paste in the CLI.
- Don't start posts with "I" unless the voice file shows the author opens that way.
- Don't add a "key takeaway" or "TL;DR" section unless requested.
- Don't invent metrics, customers, partners, features, or quotes. Use `<ASSUMPTION: ...>` placeholders.
- Don't add emoji unless the voice file shows the author uses them.
- Don't pivot the post to be about AI unless the idea is specifically about AI.
- Don't moralize. The author has a point to make, not a lesson to teach.
- Don't add CTAs the user didn't request.
- Don't ask "ready to draft?" after develop-idea — termination is decisive.
- Don't offer next steps ("draft another? brainstorm?") after the clipboard is delivered. Stop.
