# 收录 Skills 目录

本仓库收录和管理两类 Skills：**通用 Skills**（适用于大部分 Coding Agent）和 **OpenClaw Skills**（专用于 OpenClaw Agent）。

---

## 一、通用 Skills（`.agents/skills/`）

适用于大部分 Coding Agent 的通用技能，涵盖 Go/Rust 开发、调试、文档撰写、Git 提交等场景。

| Skill 名称 | 说明 | 来源 |
|-----------|------|------|
| **doc-coauthoring** | 文档协作工作流。引导用户通过结构化流程共同编写文档、提案、技术规范等。 | `anthropics/skills` |
| **gitcommit** | Git 提交助手。分析变更、生成 Conventional Commits 格式的提交信息，安全地暂存文件。 | 内置 |
| **golang-cli** | Go CLI 应用开发。涵盖命令结构、Flag 处理、配置分层、版本嵌入、退出码、I/O 模式、信号处理、Shell 补全、参数校验等。 | `samber/cc-skills-golang` |
| **golang-code-style** | Go 代码风格与规范。适用于代码编写、风格审查、Linter 配置、注释编写及项目标准制定。 | `samber/cc-skills-golang` |
| **golang-design-patterns** | Go 设计模式。函数式选项、构造函数、错误流、资源生命周期、优雅关闭、依赖注入、数据流处理等惯用模式。 | `samber/cc-skills-golang` |
| **golang-naming** | Go 命名规范。涵盖包、构造函数、结构体、接口、常量、枚举、错误、布尔值、接收器、Getter/Setter、缩写等命名约定。 | `samber/cc-skills-golang` |
| **golang-popular-libraries** | Go 流行库推荐。推荐经过验证的、生产级的 Golang 库和框架，优先标准库。 | `samber/cc-skills-golang` |
| **golang-pro** | 专业 Go 开发。并发编程（Goroutines/Channels）、微服务架构、gRPC 集成、泛型、性能优化（pprof）。 | `jeffallan/claude-skills` |
| **golang-testing** | Go 测试指南。表驱动测试、testify 套件、Mock、集成测试、基准测试、代码覆盖率、并行测试、Fuzzing、Goroutine 泄漏检测等。 | `samber/cc-skills-golang` |
| **playwright-mcp** | 浏览器自动化。基于 Playwright MCP 服务器，支持网页导航、元素点击、表单填写、数据提取、截图等。 | 内置 |
| **rust-best-practices** | Rust 最佳实践。基于 Apollo GraphQL 最佳实践手册，涵盖借用/克隆决策、错误处理、性能优化、测试编写等。 | `apollographql/skills` |
| **systematic-debugging** | 系统性调试方法论。遇到 Bug、测试失败或异常行为时，遵循结构化流程（根因调查 → 模式分析 → 假设验证 → 实施修复）。 | `obra/superpowers` |
| **technical-article-writer** | 技术文章写作。从选题打磨、标题/钩子生成、结构设计到正文撰写与编辑的全流程支持。 | `samber/cc-skills` |

---

## 二、OpenClaw Skills（`openclaw/.agents/skills/`）

专用于 OpenClaw Agent 的技能。

| Skill 名称 | 说明 | 来源 |
|-----------|------|------|
| **self-improving-agent** | 自进化 Agent。基于多记忆架构（语义 + 情景 + 工作），在每次 Skill 完成后自动触发自我修正和持续进化。 | `charon-fan/agent-playbook` |
| **summarize** | 内容摘要工具。对 URL、YouTube 视频、播客、文章、PDF 及本地文件进行快速摘要和转录。 | `steipete/clawdis` |

---

## 快速使用

在 Agent 会话中，系统会根据上下文自动加载对应的 Skill。你也可以在对话中显式提及 Skill 名称来触发：

- *"帮我写一篇技术方案文档"* → 触发 `doc-coauthoring`
- *"怎么排查这个 Bug？"* → 触发 `systematic-debugging`
- *"推荐一个 Go 的 Web 框架"* → 触发 `golang-popular-libraries`
- *"帮我提交代码"* → 触发 `gitcommit`
- *"帮我打开网页并截图"* → 触发 `playwright-mcp`

---

## 目录结构

```
.
├── .agents/
│   └── skills/                          # 通用 Skills
│       ├── doc-coauthoring/
│       ├── gitcommit/
│       ├── golang-cli/
│       ├── golang-code-style/
│       ├── golang-design-patterns/
│       ├── golang-naming/
│       ├── golang-popular-libraries/
│       ├── golang-pro/
│       ├── golang-testing/
│       ├── playwright-mcp/
│       ├── rust-best-practices/
│       ├── systematic-debugging/
│       └── technical-article-writer/
├── openclaw/
│   └── .agents/
│       └── skills/                      # OpenClaw Skills
│           ├── self-improving-agent/
│           └── summarize/
├── docs/
│   └── skills.md                        # 本文件
└── ...
```

---

## 安装 Skills

```
npx skills add https://github.com/samber/cc-skills-golang --skill golang-error-handling -y -a opencode
```

## 更新 Skills

使用 Skills CLI (`npx skills`) 可以检查并更新已安装的 Skills：

```bash
# 检查是否有可用的 Skill 更新
npx skills check

# 更新所有已安装的 Skills
npx skills update

# 安装新的 Skill（全局安装，跳过确认）
npx skills add <owner/repo@skill> -g -y
```
