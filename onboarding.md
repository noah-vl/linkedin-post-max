# Onboarding

Set up a new author so the skill can write posts in their voice. The whole flow takes ~5 minutes. The goal is to get the user writing real posts as fast as possible — depth comes later, through use.

## Tone for the entire onboarding

- Conversational. One question at a time. No checklists.
- Make the user feel like the skill is paying attention. Quote things back.
- Skip everything that isn't critical. Defaults are fine.

## Step 1: Who are we setting up?

First, run `bash scripts/setup.sh` and use its `DATA_DIR` output as `$DATA`. Everything you create below — the voice file, topics, templates, and the `config/people.yaml` entry — gets written under `$DATA/` (read the `_template`/`.example` files from the skill folder; see SKILL.md § Where your files live). Never write into the skill folder.

Ask, in one message:

> Quick setup so I can write LinkedIn posts that sound like you (or a teammate). Takes about 5 minutes.
>
> Who are we setting up? Just tell me their first name and role (e.g., "<First Name>, <Role>" — or "<Company> company account" for a brand voice).

Parse into `name` (first name) and `role`. Slug = lowercase first name. If the slug already exists in `config/people.yaml`, ask whether to overwrite or pick a different slug.

## Step 2: Extract voice from past posts (the important step)

Ask:

> Paste 3-5 LinkedIn posts you've written recently. Full text, separated by `---`. The more posts, the sharper the voice I'll capture.
>
> If you don't have past posts (new account, ghost-writing, etc.) just say "no posts" and I'll build a voice from a short description instead.

### If the user pastes posts

Read every post carefully. Extract:

- **Tone** — 3-5 adjectives that describe how they communicate. Back each with evidence from the posts.
- **Vocabulary patterns** — words/phrases they use repeatedly. Domain-specific terms. Signature transitions.
- **Things they avoid** — patterns notably absent (no hashtags? no rhetorical questions? no em-dashes?).
- **Sentence structure** — short and punchy? Long-form? Mix? Paragraph length? Use of line breaks?
- **Hooks** — how they open posts. Copy 3-5 real opening lines verbatim into the voice file.
- **Closes** — how they end posts. CTA pattern? Forward look? Sign-off?
- **Post rhythm** — typical arc (e.g., "short hook → 2 body paragraphs → 1-line close").
- **Length** — word count range across the samples.

Be specific. "Direct" alone is useless. "Direct — opens with the news or observation, never a warm-up. The first line carries real information." is useful.

### If the user has no past posts

Ask a short fallback (~3 questions):

> No problem. Three quick ones:
>
> 1. Describe how you want to sound on LinkedIn in 2-3 sentences. (e.g., "Direct, no hype, like a senior engineer explaining something to a peer.")
> 2. Name 1-2 people whose LinkedIn voice you admire — what do you like about how they write?
> 3. Anything you'd never say or want to avoid? (e.g., influencer hooks, hashtags, emoji.)

## Step 3: Reflect the voice back

Before writing the file, show the user a tight summary:

> Here's what I picked up from your posts:
>
> **Tone:** [3-5 adjectives, each with one-line evidence]
> **Hooks you use:** [3-5 verbatim opening lines]
> **You tend to avoid:** [list]
> **Length:** [range] words
>
> Does this feel right? Anything to add or correct?

Iterate once or twice based on their feedback before saving.

## Step 4: Topic deep-dive

Ask:

> What do you want to post about? Give me 1-3 themes. (e.g., "company building, AI engineering, hiring")

For **each** topic, ask the full deep-dive — but in a single combined message, not three rounds:

> For each topic, tell me:
>
> 1. **What interests you about it?** Why do you actually have something to say here?
> 2. **What do you want to get across?** The point of view or message you want people to associate with you.
> 3. **Who is the audience?** Who do you want reading these posts? (e.g., CFOs, fellow founders, junior engineers.)
> 4. **Whose takes in this space do you admire?** People, accounts, or essays worth reading — these seed discovery runs. (Skip if none come to mind.)

Parse the response into one `topics/<slug>.md` file per topic. Answer 4 fills the "Voices that inspire" section; topic files stay durable — timely material lives in the inspo inbox, not here.

## Step 5: Templates (optional — skip by default)

Ask, briefly:

> Last thing — totally optional. Do you have any **recurring post types** I should make a template for? E.g., hiring announcements, product updates, event recaps, weekly recaps.
>
> Skip this if you mostly write freeform thought leadership — you can always add templates later.

If they name one or more, for each:
- Ask for the rough structure (3-5 bullets, what the post leads with → body → close).
- Ask for 1-2 example posts they've written in this format (if they have any).
- Write `templates/<slug>.md`.

Otherwise: skip cleanly. Don't ship empty templates.

## Step 6: Write everything to disk

Create / update these files:

1. **`voices/<slug>.md`** — fill from `voices/_template.md`. Use the data extracted in Step 2.
2. **`topics/<topic-slug>.md`** for each topic — fill from `topics/_template.md`. Use Step 4 data.
3. **`templates/<template-slug>.md`** for each (if any) — fill from `templates/_template.md`. Use Step 5 data.
4. **`config/people.yaml`** — append a new entry:
   ```yaml
   people:
     <slug>:
       name: <Name>
       role: <Role>
       active: true
       voice: voices/<slug>.md
       topics: [<topic-slug>, ...]
       templates: [<template-slug>, ...]   # empty list [] if skipped
   ```
   **First-run bootstrap:** if `config/people.yaml` doesn't exist, copy `config/people.example.yaml` to `config/people.yaml` first (`cp config/people.example.yaml config/people.yaml`), then append the new entry. The `.example` file is the clean baseline that ships with the skill; the live `people.yaml` holds your personal registry and is gitignored.

## Step 7: Confirm + first action

Tell the user what was created and offer one of two next steps:

> All set up. Here's what I made:
>
> - `voices/<slug>.md` — your voice profile
> - `topics/<slug>.md` × N — your topic files
> - `templates/<slug>.md` × N (if any) — your templates
>
> Want to:
> 1. **Draft a post right now** — give me an idea/hook and I'll write it
> 2. **See post ideas based on your topics** — I'll brainstorm 5-8 ideas
> 3. **Tune your voice** — open `voices/<slug>.md` and edit by hand, then re-run me

If they pick 1, hand off to `workflows/create-post.md`. If 2, hand off to `workflows/ideas.md`. If 3, just point them at the file path.

## Onboarding self-check

Before declaring onboarding complete:

- [ ] `voices/<slug>.md` exists and is filled (not just template placeholders)
- [ ] At least one `topics/<topic-slug>.md` exists and is filled
- [ ] `config/people.yaml` has the new author entry with correct paths
- [ ] User confirmed the voice summary felt accurate
- [ ] User knows the three next-step options

## Adding a second / third author

If the user comes back to add another author (e.g., onboarding a teammate), run this same flow. The only difference: don't re-create `config/people.yaml` — append to it.

## What to NEVER do during onboarding

- Don't ask 20 questions. The goal is fast time-to-first-draft.
- Don't generate a voice file from thin air without past posts AND without the fallback questions answered.
- Don't show the user the raw template files. They should see only conversational prompts and the final confirmation.
- Don't skip the "reflect back" step. The user needs to feel heard before the file is written.
