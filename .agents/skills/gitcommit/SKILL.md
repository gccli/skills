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
- Scope is optional. If the user provides a scope, use it. If not, infer the scope from changed files or repository history — do NOT ask the user for a scope.
- Preserve the user's staging intent.
- Never use broad staging commands: `git add .`, `git add -A`, `git commit -a`.
- Never add unstaged documentation files unless the user's intent explicitly mentions docs.

## Documentation Safety Rule

Treat these as documentation unless the user says otherwise:

- `docs/**`
- `README*`
- `CHANGELOG*`
- `*.md`
- `*.rst`
- `*.adoc`

If such files are modified but not staged AND the user has NOT mentioned docs/doc/documentation in their instruction, do not stage them automatically. Skip the confirmation step — simply exclude them and note in the report.

**Exception:** If the user explicitly said "docs", "doc", "documentation", "README", or named a doc file — treat that as implicit consent. Stage the docs without asking.

## Procedure

### Step 0: Classify complexity (decide fast vs normal path)

Run a single inspection:

```bash
git status --short && echo "---STAGED---" && git diff --staged --stat && echo "---UNSTAGED---" && git diff --stat
```

Classify based on this table:

| Condition                                                                   | Path            |
|-----------------------------------------------------------------------------|-----------------|
| 1 file changed, no staged files, clear intent                               | **Fast path**   |
| All changes belong to 1 Conventional Commit type, user provided scope/type  | **Fast path**   |
| Multiple unrelated change groups, ambiguous type, or both staged + unstaged | **Normal path** |
| User explicitly asks for review/confirmation                                | **Normal path** |

### Fast Path

When classification triggers fast path, skip the verification dance:

1. Read the diff with `git diff` to understand the change.
2. Generate the Conventional Commit message.
3. Stage the exact files with `git add <files>`.
4. Commit and report — do NOT pause for confirmation.

Fast path report format:
```text
🔖 <hash>  <type>(<scope>): <summary>
✅ <file> ...
```

### Normal Path

When classification triggers normal path:

1. **Check staged state** — if files are already staged, treat that as the intended boundary.
2. **Identify the dominant change type** from the diff — pick the smallest accurate type:
   - `feat` / `fix` / `refactor` / `test` / `docs` / `chore` / `build` / `ci` / `perf`
3. **Infer scope** — use user-provided scope if given; otherwise derive from changed file paths, module boundaries, or recent `git log --oneline -n 5` patterns. Do NOT ask the user for a scope.
4. **Present a one-shot proposal** (do NOT step-by-step interrogate):
   ```text
   提议提交:
   - 包含: <files>
   - 排除: <files + reason>

   消息: <type>(<scope>): <summary>

   确认提交? (yes/no/adjust)
   ```
5. **Ask once** — only when any of these are true:
    - Multiple unrelated change groups make splitting necessary.
    - The Conventional Commit type is truly ambiguous (e.g., mix of `feat` + `fix` in same area).
    - Lockfiles / generated files changed and intent is unclear.

If NONE of the above trigger, proceed to commit without asking. Scope is always inferred — never ask the user for it.

### Staging

Stage only the exact files the commit should include:

```bash
git add path/to/file1 path/to/file2
```

### Commit

```bash
git commit -m "type(scope): summary"
```

Report the hash and included files.

## Interaction Anti-Patterns

| Don't                                              | Do                                              |
|----------------------------------------------------|-------------------------------------------------|
| Always present a full analysis before committing   | Skip to commit for trivial cases                |
| Ask for confirmation on docs when user said "docs" | Honor user intent, include docs silently        |
| Interrogate step-by-step (scope → files → message) | Present one-shot proposal for normal path       |
| Run `git log` for every commit                     | Only fetch log when scope convention is unknown |
| Request diff, then status, then log separately     | Batch into minimal git calls                    |
