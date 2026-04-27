---
name: gitcommit
description: 'Safely inspect, stage, and commit with Conventional Commits while respecting existing staging.'
argument-hint: 'Describe the commit goal or the files you want included'
user-invocable: true
---

# Git Commit

Use this skill for commit creation, commit-message generation, or safe staging decisions.

## Rules

- Inspect with git before deciding.
- Use Conventional Commits.
- Respect existing staging.
- Scope priority: user-provided > inferred from common path/module > omitted.
- Never use `git add .`, `git add -A`, or `git commit -a`.

## Procedure

### 1. Inspect

Run first:

```bash
git diff --cached --name-only
git diff --name-only
git status --short --branch
```

Run only if needed:

- `git diff --cached --stat`
- `git diff --stat`
- `git diff -- <files>`
- `git diff --cached -- <files>`
- `git log --oneline -n 5`

### 2. Boundary

- If staged files exist, use the staged set.
- If nothing is staged and the changed files are one small logical set, stage only those files.
- Otherwise, ask once with one proposal.

Ask once only if:

- There are multiple unrelated change groups.
- The type is still ambiguous after reading the relevant diff.
- Lockfiles or generated files changed and intent is unclear.

Ask format:

```text
proposal: <type>(<scope>): <summary>
include: <files>
exclude: <files + reason>
confirm: yes / no / adjust
```

### 3. Message

Type priority:

- `fix`: behavior correction
- `feat`: new capability
- `refactor`: non-behavioral code restructure
- `test`: tests only
- `docs`: docs only
- `perf`: performance improvement
- `build`: build or dependency tooling change
- `ci`: CI workflow change
- `chore`: everything else

Do not ask for scope if it can be inferred or omitted.

### 4. Execute

Stage exact files only:

```bash
git add path/to/file1 path/to/file2
```

Commit:

```bash
git commit -m "type(scope): summary"
```

## Output

```text
action: committed | need-confirmation
message: <type>(<scope>): <summary>
include: <files>
exclude: <files + reason>
hash: <commit hash if created>
```

## Avoid

- Do not ask step-by-step questions.
- Do not ask for scope when it can be inferred or omitted.
