# Skills 技能管理仓库

> 基于 [npx skills](https://github.com/vercel-labs/skills) 的 Agent Skills 管理与 OpenCode 配置仓库。

## Skills CLI 命令

| Command | Description |
|---|---|
| `npx skills ls` | 列出项目级技能 |
| `npx skills ls -g` | 列出全局技能 |
| `npx skills ls -a opencode` | 列出 OpenCode 关联技能 |
| `npx skills find [query]` | 搜索技能（交互式或关键字） |
| `npx skills remove [skills]` | 移除已安装技能 |
| `npx skills update [skills]` | 更新技能到最新版本 |
| `npx skills init [name]` | 创建新的 SKILL.md 模板 |

## 目录结构

```
.
├── .agents/skills/               # 通用 Agent Skills（详见 docs/skills.md）
├── docs/                         # OpenCode 使用文档
│   ├── opencode-agents.md        # Agent 配置说明
│   ├── opencode-config.md        # OpenCode 配置指南
│   ├── opencode-providers.md     # 模型提供者配置
│   ├── opencode-rules.md         # 行为规则说明
│   └── skills.md                 # Skills 完整列表
├── opencode/commands/            # OpenCode 自定义命令
│   └── gitcommit                 # Git 提交命令
├── openclaw/                     # OpenClaw Agent 配置
│   └── .agents/skills/           # OpenClaw 专属技能
├── AGENTS.global.md              # 全局 Agent 角色与规则定义
├── config.global.json            # OpenCode 全局配置模板
├── config.sh                     # 一键部署配置脚本
├── fmtjson                       # JSON 格式化工具
├── skills-lock.json              # 项目技能版本锁定
└── README.md                     # 本文件
```

> 已安装 Skills 的完整列表参见 [docs/skills.md](./docs/skills.md)。

## 快速开始

### 1. 一键配置

```bash
./config.sh
```

将自动完成：
- 创建符号链接 `~/.config/opencode/skills -> .agents/skills`
- 复制 `AGENTS.global.md` 到 `~/.config/opencode/AGENTS.md`
- 部署全局配置文件 `config.global.json`

### 2. 管理技能

```bash
npx skills ls              # 查看项目技能
npx skills ls -g           # 查看全局技能
npx skills find golang     # 搜索可用技能
npx skills update golang-pro  # 更新指定技能
```

### 3. 查看 OpenCode 文档

```bash
ls docs/           # OpenCode 使用文档（agents / config / providers / rules / skills）
```

## 相关链接

- [OpenCode 官方文档](https://opencode.ai/docs)
- [Skills 生态系统](https://skills.sh/)
- [npx skills 工具](https://github.com/vercel-labs/skills)
- [AGENTS.global.md](./AGENTS.global.md) — Agent 角色详细定义

## 更新日志

- **2025-04-27**：新增 golang-naming、golang-popular-libraries、playwright-mcp、rust-best-practices、gitcommit 技能；文档移至 docs/；新增 openclaw/、config.sh、skills-lock.json
- **2025-02-07**：简化 README，突出仓库核心目的
- **2025-02-05**：初始版本，包含基础技能和 OpenCode 文档
