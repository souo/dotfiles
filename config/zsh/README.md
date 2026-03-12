# 🐚 Zsh Configuration (High Performance)

基于 **Antidote** 插件管理器和 **zsh-defer** 延迟加载机制的高性能 Zsh 配置。

## 🚀 特性

- **零延迟启动**：使用 `zsh-defer` 异步加载非核心组件，确保终端瞬间响应。
- **模块化设计**：配置分为环境、别名、函数和插件，易于维护。
- **极速插件管理**：通过 `antidote` 静态编译插件列表，避免每次启动时的插件解析开销。
- **现代化补全**：集成 `fzf-tab` 提供可视化补全选择。

## 📂 目录结构

```text
config/zsh/
├── zshrc               # 主入口文件 (链接至 ~/.zshrc)
├── common/             # 共享配置
│   ├── .env           # 环境变量
│   ├── .aliases       # 别名定义
│   └── plugins.txt    # Antidote 插件定义
├── functions/          # 自定义函数库 (自动加载 ~/.zsh_functions/*.zsh)
└── README.md           # 本说明文档
```

## 🛠️ 安装与部署

本配置通过 **Dotbot** 自动管理。在项目根目录下运行以下命令即可：

```bash
./install-standlore.sh zsh
```

### 插件管理 (Antidote)

插件定义在 `config/zsh/common/plugins.txt` 中。

- 修改该文件后，重启终端会自动通过 `antidote` 更新静态缓存。
- 静态缓存存储在 `$XDG_CACHE_HOME/antidote/plugins.zsh`。

## 💡 自定义函数

所有放置在 `config/zsh/functions/` 下以 `.zsh` 结尾的文件都会被自动 `source`。
例如，当前的 `game_assets.zsh` 提供了游戏资产管理功能：

- `ga_init`: 初始化资产库结构。
- `ga_link`: 安全创建跨目录软链接。
- `ga_unzip`: 纯净解压（过滤 `__MACOSX` 等垃圾文件）。

## 🔗 参考资源

- [Antidote Documentation](https://getantidote.github.io/)
- [zsh-defer](https://github.com/romkatv/zsh-defer)
- [fzf-tab](https://github.com/Aloxaf/fzf-tab)
- [A Faster and Enjoyable ZSH](https://htr3n.github.io/2018/07/faster-zsh/)
