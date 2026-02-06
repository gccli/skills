# REFERENCE

https://github.com/awesome-opencode/awesome-opencode


## Config

https://opencode.ai/docs/config/

Remote config (from .well-known/opencode) - organizational defaults
Global config (`~/.config/opencode/opencode.json`) - user preferences
Project config (opencode.json in project) - project-specific settings

**NOTE** The `.opencode` and `~/.config/opencode` directories use plural names for subdirectories: `agents/`, `commands/`, `modes/`, `plugins/`, `skills/`, `tools/`, and `themes/`.


## Rules

https://opencode.ai/docs/rules/


Project `AGENTS.md` in your project root for project-specific rules. These only apply when you are working in this directory or its sub-directories.

Global `~/.config/opencode/AGENTS.md`


### Custom Instructions

```
"instructions": ["CONTRIBUTING.md", "docs/guidelines.md", ".cursor/rules/*.md"]
"instructions": ["https://raw.githubusercontent.com/my-org/shared-rules/main/style.md"]
```


## Agents

https://opencode.ai/docs/agents/

Agents are specialized AI assistants that can be configured for specific tasks and workflows. They allow you to create focused tools with custom prompts, models, and tool access.
智能体是专门的人工智能助手，可针对特定任务和工作流程进行配置。它们允许你创建具有自定义提示词、模型和工具访问权限的专用工具。


**Types**

* primary agents
* subagents


### Markdown

Define agents using markdown files. Place them in:

Global: `~/.config/opencode/agents/`
Per-project: `.opencode/agents/`


### Agent Options

* Temperature
* Max steps
* Disable
* Prompt
* Model
* Mode

### Use cases

* Build agent: Full development work with all tools enabled
* Plan agent: Analysis and planning without making changes
* Review agent: Code review with read-only access plus documentation tools
* Debug agent: Focused on investigation with bash and read tools enabled
* Docs agent: Documentation writing with file operations but no system commands


## Agent Skills

Project config: .opencode/skills/<name>/SKILL.md
Global config: ~/.config/opencode/skills/<name>/SKILL.md
Project Claude-compatible: .claude/skills/<name>/SKILL.md
Global Claude-compatible: ~/.claude/skills/<name>/SKILL.md
Project agent-compatible: .agents/skills/<name>/SKILL.md
Global agent-compatible: ~/.agents/skills/<name>/SKILL.md
