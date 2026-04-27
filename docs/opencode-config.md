# REFERENCE

https://github.com/awesome-opencode/awesome-opencode


## Config

https://opencode.ai/docs/config/

Remote config (from .well-known/opencode) - organizational defaults
Global config (`~/.config/opencode/opencode.json`) - user preferences
Project config (opencode.json in project) - project-specific settings

**NOTE** The `.opencode` and `~/.config/opencode` directories use plural names for subdirectories: `agents/`, `commands/`, `modes/`, `plugins/`, `skills/`, `tools/`, and `themes/`.



You can configure server settings for the `opencode serve` and `opencode web` commands through the server option.


```
opencode serve --hostname 0.0.0.0 --port 8180
```
