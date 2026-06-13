# linkedin-post-max — Domain Glossary

Defines the terms used across this skill. Defined here once; not redefined elsewhere. When a workflow references a term, it means *this* specific thing.

## Storage

**Data directory** (`$DATA`)
Where all user content lives, **outside** the skill folder, so updates never overwrite it. Resolved by `scripts/setup.sh`: `$CLAUDE_PLUGIN_DATA` when set (Claude Code plugin installs), otherwise `~/.linkedin-post-max`. Holds `config/people.yaml`, `voices/`, `topics/`, `templates/`, and `inspo/`. Every such path in this skill is under `$DATA/`; only the shipped `_template.md` and `.example.*` files live in the skill folder. _Avoid:_ skill folder, install dir.

## Authors

**Author**
A person (or company account) the skill writes posts in the voice of. Identified by a `slug`.

**Slug**
A short lowercase identifier for an author, typically their first name (e.g. `alex`). Used as:
- The key under `people:` in `config/people.yaml`
- The basename of the voice file: `voices/<slug>.md`
- The basename of the learnings file: `voices/<slug>-learnings.md`

_Avoid:_ username, id, handle.

## Voice

**Voice file** (canonical)
`voices/<slug>.md`. Hand-editable markdown. The author's tone, vocabulary, hooks, things-they'd-never-say. The skill treats this as **law** when drafting. Updated only through explicit channels: active 1-line check, post-back, or fold-in (each surfaces proposed edits for user approval).

**Learnings file** (soft hints)
`voices/<slug>-learnings.md`. Append-only log of observations from drafting sessions. Read live during drafts as soft hints. **Never** overrides the canonical voice file. Created automatically on the first passive capture; archived (not deleted) on fold-in.

_Avoid:_ scratchpad, observations log, sidecar.

**Canonical wins**
The rule that on any conflict between canonical voice and learnings, canonical always wins. Learnings only become binding after fold-in promotes them into the voice file.

**Soft hint**
A single entry in the learnings file. Influences drafts but never overrides canonical. Tagged with confidence: `low` (first observation), `medium` (2-3 corroborating), `high` (4+).

## Capture triggers

**Passive capture**
Silent append to the learnings file when the user iterates during a draft (e.g., says "shorter", "drop the close"). No user prompt. The model interprets the iteration as a voice-rule hint and writes a dated entry. The user never sees this happen.

**Active 1-line check**
A skippable post-clipboard question — *"what made you pick #N?"* — fired after every successful clipboard delivery in `workflows/create-post.md`. On a substantive answer (one that references hook / structure / vocabulary / tone / length / close / anchor / voice), the skill proposes specific edits directly to the canonical voice file. On `skip`, no capture, and no re-asking in the same session.

**Post-back**
User pastes their actually-published LinkedIn post. The skill reads it against the voice file, identifies patterns and deviations, and proposes additions (new example post, pattern observations). Operates on the published version alone — **never** compared to a stored draft.

## Drafting paths

**Direct draft**
The routing path in `workflows/create-post.md` taken when the user's idea has both a specific entity and a clear take. Goes straight to writing 2-3 variations.

**Develop-idea**
The routing path taken when the idea is vague. Adaptive coach loop. Asks one focused question at a time and actively proposes (angles, hooks, counter-angles) when the user hasn't filled in the blank. Terminates decisively when angle and anchor are clear. Hard cap: 4 user turns.

**Angle**
The specific take the user wants to make in a post — not the topic. "Hiring" is a topic; "we killed our JDs and replaced them with taste docs" is an angle.

**Anchor**
A concrete real thing the post stands on: a number, a person, a specific moment, a specific observation. Posts without an anchor feel generic.

## Promotion

**Fold-in**
User-invoked workflow (`workflows/fold-in-learnings.md`) that promotes learnings to the canonical voice file. Reads the learnings file, groups entries by voice-file section, proposes specific markdown edits, applies approved ones, archives the active log (rename with date suffix). Never auto-runs.

_Avoid:_ promote, merge, sync, commit.

## Source trace

**Source trace comment**
A markdown comment appended after a canonical rule that records its origin — e.g. `<!-- Added 2026-05-21 from active check: 'hook felt more like me'. -->`. Used by active-check edits and (in proposal evidence) by fold-in. Lets the user trace any canonical rule back to the moment it landed.

## Inspo

**Discovery run**
One on-demand execution of `workflows/discover.md`: seed searches from topic files, fan out web searches, filter hard, present a shortlist. Starts with at most one direction question.

**Inspo item**
One piece of external content saved to the inbox: title, link, gist, topics, suggested author(s), saved date, status.

**Inbox**
`inspo/inbox.md`. Single shared pool of inspo items across all authors. Newest first. Gitignored (personal data, like `people.yaml`).

**Status**
Lifecycle of an inspo item: `fresh` (saved, available) → `used` (a post was drafted from it; set by create-post at delivery) or `stale` (~3 weeks old, auto-flagged). Stale items move to `inspo/archive.md` only with user consent.

**Archive cap**
`inspo/archive.md` holds at most 50 entries. Past the cap, the oldest are deleted outright, no prompt.

**Popping**
2+ items in one discovery run hitting the same story or theme. Grouped under a flagged header with one line on why it's converging.

**Anchored idea**
An idea in `workflows/ideas.md` that reacts to a real inbox item and cites its title + link. The only legitimate source of timeliness in ideas.

**Evergreen idea**
An idea generated from durable topic angles alone. Makes no timely claims.

_Avoid:_ feed, queue, backlog, bookmarks.

## Relationships

- An **author** has one **voice file** and (after the first iteration) one **learnings file**.
- The **voice file** is canonical law; the **learnings file** holds **soft hints** until **fold-in**.
- **Passive capture** writes to learnings. **Active 1-line check** and **post-back** propose edits directly to voice (with explicit user approval at each step).
- **Fold-in** promotes learnings → voice, then archives the learnings file.
- During drafting, the model reads BOTH files — canonical wins on conflicts; high-confidence soft hints carry more weight than low-confidence ones.
- **Discover** fills the **inbox**. **Ideas** turns eligible fresh items into **anchored ideas**. **Create-post** fetches an item's source before drafting and marks the item **used** at delivery.
- Timeliness lives only in the **inbox** (dated, lifecycled). Topic files are durable and carry no "what's hot" content.

## Flagged ambiguities

- "scratchpad" was previously used to mean the learnings file in design discussion — resolved: the official term is **learnings file**.
- "tune" appears in some UI text ("tune <author>'s voice") and refers to manually editing the voice file by hand — distinct from **fold-in**, which is a structured workflow.
