# OpenCode 技能仓库

本仓库用于整理 OpenCode 使用文档和收集 Agent Skills。

## 仓库目的

- **整理 OpenCode 使用文档**：提供 OpenCode 相关配置、规则和最佳实践
- **收集 Agent Skills**：存储和管理用于扩展 AI 助手能力的专业技能

## 目录结构

```
.
├── .agents/                    # Agent Skills 存储目录
│   └── skills/                # 技能实现
│       ├── golang-pro/        # Golang 专业开发技能
│       ├── doc-coauthoring/   # 文档协同创作技能
│       ├── find-skills/       # 技能发现与安装技能
│       └── systematic-debugging/ # 系统化调试技能
├── AGENTS.global.md           # 全局 Agent 配置说明
├── opencode.md               # OpenCode 基本使用指南
├── opencode-rules.md         # OpenCode 行为规则
├── opencode-providers.md     # OpenCode 提供者配置
└── config.global.json        # 全局配置文件
```

## 包含的 Agent Skills

### 已安装技能

| 技能名称 | 描述 | 触发条件 |
|---------|------|----------|
| **golang-pro** | Golang 专业开发技能，适用于并发编程、微服务架构 | 涉及 Go 代码编写、重构或架构设计时 |
| **doc-coauthoring** | 文档协同创作技能，用于结构化文档编写流程 | 用户需要编写文档、提案、技术规范时 |
| **find-skills** | 技能发现与安装技能 | 用户询问如何查找或安装技能时 |
| **systematic-debugging** | 系统化调试方法论 | 遇到 bug、测试失败或异常行为时 |

## 快速开始

### 1. 查看 OpenCode 文档

```bash
# 查看基本使用指南
cat opencode.md

# 查看行为规则
cat opencode-rules.md
```

### 2. 使用 Agent Skills

Skills 在 OpenCode 中会根据任务上下文自动激活，无需手动干预。

### 3. 技能存储位置

技能存储在 `.agents/skills/` 目录中，每个技能包含完整的文档和工作流程。

## 相关文档

- [OpenCode 官方文档](https://opencode.ai/docs)
- [Skills 生态系统](https://skills.sh/)
- [AGENTS.global.md](./AGENTS.global.md) - 详细的 Agent 配置说明

## 更新日志

- **2025-02-07**：简化 README，突出仓库核心目的
- **2025-02-05**：初始版本，包含多个技能和 OpenCode 文档
