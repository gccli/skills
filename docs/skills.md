# 收录 Skills 目录

本目录用于收录和管理 OpenCode Agent 的 Skills。每个 Skill 都是一组针对特定场景的专业化指令、工作流和知识库，旨在提升 Agent 在对应领域的表现。

---

## 已收录 Skills

| Skill 名称 | 说明 | 路径 |
|-----------|------|------|
| **doc-coauthoring** | 文档协作工作流。引导用户通过结构化流程（Context Gathering → Refinement & Structure → Reader Testing）共同编写文档、提案、技术规范等。 | `skills/doc-coauthoring/` |
| **find-skills** | Skill 发现与安装。帮助用户从开放生态中搜索、发现并安装新的 Agent Skills。 | `skills/find-skills/` |
| **golang-development** | Go 工程开发原则。包含不重复造轮子、推荐工具栈（Viper、Cobra、Fiber 等）、代码风格规范。 | `skills/golang-development.md` |
| **golang-pro** | 专业 Go 开发。适用于并发编程（Goroutines/Channels）、微服务架构、gRPC 集成、Go Generics 及高性能系统。 | `skills/golang-pro/` |
| **golang-popular-libraries** | Go 流行库推荐。为用户推荐经过验证的、生产级的 Golang 库和框架，优先标准库。 | `skills/.agents/skills/golang-popular-libraries/` |
| **playwright-mcp** | 浏览器自动化。基于 Playwright MCP 服务器，支持网页导航、元素点击、表单填写、数据提取、截图等操作。 | `skills/playwright-mcp/` |
| **summarize** | 内容摘要工具。使用 summarize CLI 对 URL、本地文件、PDF、图片、音频、YouTube 视频进行快速摘要。 | `skills/summarize/` |
| **systematic-debugging** | 系统性调试方法论。在遇到 Bug、测试失败或异常行为时，遵循四阶段流程（根因调查 → 模式分析 → 假设验证 → 实施修复），禁止盲目尝试修复。 | `skills/systematic-debugging/` |

---

## 快速使用

在 Agent 会话中，系统会根据上下文自动加载对应的 Skill。你也可以在对话中显式提及 Skill 名称来触发：

- *"帮我写一篇技术方案文档"* → 触发 `doc-coauthoring`
- *"怎么排查这个 Bug？"* → 触发 `systematic-debugging`
- *"推荐一个 Go 的 Web 框架"* → 触发 `golang-popular-libraries`
- *"帮我打开这个网页并截图"* → 触发 `playwright-mcp`

---

## 目录结构

```
.
├── README.md                          # 本文件
├── skills/
│   ├── doc-coauthoring/               # 文档协作
│   ├── find-skills/                   # Skill 发现
│   ├── golang-development.md          # Go 工程规范
│   ├── golang-pro/                    # Go 专业开发
│   ├── playwright-mcp/                # 浏览器自动化
│   ├── summarize/                     # 内容摘要
│   ├── systematic-debugging/          # 系统性调试
│   ├── .agents/skills/
│   │   └── golang-popular-libraries/  # Go 库推荐
│   └── skills-lock.json               # Skill 锁定记录
└── ...
```

---

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

> 更多命令请参考 `find-skills` Skill 或运行 `npx skills --help`。
