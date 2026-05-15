# Harness Engineering 详解：从概念起源到行业实践

## 前言

随着 AI 编码智能体（Coding Agents）从“代码补全”向“自主任务执行”演进，开发者发现：模型能力的提升并未线性地带来生产级可靠性的增长。相反，智能体在执行复杂、长周期任务时频繁出现偏离预期、忽视架构约束、陷入无效循环等问题。这一瓶颈促使一批顶尖工程团队（HashiCorp、OpenAI、Anthropic、Red Hat 等）开始系统化地探索一种新的工程学科 —— **Harness Engineering（环境治理工程）**。

本文基于 Mitchell Hashimoto、OpenAI、Anthropic、Red Hat、Augment Code、Addy Osmani 等来源的公开资料，全面梳理 Harness Engineering 的由来、核心理论、各家实践观点，以及工程师角色的根本转变。

---

## 第一部分：Harness Engineering 的由来

### 1. 背景：AI 编程的三个阶段

根据 HashiCorp 创始人 Mitchell Hashimoto 的总结（[My AI Adoption Journey](https://mitchellh.com/writing/my-ai-adoption-journey)），工程师对 AI 编程工具的认知经历了三个阶段：

| 阶段 | 特征 | 瓶颈 |
|------|------|------|
| **阶段一：增强型补全** | 将 Copilot 视为高级自动补全，人类驱动全部逻辑 | 未能改变开发范式，效率提升有限 |
| **阶段二：初步尝试 Agent** | 让 Agent 独立完成小任务，例如写一个函数、修复一个 bug | Agent 频繁走偏、违反架构、产生难以审计的代码，**审计成本高于手写成本** |
| **阶段三：环境治理驱动** | 不再依赖模型自身的“智能”，而是为模型构建决定性的“支架”（Harness） | 生产力发生量级飞跃 |

Mitchell 直言：当他真正投入精力建设 Harness（约束、反馈、规则）后，开发速度才实现了质的突破。

### 2. 核心突破：棘轮效应（The Ratchet）

Mitchell 提出了一个极具启发性的原则：

> **不要把 AI 的失败看作偶然，要将其看作“环境缺陷”。**

每次智能体犯错，不要仅仅修改提示词或手动重试，而应该编写一个**程序化方案**来永久防止同类错误。例如：
- 增加一条 Linter 规则
- 更新 `AGENTS.md` 中的约束描述
- 添加一个 Git 提交前钩子（pre-commit hook）

这个过程像“棘轮”一样，每修复一个错误，环境的约束就收紧一格，使得智能体的可靠性**单向递增**。这是 Harness Engineering 最核心的运作机制。

更本质地说，这种"只进不退"机制的精髓在于一个关键动作：**把修复沉到环境里**。

所谓"沉"，是指修复不应该是漂浮在对话中的临时指令（"这次别这样做"），也不应该是工程师事后手动修补的一段代码——而是要让修复**沉积、固化、成为环境本身的一部分**，使得下次任何 Agent（甚至是不同的模型、不同的会话）遇到类似场景时，环境的约束已经预先在那里等着它。

具体而言，"沉到环境里"意味着：

- **沉到规则文件里**：在 `AGENTS.md` 或 `CLAUDE.md` 中新增一条明确禁止项。不是口头提醒，而是 Agent 每次启动都会自动读取并遵守的硬性条文。
- **沉到 Linter 里**：编写一条定制检查规则，让编译器或静态分析工具在 Agent 提交代码前自动拦截同类违规。从此，这个错误不再需要人类去发现——工具会替你发现。
- **沉到 Hook 里**：在 pre-commit 或 CI pipeline 中注入一个守卫脚本，让破坏性操作在进入仓库前就被机械性地挡住。
- **沉到测试里**：添加一条回归测试，确保该错误模式在未来任何变更中都无法复现。

"沉"的反面是"浮"——浮在提示词里、浮在对话记忆里、浮在工程师的脑子里。浮的修复有两个致命问题：一是**不可传递**（换个会话、换个模型就失效）；二是**不可累积**（每次遇到还得重新想起、重新说一遍）。而沉到环境里的修复，恰恰解决了这两点：它对所有 Agent 会话一视同仁，且随着时间推移不断堆叠、永不遗失。

> 每次 Agent 犯错，都是环境在向你暴露一个缺口。你的工作不是堵住这个缺口，而是把它**焊死**——让缺口本身从环境中消失，让未来的 Agent 连犯错的机会都不存在。

### 3. 定义的确立：Harness = 模型周围的“硬边界”

Mitchell 将 Harness 定义为包围模型的一系列确定性组件：
- **硬约束**：编译器、类型检查器、定制 Linter（而非在提示词中“请求”模型遵守规范）
- **反馈循环**：Agent 能够看到工具执行结果（成功时静默，失败时详细堆栈）
- **上下文即代码**：项目规则（命名规范、依赖约束）以文件形式入库，AI 主动读取，而非临时告知

至此，**“环境治理工程”** 作为一种独立的工程实践被正式确立。

### 4. OpenAI 的里程碑实验：百万行代码无人驾驶

2026 年 2 月，OpenAI 工程团队发布了《Harness engineering: leveraging Codex in an agent-first world》，报告中详细描述了一个极限实验：

- **时长**：5 个月（2025 年 8 月 – 2026 年 2 月）
- **团队规模**：3 名工程师
- **产出**：约 **100 万行** 生产代码，累计合并 **1500 个 PR**
- **人均效率**：每天产出 3.5 个 PR，开发速度预估为纯手工的 **10 倍**

最关键的规则是：

> **如果 Agent 任务失败，工程师严禁手动修复代码，必须通过改进 Harness 来解决问题。**

这个实验证明了：只要 Harness 设计得当，智能体可以在人类几乎不写代码的情况下，大规模、稳定地产出生产级软件。

### 5. 演进逻辑：从提示词工程到环境治理工程

#### 5.1 每一步都在上一层的天花板之后产生

回顾 AI 编程辅助的发展历程，可以清晰地看到一条“瓶颈驱动”的演进链：

- **提示词工程（Prompt Engineering）** 解决了“如何让模型理解单个任务”的问题。但当任务变复杂、需要多轮交互时，模型开始遗忘或混淆——**上下文信息不足**成为新瓶颈。
- **上下文工程（Context Engineering）** 通过 RAG、结构化上下文、记忆机制等，让模型能“看到”更多背景。但当智能体被赋予长期、高风险的自主执行能力时，人类发现：即使模型拥有全部上下文，它仍可能违反架构约束、产生不可维护的代码——**缺乏强制性的外部队束**成为新瓶颈。
- **环境治理工程（Harness Engineering）** 正是在这个节点上诞生的。它不是对前两者的否定，而是对前两者无法解决的问题的系统性回应。

> 每一次演进，都是因为上一阶段的成熟工具遇到了无法仅靠内部调整突破的天花板，从而倒逼工程师向外扩展边界——从模型内部的“询问”，到上下文“提供视野”，再到环境“施加规则”。

#### 5.2 三者关系：不是替代，而是包含与递进

提示词工程、上下文工程与环境治理工程**不是替代关系，而是一个逐层包含、难度递增的体系**：

| 层次 | 核心关注 | 包含关系 | 难度等级 |
|------|----------|----------|----------|
| **提示词工程** | 如何设计单次指令，使模型输出符合预期 | 基础层 | 低 |
| **上下文工程** | 如何组织、检索、注入背景信息，让模型理解全局 | 包含提示词 + 上下文管理 | 中 |
| **环境治理工程** | 如何设计智能体运行的所有外部约束、工具、反馈和沙箱 | 包含提示词 + 上下文 + 硬约束 + 闭环 | 高 |

> 比喻：  
> - **提示词工程** 像是写一份清晰的任务说明书。  
> - **上下文工程** 像是给执行者提供图书馆、地图和过往案例。  
> - **环境治理工程** 则是修建铁路、安装信号灯、设置自动刹车系统，并安排巡检员。

一个设计良好的 Harness 内部，必然包含精心编写的提示词和精心组织的上下文；但反过来，仅有提示词或上下文，远远无法保证智能体的可靠性。

#### 5.3 这一演进解释了各家观点的涌现

理解了上述递进关系，就能明白为什么在 2025–2026 年间，多家顶尖团队几乎同时提出 Harness Engineering 的相关概念：

- Mitchell Hashimoto 正是因为遇到“审计成本高于手写成本”的天花板，才转向 Harness。
- OpenAI 的“禁止手动修复”规则，本质上是强制团队越过提示词和上下文调试，直接进入 Harness 设计。
- Anthropic 强调的“上下文腐烂”与“生成器-评估器分离”，正是上下文工程和环境治理工程的交叉点。
- Red Hat 的两阶段工作流，将提示词、上下文、结构化规格与硬性审查点整合为一套企业级 Harness。

> 这些观点并非彼此冲突，而是从不同角度阐述了同一个事实：**当智能体进入生产环境，Harness 的设计质量决定了能力的上限。**

---

## 第二部分：Harness Engineering 各家观点

### 一、Mitchell Hashimoto（HashiCorp）—— 环境缺陷论与"只进不退"机制

**核心观点**：
- 智能体的可靠性问题本质是环境设计问题，而非模型能力问题。
- **"只进不退"机制**：将每一次错误转化为环境约束的收紧，且收紧后永不松开，使可靠性单向增长。
- 工程师的工作重心应从“写代码”转向“设计智能体运行环境”。

**具体实践**：
- 项目根目录放置 `AGENTS.md` 或 `CLAUDE.md`，描述项目结构、编码规范、禁止模式。
- 编写定制 Linter（例如禁止直接 `panic`，必须返回 `error`）。
- 要求 Agent 在执行前读取规则文件，并将 Linter 输出直接注入上下文以触发自我修复。

### 二、OpenAI —— 四大支柱与“禁止手动修复”

**核心理念**：
> “人类掌舵，智能体执行”。模型能力不是瓶颈，环境的**可读性**和**约束性**才是关键。

**四大支柱**：

1. **结构化上下文与渐进式披露**
   - `AGENTS.md` 保持在 100 行以内，作为“导航索引”。
   - 具体技能（Skills）按需加载，避免上下文污染。

2. **计划即首等公民**
   - 所有执行计划、决策日志、技术债跟踪都提交到 Git。
   - Agent 通过读取 `exec-plans/` 文件夹同步进度。

3. **机械化架构约束**
   - 不使用自然语言建议（如“请遵循分层架构”），而是通过自定义 Linter 强制拦截违规。
   - 不变性校验：只要硬约束足够强，Agent 在局部实现上拥有极高自由度。

4. **深度观测反馈循环**
   - 将 Chrome DevTools、LogQL、PromQL 直接接入 Agent 环境。
   - Agent 能自主启动应用、截图、分析日志、发现错误并回滚，形成 **Ralph Loop**（编写—运行—验证—修正）。

**工程师角色转变**：
- 从“代码作者”变为**环境架构师**。
- 从“审计员”变为**规格定义者**。

### 三、Anthropic —— 长期运行智能体的 Harness 设计

Anthropic 工程团队在 [Harness design for long-running apps](https://www.anthropic.com/engineering/harness-design-long-running-apps) 中指出：

**核心公式**：
> Agent = 模型 + 环境（Harness）

模型负责推理，Harness 负责状态管理、工具集、反馈循环、沙箱、子智能体编排。随着任务复杂度提升，Harness 的设计对成功率的影响 **远超模型本身**。

**关键问题与对策**：

1. **上下文腐烂（Context Rot）**
   - 长时间运行的任务中，上下文窗口会堆积无关信息，导致推理下降。
   - 对策：
     - **上下文重置**：阶段切换时，系统生成“任务简报”，启动全新干净上下文。
     - **上下文防火墙**：子智能体在隔离窗口内处理细节，只返回结构化结果，防止主链被污染。

2. **生成器-评估器分离**
   - 单一智能体评价自己的工作存在偏见（过于乐观）。
   - 引入独立的“评估智能体”，在代码合入前根据原始需求和架构约束进行交叉审核（类似 GANs）。

3. **决定性反馈循环**
   - 不要指望模型通过提示词“记住”规则，而是通过系统硬性控制。
   - 原则：**成功保持沉默，失败详尽描述**（包含修复建议）。

4. **规划与执行解耦**
   - 先输出“冲刺契约”（Sprint Contract），经人类或评估智能体确认后再执行。
   - Harness 需支持在执行中根据反馈动态修订计划。

### 四、Red Hat —— 企业级结构化工作流

Red Hat Developer 文章 [Harness engineering: Structured workflows for AI-assisted development](https://developers.redhat.com/articles/2026/04/07/harness-engineering-structured-workflows-ai-assisted-development) 强调：

**核心哲学**：
> AI 辅助开发的瓶颈不在模型，而在环境设计。自由格式的需求（Jira 任务）往往含糊不清，导致 AI 产生幻觉或不符合架构的代码。

**两阶段工作流**：

1. **分析与规划阶段**
   - AI 使用 LSP + MCP 扫描代码库，生成**仓库影响图**（受影响的文件路径、符号名称、现有模式）。
   - **人工审查点**：在写第一行代码前，人类确认 AI 的“理解”是否准确。

2. **结构化实现阶段**
   - 输入不再是模糊需求，而是**结构化规格**（明确的文件路径、需要仿照的代码模式、验收标准、测试要求）。

**技术设施**：
- **Repo 即真理**：将架构决策、代码规范直接写入仓库文件（如 `CLAUDE.md`），AI 自动感知。
- **LSP & MCP 深度集成**：符号级分析 + 实时数据接入（CI 状态、部署日志）。
- **Harness 即代码**：提示词模板、MCP 配置、Skills 均进行版本管理、代码评审和重构。

**企业价值**：
- 降低认知负荷（PR 审查时人类确认的是符号级影响图，而非逐行代码）。
- 可预测性（相同的文件/函数输入 → 相似的输出）。
- 缩短反馈路径（自动背压机制让 Agent 提交前自我修正）。

### 五、Augment Code —— 三层治理架构与 PEV 模式

Augment Code 的指南 [Harness Engineering for AI Coding Agents](https://www.augmentcode.com/guides/harness-engineering-ai-coding-agents) 给出了一套可落地的分层模型：

**定义**：
> Harness engineering 是一门通过设计环境、约束条件与反馈闭环，让 AI 编码智能体实现规模化稳定运行的专业学科。

**三层治理架构**（按 ROI 排序）：

| 层级 | 名称 | 作用 | 典型技术 |
|------|------|------|-----------|
| 第一层 | 约束层（预防） | 代码生成前缩小解空间 | Augment Rules（持久、自动注入、层级嵌套） |
| 第二层 | 反馈循环（修正） | 结构化错误信号，触发自我修复 | Linter 输出含具体建议（“请改用 logger.info”） |
| 第三层 | 质量关卡（强制执行） | CI 层级拦截不合规代码 | 安全、合规规则强制执行 |

**PEV 模式**：
- **Plan**：强制 Agent 将复杂目标分解为具体步骤和验收标准。
- **Execute**：在受控环境中执行，每一步触发 Harness 守卫。
- **Verify**：将实现与原始计划及外部质量标准进行全方位对齐验证。

**实践建议：高质量的 AGENTS.md**：
- 渐进式披露（主文件 100-150 行，细节推送到按需加载文件）
- 程序化工作流（编号步骤）
- 决策表（多方案选择）
- 真实代码示例（3-10 行生产代码片段）

### 六、Addy Osmani —— Agent = Model + Harness

Addy Osmani 的博客 [Agent Harness Engineering](https://addyosmani.com/blog/agent-harness-engineering/) 对上述观点进行了综合提炼：

**核心公式**：
> Agent = Model + Harness

一个拥有优秀 Harness 的中等模型，表现往往优于 Harness 糟糕的顶级模型。

**Harness 的组成层次**：
- 指令层：系统提示词、`CLAUDE.md`、`AGENTS.md`、技能文件
- 工具层：MCP 服务器、文件系统、Bash、浏览器
- 基础架构：沙箱、Git 版本控制
- 编排逻辑：子智能体分发、模型路由、任务规划
- 执行控制：Hooks（提交前检查、破坏性操作拦截）、Lint
- 观察层：日志、成本监控、延迟追踪

### 七、其他观点：Harness vs 提示词 vs 上下文

来自 [madplay.github.io](https://madplay.github.io/en/post/harness-engineering) 的总结清晰区分了三者：

| 工程类型 | 核心问题 | 比喻 |
|----------|----------|------|
| 提示词工程 | 应该问什么？ | 口令 |
| 上下文工程 | 应该看什么？ | 地图 |
| 环境治理工程 | 应该如何设计整个环境？ | 围栏 + 缰绳 + 道路 |

> 提示词告诉马“向右转”，上下文给马地图，而 Harness 则修筑围栏、铺设道路并套上缰绳，确保十匹马能同时安全奔跑。

---

## 第三部分：工程师角色的根本转变

综合所有来源，工程师的职责正在发生以下迁移：

| 传统角色 | Harness Engineering 下的新角色 |
|----------|-------------------------------|
| 编写具体的函数逻辑 | 设计智能体运行环境（约束、反馈、工具） |
| 手动修复 AI 产生的错误 | 将错误转化为不可逆的环境改进（只进不退） |
| 逐行审计 AI 生成的代码 | 定义验收标准与架构不变性，让 AI 自我验证 |
| 在对话中临时告知 AI 规则 | 将规则以代码形式入库（`AGENTS.md`、Linter 配置） |
| 关注模型选择和提示词调优 | 关注环境的可读性、约束强度、反馈闭环的完整性 |

> 正如 OpenAI 所言：“当代码变得廉价且可以海量生产时，工程师的核心产出不再是代码，而是**让 AI 无法犯错的世界**。”

---

## 第四部分：总结与展望

Harness Engineering 的兴起标志着 AI 编程从“模型中心”走向“环境中心”。它并非否定模型的重要性，而是承认：在生产环境中，模型的概率性必须被决定性的支架所约束。

未来，我们可以预见：
- 每个软件仓库都将包含一份 **Harness 清单**（约束、反馈、观测）。
- 工程师的招聘会从“熟练使用 Copilot”转向“能设计 Harness 架构”。
- Harness 本身将成为一种可复用、可交易的产品（如 Harness 模板市场）。

> 你不需要更强的模型，你需要一个更好的 Harness。

---

## 参考文献

1. Mitchell Hashimoto, *My AI Adoption Journey*, [https://mitchellh.com/writing/my-ai-adoption-journey](https://mitchellh.com/writing/my-ai-adoption-journey)
2. OpenAI, *Harness engineering: leveraging Codex in an agent-first world*, 2026
3. Anthropic, *Harness design for long-running apps*, [https://www.anthropic.com/engineering/harness-design-long-running-apps](https://www.anthropic.com/engineering/harness-design-long-running-apps)
4. Red Hat Developer, *Harness engineering: Structured workflows for AI-assisted development*, 2026
5. Augment Code, *Harness Engineering for AI Coding Agents: Constraints That Ship Reliable Code*
6. Addy Osmani, *Agent Harness Engineering*, [https://addyosmani.com/blog/agent-harness-engineering/](https://addyosmani.com/blog/agent-harness-engineering/)
7. madplay.github.io, *Harness Engineering*, [https://madplay.github.io/en/post/harness-engineering](https://madplay.github.io/en/post/harness-engineering)