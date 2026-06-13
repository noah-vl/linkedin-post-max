# linkedin-post-max

**Post on LinkedIn in your own voice. Consistently, without sounding like an AI.**

linkedin-post-max learns how you actually write, then turns a rough idea into 2-3 publish-ready drafts that sound like you wrote them. It surfaces fresh things worth reacting to, gets sharper every time you post, and runs as many voices as you need (you, your company, your whole team).

Built for people who show up on LinkedIn regularly and can't afford to sound generic.

## Install

**Any agent (recommended).** Works with Claude Code, Cursor, Codex, Copilot, Gemini, and other Agent Skills–compatible tools. Installs into your agent's skills directory:

```bash
npx skills add noah-vl/linkedin-post-max
```

This skill keeps your personal data — voice profiles, learnings, the inspo inbox, your author registry — inside its own folder, so it persists between sessions.

**Manual (Claude Code).** Clone straight into your skills directory:

```bash
git clone https://github.com/noah-vl/linkedin-post-max.git \
  ~/.claude/skills/linkedin-post-max
```

Verify your agent can see it (Claude Code path shown; other agents use their own skills directory):

```bash
ls ~/.claude/skills/linkedin-post-max/SKILL.md
```

**Claude Code plugin.** For marketplace install:

```
/plugin marketplace add noah-vl/linkedin-post-max
/plugin install linkedin-post-max@noah-skills
```

Note: the plugin cache refreshes on update, which can overwrite personal content. For ongoing use, prefer `npx skills add` or a clone.

## What it does

Five workflows, one per job. The skill reads what you ask and routes to the right one. Nothing to memorize, no commands.

- **Draft a post** — Give it an idea, get 2-3 publish-ready variations in your voice. Vague idea? It coaches you through the angle and hook first, then writes. Your pick lands on the clipboard, ready to paste.
- **Brainstorm ideas** — 5-8 post ideas drawn from your topics and any inspiration you've saved, each with a hook and an angle so you can move straight to drafting.
- **Discover fresh angles** — An on-demand web sweep seeded by your topics. It flags what's popping, you pick what's worth reacting to, and it saves to your inspo inbox or goes straight into a draft.
- **Refine from a published post** — Paste a post you actually shipped. The skill reads it against your voice file and proposes precise updates.
- **Fold in what it learned** — Promote the patterns it has quietly picked up into your canonical voice file, with your sign-off on every change.

## Onboarding (about 5 minutes)

On the first run it walks you through setup: paste 3-5 of your past LinkedIn posts and it infers your tone, vocabulary, hooks, and rhythm into a voice file. Then it captures your topics (what you post about and why) and, optionally, any recurring formats you use. Runs once per author.

## How it gets sharper

Every draft teaches it something, three ways:

- **Passive** — when you tweak a draft ("shorter," "drop the close"), it silently logs the preference.
- **Active** — after delivery it asks one quick question: "what made you pick that one?" (skippable).
- **Post-back** — paste what you actually published and it reconciles your voice file against reality.

Learnings stay as soft hints until you say "fold in my learnings." Your canonical voice always wins on conflicts. Over time, drafts land closer to you on the first try.

## Customize

Everything is plain markdown you edit by hand any time. Change a file and the next draft reflects it. No rebuild, no restart.

- `voices/<name>.md` — tone, vocabulary, hooks, things you'd never say. The skill treats this as law.
- `topics/<name>.md` — what you post about, your point of view, your audience.
- `templates/<name>.md` — optional formats for recurring posts (hiring, launch, recap).
- `config/people.yaml` — your author registry.

## What's inside

```
linkedin-post-max/
├── SKILL.md           # Entry point + routing logic
├── onboarding.md      # Guided 5-min setup
├── config/
│   └── people.yaml    # Authors registry
├── voices/            # One file per author (tone, vocab, hooks, examples)
├── topics/            # One file per content domain (interests, message, audience)
├── templates/         # Optional. Recurring post formats (hiring, launch, etc.)
├── inspo/             # Shared inbox of saved content items to react to
└── workflows/
    ├── create-post.md         # Idea → publish-ready post (auto-routes between develop and direct draft)
    ├── ideas.md               # Generate post ideas from topics + saved inspo
    ├── discover.md            # On-demand web sweep → save fresh content to the inspo inbox
    ├── fold-in-learnings.md   # Promote captured learnings into the canonical voice file
    └── post-back.md           # Read a published post → propose voice file updates
```

## Multi-author

Runs any number of distinct voices from one install: you, your company account, your whole team. Each gets its own voice and learnings. Onboarding runs once per person.

## What it does NOT do

- **No background monitoring.** The discover flow runs on-demand web sweeps when you ask ("find me some inspo"), but nothing watches RSS, schedules collection, or tracks trends while you're away.
- **No scheduling.** Drafts are produced as text. You copy them into LinkedIn yourself.
- **No analytics.** No engagement tracking, no calendar, no metrics layer.

If you want those, pair this skill with separate tools. Keeping this one focused is the point.

## De-slop integration

Every draft passes through a de-slop step before output. The skill prefers the [`stop-slop`](https://github.com/anthropics/skills) skill if it's installed, and falls back to an inline checklist if not.

## License

MIT — see [LICENSE](LICENSE).
