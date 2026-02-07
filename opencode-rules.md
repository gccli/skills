# REFERENCE

https://opencode.ai/docs/rules/

`AGENTS.md` file

## Types

* **Global**: `~/.config/opencode/AGENTS.md`

recommend using this to specify any personal rules that the LLM should follow
建议使用它来指定大语言模型应遵循的任何个人规则

* **Project**: Place an `AGENTS.md` in your project root for project-specific rules. These only apply when you are working in this directory or its sub-directories.

## Precedence

* Local files by traversing up from the current directory (`AGENTS.md`, `CLAUDE.md`)
* Global file at `~/.config/opencode/AGENTS.md`

## Custom Instructions

```
"instructions": ["CONTRIBUTING.md", "docs/guidelines.md", ".cursor/rules/*.md"]
"instructions": ["https://raw.githubusercontent.com/my-org/shared-rules/main/style.md"]
```


# Skills

https://opencode.ai/docs/skills/

### Place files

Project config: `.opencode/skills/<name>/SKILL.md`
Global config: `~/.config/opencode/skills/<name>/SKILL.md`
Project agent-compatible: `.agents/skills/<name>/SKILL.md`
Global agent-compatible: `~/.agents/skills/<name>/SKILL.md`

### Discovery

For project-local paths, OpenCode walks up from your current working directory until it reaches the git worktree. It loads any matching `skills/*/SKILL.md` in `.opencode/` and any matching `.claude/skills/*/SKILL.md` or `.agents/skills/*/SKILL.md` along the way.
对于项目本地路径，OpenCode 会从您当前的工作目录向上查找，直到到达 git 工作树。
