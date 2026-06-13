# linkedin-post-max

A Claude Code skill that writes LinkedIn posts in your actual voice.

You paste 3-5 of your past posts. The skill captures your tone, vocabulary, hooks, and rhythm into a `voices/` file. From then on, you give it an idea, it gives you 2-3 publish-ready drafts that sound like you — not like an AI tool.

On-demand discovery, not background monitoring. No analytics. No scheduling. Just voice-aware drafting.

## Install

**Recommended: clone into your skills directory.** This skill stores your personal data — voice profiles, learnings, the inspo inbox, your author registry — inside its own folder. Cloning makes that folder yours, so the data persists and updates are a deliberate `git pull`.

```bash
git clone https://github.com/noah-vl/linkedin-post-max.git \
  ~/.claude/skills/linkedin-post-max
```

Verify Claude can see it:

```bash
ls ~/.claude/skills/linkedin-post-max/SKILL.md
```

That's it. The skill is auto-discovered.

### Or install as a plugin (to try it)

```
/plugin marketplace add noah-vl/linkedin-post-max
/plugin install linkedin-post-max@noah-skills
```

Good for kicking the tires. Note: plugins live in a managed cache that refreshes on update, so personal content you create (voices, inbox) can be overwritten. For ongoing personal use, clone instead.

## Start

In any Claude Code session, say something like:

- "Help me write a LinkedIn post"
- "Draft a hiring post for my company account"
- "Brainstorm some LinkedIn ideas"
- "Find me some inspo" / "What's popping in tech?"

The skill detects intent and routes:

- **First time?** → Runs `onboarding.md`. ~5 minutes. Asks for past posts, infers your voice, captures your topics.
- **Drafting?** → Runs `workflows/create-post.md`. Idea → 2-3 publish-ready variations. Auto-develops vague ideas through a coaching dialogue first.
- **Brainstorming?** → Runs `workflows/ideas.md`. Generates 5-8 ideas from your topics and any fresh inspo you've saved.
- **Looking for inspiration?** → Runs `workflows/discover.md`. On-demand web sweep seeded by your topics; pick what's worth reacting to and it lands in your inspo inbox or goes straight to drafting.

## How it learns over time

As you use the skill, it captures signal across three triggers:

- **Passive** — when you iterate on a draft ("shorter," "drop the close"), the skill silently logs it to your author's learnings file.
- **Active** — after clipboard delivery, the skill asks one short question: "what made you pick that one?" (skippable).
- **Post-back** — paste your actually-published LinkedIn post back in ("post-back for <author>: ..."), and the skill reads it against your voice file.

The learnings file is read live during every draft as soft hints — the canonical voice always wins on conflicts. When you're ready, say "fold in <author>'s learnings" and the skill proposes specific voice-file edits for you to approve.

Voice grows sharper. Drafts get closer to you.

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

Voices, topics, and templates are plain markdown. Edit them by hand any time. The skill reads them on every run.

## Multi-author

The skill supports multiple authors out of the box. A team can use one shared install where each person has their own voice file. The onboarding flow runs once per author.

## What this skill does NOT do

- **No background monitoring.** The `discover` flow runs on-demand web sweeps when you ask ("find me some inspo"), but nothing watches RSS, schedules collection, or tracks trends while you're away.
- **No scheduling.** Drafts are produced as text. You copy them into LinkedIn yourself.
- **No analytics.** No engagement tracking, no calendar, no metrics layer.

If you want those, pair this skill with separate tools. Keeping this one focused is the point.

## De-slop integration

Every draft passes through a de-slop step before output. The skill prefers the [`stop-slop`](https://github.com/anthropics/skills) skill if it's installed, and falls back to an inline checklist if not.

## Sharing

This skill ships with empty `voices/`, `topics/`, and `templates/` directories — no personal content baked in. Fork and personalize freely. To share back, contribute templates or improvements via PR.

## License

MIT — see [LICENSE](LICENSE).
