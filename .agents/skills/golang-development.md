## Engineering Principles

### 1. No Reinventing the Wheel (不要造轮子)

* **优先使用 Go Modules:** 除非是核心业务逻辑或极度轻量的工具函数，否则严禁手动实现已存在成熟生态的任务（如 JWT 处理、日志、配置解析、验证器等）。
* **选型标准:** 优先选择 CNCF 托管项目、大厂开源维护项目（如 Google, Uber, HashiCorp）或 GitHub Stars 高且维护活跃的库。
* **依赖控制:** 在引入第三方包时，需评估其依赖树深度，避免引入过于臃肿或存在供应链安全风险的包。

### 2. Standard Stack Recommendations (推荐工具栈)

在编写 Go 代码时，默认推荐以下成熟轮子：

- **Error handle and propagate:** `github.com/pkg/errors`, e.g. `errors.Wrap`, `errors.Errorf`
- **Config:** `github.com/spf13/viper`
- **Managing groups of goroutines:** `golang.org/x/sync/errgroup` for managing groups of goroutines with error handling, context cancellation, and optional concurrency limiting.
- **Logging:** `github.com/sirupsen/logrus` for logging.
- **CLI applications:** `github.com/spf13/cobra` for building command-line interface (CLI) applications.
- **Data conversion:** `github.com/samber/lo` e.g. `lo.ToPtr`
- **Web Framework:** `github.com/gofiber/fiber/v2`
* **Validation:** `go-playground/validator`
* **Auth:** `golang-jwt/jwt`


### 3. Code Style

- **String Compare:** using `strings.EqualFlod`
