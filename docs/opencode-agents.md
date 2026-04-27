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
