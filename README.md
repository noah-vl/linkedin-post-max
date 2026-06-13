# linkedin-post-max

**Write LinkedIn posts that sound like you, not a chatbot.**

Give it a rough idea and it writes a few versions in your own voice, ready to post. It learns how you write from posts you've already published, and it gets better the more you use it. When you're not sure what to write about, it can go find things worth weighing in on. Keep a separate voice for yourself, your company, or anyone on your team.

## Install

**Any agent (recommended).** Works with Claude Code, Cursor, Codex, Copilot, Gemini, and other Agent Skills–compatible tools. Installs into your agent's skills directory:

```bash
npx skills add noah-vl/linkedin-post-max
```

It keeps your own data (your voice profiles, what it has learned, your saved ideas, your list of authors) inside its own folder, so it stays put between sessions.

**Manual (Claude Code).** Clone straight into your skills directory:

```bash
git clone https://github.com/noah-vl/linkedin-post-max.git \
  ~/.claude/skills/linkedin-post-max
```

Check your agent can see it (Claude Code path shown; other agents use their own skills directory):

```bash
ls ~/.claude/skills/linkedin-post-max/SKILL.md
```

**Claude Code plugin.** For marketplace install:

```
/plugin marketplace add noah-vl/linkedin-post-max
/plugin install linkedin-post-max@noah-skills
```

Heads up: the plugin cache gets refreshed on update, which can wipe content you've created. For regular use, install with `npx skills add` or clone.

## What it does

Five jobs. Tell it what you want in plain language and it picks the right one.

- **Write a post.** Give it an idea and get two or three versions in your voice, ready to paste. If the idea is still vague, it asks a few questions to find the angle first, then writes.
- **Brainstorm ideas.** Get a handful of post ideas pulled from your topics and anything you've saved, each with a starting line so you can go straight to writing.
- **Find something to write about.** It searches the web around your topics and shows you what's getting attention. Pick what's worth a post and it saves it for later or starts a draft.
- **Learn from a post you published.** Paste something you actually posted. It reads it against your voice file and suggests small updates.
- **Save what it has learned.** Roll the things it has picked up into your main voice file, with your okay on each change.

## Setup (about 5 minutes)

The first time through, it walks you through setup. Paste three to five of your past LinkedIn posts and it works out your tone, the words you reach for, how you tend to open, and your rhythm, then saves that to a voice file. After that it asks what you post about and why, plus any post formats you reuse. You do this once per person.

## How it learns your voice

It picks things up three ways as you work:

- **As you edit.** When you ask for a change ("shorter," "drop the closing line"), it notes the preference.
- **After you pick a draft.** It asks one quick question: what made you choose that one? You can skip it.
- **From what you publish.** Paste a post you've put out and it checks your voice file against the real thing.

These stay as suggestions until you tell it to save them, and your main voice file always wins. Over time the first draft lands closer to how you'd write it yourself.

## Make it yours

Your content lives in its own folder, separate from the skill, so updates never overwrite it: `~/.linkedin-post-max/` (or `$CLAUDE_PLUGIN_DATA` if you're on a Claude Code plugin install). Everything in it is plain text you can edit by hand. Change a file and the next draft follows it. No rebuild, no restart.

- `voices/<name>.md` — your tone, the words you use, how you open, things you'd never say.
- `topics/<name>.md` — what you write about, your take on it, who you're writing for.
- `templates/<name>.md` — optional formats for posts you write often (hiring, launch, recap).
- `config/people.yaml` — the list of authors.

## What's inside

The skill folder is the program (safe to update or reinstall):

```
linkedin-post-max/
├── SKILL.md                    # Entry point: reads what you want, picks the right step
├── onboarding.md               # First-time setup (about 5 min)
├── scripts/setup.sh            # Prepares your data folder; runs at the start of a session
├── config/people.example.yaml  # Starter registry, copied to your data folder on first run
├── voices/_template.md         # Templates the skill fills in (topics/ and templates/ too)
├── inspo/inbox.example.md      # Shows the saved-item format
└── workflows/
    ├── create-post.md          # Idea to finished post
    ├── ideas.md                # Suggest things to write about
    ├── discover.md             # Search the web for things worth a post
    ├── fold-in-learnings.md    # Save what it learned into your voice file
    └── post-back.md            # Learn from a post you published
```

Your content lives separately, in `~/.linkedin-post-max/`, where updates never reach it:

```
~/.linkedin-post-max/
├── config/people.yaml   # Your list of authors
├── voices/              # One file per person: tone, words, openings, examples
├── topics/              # One file per subject: what you write about and who for
├── templates/           # Optional formats for posts you write often
└── inspo/               # Things you've saved to write about later
```

## Multiple voices

Run as many voices as you want from one install: yourself, your company account, your whole team. Each keeps its own voice and its own notes. Setup runs once per person.

## What it doesn't do

- **It doesn't watch the web for you.** It only goes looking when you ask. Nothing runs in the background.
- **It doesn't post for you.** You get the text and paste it into LinkedIn yourself.
- **It doesn't track numbers.** No follower counts, no analytics, no calendar.

## Cleaning up AI tells

Every draft gets a pass to strip the patterns that make writing read as AI-written. It uses the stop-slop skill if your agent has one, and a built-in checklist if not.

## License

MIT — see [LICENSE](LICENSE).
