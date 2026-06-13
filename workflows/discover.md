# Workflow: Discover Inspiration

Pull fresh, real content from the web that an author could react to. Present a shortlist; picks go to the inspo inbox or straight to drafting. On-demand only — nothing runs in the background.

**Hard rules — never violate:**

1. **Never present an item without a real URL** that appeared in actual search/fetch results this run. No reconstructed links, no "probably at".
2. **Never summarize beyond what the source says.** The gist compresses; it never extrapolates.
3. **No drafting here.** Picking an item hands off to `workflows/create-post.md`.

Full guardrails: see "Don't" at the bottom.

## Input

Optional scope: a topic slug, an author slug, or a direction phrase. Nothing = broad sweep across all topics of all active authors.

## Step 1: Direction check

If the user's message already carries a direction ("inspo for tech", "something about agent pricing"), use it and skip the question.

Otherwise ask exactly one question:

> Any direction or angle in mind, or should I sweep broadly?

A nudge narrows the seeds. "Broad" / "blank" runs the full sweep. Never ask more than this one question.

## Step 2: Build search seeds

Run `bash scripts/setup.sh` first and use its `DATA_DIR` output as `$DATA`. All user files below live under `$DATA/` (the `_template`/`.example` files are in the skill folder — see SKILL.md § Where your files live).

1. Read `config/people.yaml` for active authors and their topics. Apply scope.
2. Read each in-scope topic file. Seeds per topic: the topic name, its "Key angles", its "Voices that inspire", plus the user's direction nudge if given.
3. Read `inspo/inbox.md` and `inspo/archive.md` if they exist. Collect all saved URLs — exclude them from this run's results. Run inbox hygiene (below) while you have the file open.

## Step 3: Search the web

Search each in-scope topic with 2-3 web searches. Run topics in parallel if your agent supports concurrent subagents; otherwise do them one at a time:

- a **recent-news** angle: what happened in this space in the last ~3 weeks
- a **thought-leadership** angle: essays and sharp takes, prioritizing the topic's "Voices that inspire"

Capture per item: title, URL, one-sentence gist, publish date if visible, source name. The `suggested:` author(s) come from the topic→author mapping in `config/people.yaml`, not from the search results.

## Step 4: Filter hard

- Recency ≤ ~3 weeks. Older only if it is clearly still the live conversation (say so in the gist).
- Don't present an inferred date as fact. If the publish date can't be confirmed from the page or search result, mark the item "date unconfirmed" and treat it skeptically against the recency window.
- Substantive over aggregator: essays, launch posts, research, primary sources, sharp takes. Skip SEO listicles and news-rewrite churn.
- Dedup by URL and by story. Same story from two sources → keep the best one, count it toward convergence.
- Cap: 10-12 items total per run. Fewer is fine. Never pad.

## Step 5: Flag convergence

2+ items on the same story or theme → group them under a popping header with one line on why it's converging:

> 🔥 Popping: outcome-based pricing (3 pieces this week — Sierra's pricing post set it off)

## Step 6: Present

Numbered list, popping groups first, then remaining items grouped by topic. Each item is exactly one line-block:

```
1. **[Title]** — [one-sentence gist]. [URL] · suggested: [author slug(s)]
```

End with exactly one line:

> Save, draft, or dig deeper: "save 2, 5" · "draft 3" · "more on [theme]"

## Step 7: Handle picks

Picks are combinable in one user line ("save 2, draft 5").

- **"save N, M"** → append each item to `inspo/inbox.md`, newest first, status `fresh`. If the file doesn't exist, bootstrap it from `inspo/inbox.example.md` minus the sample entry. Confirm in one line: "Saved 2 to the inbox."
- **"draft N"** → append to inbox (status `fresh`), then hand off to `workflows/create-post.md` with the item as the idea seed. One suggested author → draft for them; multiple → ask which. create-post marks it `used` at delivery.
- **"more on X"** → one focused second sweep on that theme only. Same rules, cap 5-6 items.

### Inbox entry format

```markdown
## [Title]
- link: [URL]
- gist: [one sentence]
- topics: [comma-separated topic slugs]
- suggested: [author slug(s)]
- saved: [YYYY-MM-DD]
- status: fresh
```

## Inbox hygiene

Run whenever any workflow opens `inspo/inbox.md` (discover, ideas, create-post all reference this section):

1. Any `fresh` item saved more than ~3 weeks ago → flip its `status` to `stale`.
2. If stale items exist, surface once per session, one line: "N items went stale — archive them?" On yes, move them to `inspo/archive.md` (same entry format, newest first). On no/silence, leave them.
3. If `inspo/archive.md` exceeds 50 entries, delete the oldest entries beyond 50. No prompt — archived content past the cap is gone.
4. Never delete from the inbox itself without asking. The user can revive a stale item by asking ("bring back the Sierra one").

## Don't

- Don't present an item without a real URL from this run's search results.
- Don't pad to hit the cap — 6 strong items beat 12 thin ones.
- Don't editorialize a gist beyond the source.
- Don't re-present items already in the inbox or archive.
- Don't draft posts here.
- Don't ask more than the one direction question (the inbox-hygiene archive prompt doesn't count).
- Don't offer next steps after picks are handled. Stop.
