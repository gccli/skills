# Agent Skills 使用指南

本文档介绍Agent Skills的原理、使用方法，以及在OpenCode中的配置和集成。

## 目录

- [Agent Skills 概述](#agent-skills-概述)
- [Skills CLI 使用指南](#skills-cli-使用指南)
- [已安装技能](#已安装技能)
- [OpenCode 集成](#opencode-集成)
- [创建自定义技能](#创建自定义技能)
- [最佳实践](#最佳实践)

---

## Agent Skills 概述

### 什么是 Agent Skills？

Agent Skills 是模块化的能力包，用于扩展AI助手的专业领域和工作流程。每个技能包含：

- **专业领域知识**：特定领域的最佳实践和模式
- **工作流程**：处理特定任务的步骤指南
- **工具和命令**：相关的命令行工具和操作
- **代码示例**：常见场景的实现参考

### Skills 生态系统

Skills 存储在开放的开源生态系统中，主要来源包括：

- **官方技能库**：https://skills.sh/
- **社区贡献**：来自各个公司和开发者的贡献
- **企业定制**：特定公司的专业技能

---

## Skills CLI 使用指南

### 安装和配置

Skills CLI 是一个npm包，提供技能管理功能：

```bash
# 全局安装
npm install -g @skills/cli

# 或者使用npx直接运行
npx skills [command]
```

### 核心命令

| 命令 | 描述 |
|------|------|
| `npx skills find [query]` | 搜索可用技能 |
| `npx skills add <package>` | 安装指定技能 |
| `npx skills list` | 列出已安装技能 |
| `npx skills check` | 检查技能更新 |
| `npx skills update` | 更新所有技能 |
| `npx skills remove <name>` | 移除技能 |
| `npx skills init <name>` | 创建新技能 |

### 搜索技能

```bash
# 基础搜索
npx skills find react

# 多关键词搜索
npx skills find testing jest

# 搜索特定类别
npx skills find pr review
```

搜索结果示例：

```
Install with npx skills add <owner/repo@skill>

vercel-labs/agent-skills@vercel-react-best-practices
└ https://skills.sh/vercel-labs/agent-skills/vercel-react-best-practices
```

### 安装技能

```bash
# 安装特定技能
npx skills add vercel-labs/agent-skills@vercel-react-best-practices

# 全局安装（推荐）
npx skills add <owner/repo@skill> -g

# 跳过确认提示
npx skills add <owner/repo@skill> -g -y
```

### 常用技能类别

| 类别 | 示例关键词 |
|------|----------|
| Web开发 | react, nextjs, typescript, tailwind |
| 测试 | jest, playwright, e2e, testing |
| DevOps | docker, kubernetes, ci-cd, deploy |
| 文档 | readme, changelog, api-docs |
| 代码质量 | lint, review, refactor |
| 设计 | ui, ux, accessibility |

---

## 已安装技能

### find-skills

**描述**：帮助用户发现和安装可用的Agent Skills。

**触发条件**：
- 用户询问"如何做X"
- 用户询问"有X的技能吗"
- 用户表达想要扩展能力的意愿

**使用方式**：
```bash
npx skills find [关键词]
```

**文档位置**：[`.opencode/skills/find-skills/SKILL.md`](.opencode/skills/find-skills/SKILL.md)

### systematic-debugging

**描述**：系统化调试方法论，用于处理bug、测试失败和异常行为。

**核心原则**：
- **铁律**：在进行任何修复之前，必须找到根本原因
- 禁止在未完成第一阶段调查前提出修复方案

**四阶段流程**：
1. **根本原因调查**：读取错误、重现问题、检查变更
2. **模式分析**：寻找类似案例、对比参考实现
3. **假设与测试**：形成假设、最小化测试验证
4. **实施修复**：创建测试用例、修复根因

**文档位置**：[`.opencode/skills/systematic-debugging/SKILL.md`](.opencode/skills/systematic-debugging/SKILL.md)

---

## OpenCode 集成

### 什么是 OpenCode？

OpenCode 是一个AI编程助手，通过集成的Skills系统来扩展其能力。它使用 `@opencode-ai/plugin` 包来实现与Skills生态系统的无缝对接。

### 配置结构

OpenCode 的技能配置位于 `.opencode/` 目录：

```
.opencode/
├── package.json          # 依赖配置
├── skills/              # 技能软链接目录
│   ├── find-skills -> ../../.agents/skills/find-skills
│   └── systematic-debugging -> ../../.agents/skills/systematic-debugging
└── node_modules/        # 依赖包
```

### 依赖配置

```json
{
  "dependencies": {
    "@opencode-ai/plugin": "1.1.51"
  }
}
```

### 在 OpenCode 中使用技能

#### 1. 自动技能激活

OpenCode 会根据任务上下文自动加载相关技能：

- 当检测到调试需求时 → 自动激活 `systematic-debugging`
- 当用户询问技能查找时 → 自动激活 `find-skills`

#### 2. 手动加载技能

你可以通过以下方式加载额外技能：

```bash
# 安装新技能
npx skills add <owner/repo@skill> -g

# 技能会自动被OpenCode识别
```

#### 3. 技能存储位置

全局安装的技能存储在用户目录：

```bash
# 技能默认安装位置
~/.skills/

# 或通过环境变量指定
SKILLS_DIR=/path/to/skills
```

### OpenCode 特定配置

#### 环境变量

| 变量 | 描述 | 默认值 |
|------|------|--------|
| `SKILLS_DIR` | 技能根目录 | `~/.skills` |
| `OPENCODE_SKILLS_PATH` | OpenCode专用技能路径 | `./.opencode/skills` |

#### 技能同步

确保OpenCode能够访问技能：

```bash
# 检查技能可访问性
npx skills list

# 更新所有技能以确保最新
npx skills update
```

### 技能与OpenCode的交互流程

```
用户请求
    ↓
OpenCode 分析请求意图
    ↓
识别需要的技能
    ↓
加载对应SKILL.md文件
    ↓
执行技能指导的流程
    ↓
返回结果给用户
```

---

## 创建自定义技能

### 技能结构

每个技能必须包含以下文件：

```
my-skill/
├── SKILL.md          # 技能主文档（必需）
├── README.md         # 详细说明
├── commands/         # 相关命令脚本
├── templates/       # 代码模板
└── CREATION-LOG.md  # 创建日志
```

### SKILL.md 格式

```yaml
---
name: my-skill        # 技能名称
description: 简短描述  # 1-2句话描述
---

# 技能标题

## 概述
技能的详细描述...

## 使用时机
何时应该使用此技能...

## 使用方法
逐步指导...
```

### 创建新技能

```bash
# 初始化新技能
npx skills init my-custom-skill

# 进入目录编辑
cd my-custom-skill

# 编辑 SKILL.md

# 本地测试
npx skills add ./my-custom-skill

# 发布到GitHub
git add .
git commit -m "Add my-custom-skill"
git push
```

### 发布技能

技能可以作为GitHub仓库发布：

1. 创建GitHub仓库
2. 推送技能代码
3. 用户通过 `npx skills add owner/repo@skill` 安装

---

## 最佳实践

### 技能选择

- **明确需求**：清晰描述你需要的功能
- **使用关键词**：搜索时使用具体的技术栈关键词
- **查看文档**：安装前先阅读 skills.sh 上的详细说明
- **关注更新**：定期运行 `npx skills update`

### 调试流程

1. **不要跳过根因分析**：即使问题看起来简单
2. **遵循四阶段流程**：调查 → 分析 → 假设 → 实施
3. **记录所有尝试**：便于回溯和分享经验

### 技能开发

1. **从现有技能学习**：参考 `find-skills` 和 `systematic-debugging` 的结构
2. **保持专注**：每个技能解决一类特定问题
3. **完善文档**：清晰的文档是技能可用的关键
4. **版本管理**：使用语义化版本号

### 性能优化

- **选择性安装**：只安装你需要的技能
- **定期清理**：移除不再使用的技能
- **监控更新**：关注技能的版本变化

---

## 常见问题

### Q: 技能安装失败怎么办？

```bash
# 检查网络连接
# 验证GitHub访问权限
# 尝试使用HTTPS而非SSH
npx skills add <repo> --protocol https
```

### Q: OpenCode 找不到已安装的技能？

```bash
# 检查技能路径
echo $SKILLS_DIR

# 重新扫描技能
npx skills check

# 确保全局安装
npx skills add <skill> -g
```

### Q: 如何回滚技能版本？

```bash
# 移除当前版本
npx skills remove <skill>

# 安装指定版本
npx skills add <owner/repo@version>
```

### Q: 技能之间有冲突怎么办？

每个技能是独立的，一般不会有冲突。如果有问题：

1. 逐一禁用技能排查
2. 查看技能文档是否有冲突说明
3. 向技能维护者报告

---

## 参考资源

- **Skills 官方市场**：https://skills.sh/
- **Skills CLI 文档**：运行 `npx skills --help`
- **OpenCode 插件**：`@opencode-ai/plugin`
- **社区技能仓库**：搜索 GitHub 上的 `agent-skills` 主题

---

## 更新日志

- 2025-02-05：初始文档版本
- 添加 find-skills 和 systematic-debugging 技能说明
- 完成 OpenCode 集成配置指南
