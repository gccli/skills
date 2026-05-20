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
- Before `git commit`, run `git pull`.
- If `git pull` produces conflicts, resolve the conflicts first, verify the merged result, then continue to commit.
- After a successful commit, `git push` is allowed when needed.
- Never use `git push --force` or `git push -f`.

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

- Evaluate **all tracked file changes** together: staged files plus unstaged modifications to tracked files. **Never include untracked files.**
- If the tracked changes form one small logical set, stage any unstaged tracked files and commit the complete set.
- If there are multiple unrelated change groups, or staged/unstaged changes appear intentionally separated, use the staged set and ask once with one proposal.

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

Before committing, update the branch:

```bash
git pull
```

If `git pull` reports conflicts:

- Resolve the conflicted files.
- Recheck `git status`, `git diff`, and `git diff --cached`.
- Stage the resolved files explicitly.
- Continue only after the worktree is no longer conflicted.

Stage exact files only:

```bash
git add path/to/file1 path/to/file2
```

Commit:

```bash
git commit -m "type(scope): summary"
```

After a successful commit, push is allowed if the workflow requires publishing the branch:

```bash
git push
```

Do not use force push variants such as `git push --force` or `git push -f`.

## Output

```text
action: committed | pushed | need-confirmation
message: <type>(<scope>): <summary>
include: <files>
exclude: <files + reason>
hash: <commit hash if created>
recent:
<git log -n 3>
```

## Avoid

- Do not ask step-by-step questions.
- Do not ask for scope when it can be inferred or omitted.
