---
name: gitcommit
description: 'Use when the user wants to commit code, create a git commit, generate a conventional commit message, summarize repository changes, or stage a safe commit set. Analyze changes with git first, follow Conventional Commits, preserve the user''s staging intent, ask before including uncertain files or hunks, and never add unstaged documentation files without explicit user confirmation.'
argument-hint: 'Describe the commit goal or the files you want included'
user-invocable: true
---

# Git Commit

Use this skill when the user asks to submit code, create a commit, prepare a commit message, or summarize current repository changes into a clean commit.

## Core Rules

- Always inspect the repository with git before deciding what to commit.
- Always use Conventional Commits.
- Preserve the user's staging intent.
- If the commit scope, file set, or commit type is not clear enough, ask the user before committing.
- Never use broad staging commands such as `git add .`, `git add -A`, `git commit -a`, or any command that may sweep unrelated changes into the commit.
- Never add unstaged documentation files without explicit user confirmation.

## Documentation Safety Rule

Treat these as documentation unless the user says otherwise:

- `docs/**`
- `README*`
- `CHANGELOG*`
- `*.md`
- `*.rst`
- `*.adoc`

If any such file is modified but not already staged, do not stage it automatically. If including it seems necessary for the commit, stop and ask the user.

## Procedure

### 1. Inspect the repository state

Start with git analysis instead of guessing:

```bash
git status --short
git diff --staged --stat
git diff --stat
git log --oneline -n 10
```

Use the results to answer four questions:

1. What is already staged?
2. What is changed but unstaged?
3. Are there unrelated or mixed-purpose changes?
4. What commit message style and scope naming does this repository already use?

### 2. Decide the commit boundary conservatively

Apply these rules in order:

1. If the user already staged files, assume that staged set is the intended commit boundary.
2. Do not automatically pull in additional unstaged files unless the intent is clear and they are directly required.
3. If changes appear mixed across features, fixes, refactors, docs, or generated files, ask the user to confirm the desired commit scope.
4. If documentation files are unstaged, do not add them without asking.

### 3. Build a commit summary

Before committing, summarize the commit content from git evidence:

- Primary purpose of the change
- Main files or areas affected
- User-visible behavior or technical outcome
- Whether docs or tests are included

Keep the summary tight and factual. Do not invent intent that is not supported by the diff.

### 4. Choose a Conventional Commit message

Pick the smallest accurate type, for example:

- `feat`: new user-facing behavior
- `fix`: bug fix or behavior correction
- `refactor`: internal code change without behavior change
- `test`: tests only
- `docs`: documentation only
- `chore`: maintenance work
- `build`: build or dependency tooling changes
- `ci`: CI pipeline changes
- `perf`: performance improvement

Message format:

```text
type(scope): concise summary
```

Guidelines:

- Match existing repository conventions for scope naming when visible in recent commits.
- Keep the subject line concise and specific.
- Use an optional body only when it adds real value.
- If type or scope is ambiguous, ask the user instead of guessing.

### 5. Stage safely when needed

If staging is required, stage only the exact files the commit should include.

Allowed pattern:

```bash
git add path/to/file1 path/to/file2
```

Disallowed patterns:

```bash
git add .
git add -A
git commit -a
```

If partial staging is needed and the correct hunk set is uncertain, ask the user before proceeding.

### 6. Ask the user when confidence is insufficient

Stop and confirm with the user when any of the following is true:

- There are multiple unrelated change groups.
- The proper Conventional Commit type is unclear.
- The scope is unclear.
- Documentation files are modified but unstaged and seem necessary.
- Generated files or lockfiles changed and it is unclear whether they belong in the commit.
- The repo contains both staged and unstaged edits and the intended boundary is uncertain.

### 7. Commit and report back

After the boundary and message are clear:

```bash
git commit -m "type(scope): summary"
```

Then report back with:

- The final commit message
- The short commit hash
- A brief summary of what was included
- Any intentionally excluded files

## Preferred Interaction Pattern

When helping with a commit, communicate in this order:

1. Analyze git status and diffs.
2. Summarize the proposed commit contents.
3. Present the Conventional Commit message.
4. Call out anything excluded, especially unstaged docs.
5. Ask the user only about the uncertain parts.
6. Commit once the boundary is clear.

## Example Response Shape

```text
Proposed commit scope:
- include: cmd/aiasset/scanner.go, cmd/aiasset/report.go
- exclude: docs/subcommand-internals.md (modified but unstaged documentation)

Suggested commit message:
fix(aiasset): handle report generation failures consistently

I did not stage the documentation file because it is not already staged. If you want it included, confirm and I will add it explicitly.
```