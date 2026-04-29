# AGENTS.md — Golang Application Development

## 1. 代码风格规则

### 1.1 禁止重复造轮子 (No Reinventing the Wheel)
- **标准库优先**: 能用 `encoding/json`、`net/http`、`strings` 等标准库完成的，严禁手写替代或引入第三方库。
- **强制使用已配置技能库**:
  - 集合/切片/映射操作 → `github.com/samber/lo` (`golang-samber-lo`)
  - 配置解析、日志、HTTP 路由等 → `golang-popular-libraries` / `golang-cli`
- **DRY**: 重复代码必须提取为公共函数/接口，禁止复制粘贴。
- **模式复用**: 遵循 `golang-design-patterns` 的选项模式（Functional Options）、工厂模式等标准做法。

### 1.2 地道与简洁
- 遵循 `Effective Go` 与 `golang-code-style`。
- 命名遵循 `golang-naming`（MixedCaps，避免蛇形命名）。
- 避免滥用 `reflect` 和 `interface{}`，除非用于泛型约束或序列化。

---

## 2. 安全基线规则

### 2.1 输入验证与数据安全
- **零信任**: 所有外部输入必须校验（长度、范围、类型、正则）。
- **防注入**: 禁止字符串拼接 SQL，必须参数化查询；禁止将用户输入拼接到 shell 命令。
- **反序列化**: 使用 `json.Decoder` 时启用 `DisallowUnknownFields`，限制读取上限防 DoS。

### 2.2 敏感信息保护
- **禁止硬编码**: 源码、注释、测试、配置模板中严禁出现密码、API Key、Token、私钥。
- **安全注入**: 通过环境变量、密钥文件或 KMS/Vault 在运行时注入。

### 2.3 并发与运行时安全
- **防数据竞争**: 共享可变状态必须通过 `sync.Mutex`、`sync/atomic` 或 Channel 保护；优先使用 `go vet -race` 检测。
- **资源释放**: 文件句柄、连接、事务必须通过 `defer` 或显式调用释放。

### 2.4 依赖安全
- **可信来源**: 引入依赖前检查 Stars、Issue 活跃度及 CVE；优先使用 `golang-popular-libraries` 推荐库。
- **最小化依赖**: 不为单一小功能引入庞大库，优先考虑标准库或子模块。


---

## 4. 技能关联速查

| 场景 | 技能 |
| :--- | :--- |
| 代码风格/命名 | `golang-code-style`, `golang-naming` |
| 数据结构/工具库 | `golang-data-structures`, `golang-samber-lo` |
| 并发/性能 | `golang-concurrency`, `golang-pro` |
| 错误处理 | `golang-error-handling` |
| 类型/接口设计 | `golang-structs-interfaces`, `golang-design-patterns` |
| 测试/质量 | `golang-testing`, `golang-stretchr-testify` |
| 诊断/调试 | `golang-troubleshooting` |
| 运行时安全 | `golang-safety` |
| 领域开发 | `golang-grpc`, `golang-cli`, `golang-popular-libraries` |
