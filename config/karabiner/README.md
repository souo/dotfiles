# 🎹 Karabiner-Elements 配置

这是 macOS 平台最强大的底层改键工具配置。通过它，我们将标准键盘改造成更符合开发者（尤其是 Neovim 和 Aerospace 用户）习惯的“神级”输入工具。

## 🚀 当前核心配置：The "God Key"

目前的 `karabiner.json` 启用了一项最经典且高效的 **Complex Modification**：

### **Caps Lock 改造 (Control / Escape)**

- **长按 (Hold)**：作为 `Left Control` 使用。
  - *收益*：左手小指不再需要跨越巨大角度去按左下角的 Control，极大缓解疲劳，方便执行 `Ctrl + [h,j,k,l]` 或终端快捷键。
- **轻点 (Tap)**：作为 `Escape` 使用。
  - *收益*：Neovim 用户退出插入模式的最快路径。

---

## 💡 学习与使用建议

### 1. 肌肉记忆培养

- **第一周**：你会不习惯。建议在 macOS 系统设置中彻底禁用原生的 Caps Lock 功能，强迫自己习惯这种“双重身份”的按键。
- **配合 Neovim**：尝试在插入模式下轻点 Caps Lock 退出，在正常模式下长按 Caps Lock 配合其他键进行操作。

### 2. 进阶方向：Hyper Key

当你习惯了当前的改键后，下一步建议配置 **Hyper Key**：

- **逻辑**：将 Caps Lock（或另一个不常用键）映射为 `Cmd + Opt + Ctrl + Shift`。
- **用途**：因为没有任何原生软件会用到这个组合键，你可以将其作为 **Aerospace** 窗口管理的专用前缀。例如 `Hyper + 1` 跳转到第一个虚拟桌面。

### 3. 应用特定规则 (Frontmost Application)

你可以设置规则仅在特定软件中生效。例如：在 Chrome 中 `Cmd + J/K` 切换标签页，但在 Neovim 中保持原样。

---

## 🛠️ 如何自定义

1. **图形界面 (推荐)**：
   - 打开 `Karabiner-Elements` App。
   - 进入 `Complex Modifications` 选项卡。
   - 点击 `Add rule` -> `Import more rules from the Internet`。
   - 找到喜欢的规则点击 `Import`，然后在 App 内 `Enable`。
   - **配置会自动写回本目录下的 `karabiner.json`。**

2. **手动编辑 JSON**：
   - 除非你对 JSON 结构非常熟悉，否则不建议手写。建议使用 [Goku](https://github.com/yqrashawn/Goku) 这样的工具，它可以使用更简洁的 `edn` 格式编写配置并生成 JSON。

---

## 🔗 常用链接与资源

- **[官方文档](https://karabiner-elements.pqrs.org/docs/)**：了解安装和基本使用。
- **[官方规则库 (必看)](https://ke-complex-modifications.pqrs.org/)**：包含了成千上万社区分享的现成规则（如：Hyper Key, Vim Mode, Emacs Key Bindings）。
- **[Karabiner.json 可视化编辑器](https://genesy.github.io/karabiner-complex-modifications-editor/)**：通过可视化界面在线生成复杂的 JSON 逻辑。

## ⚠️ 常见问题

- **权限失效**：每次系统更新或重新部署后，如果发现改键不起作用，请去 `系统设置 -> 隐私与安全性 -> 输入监听/辅助功能` 重新开关 Karabiner 的权限。
- **JSON 冲突**：如果你手动修改了 JSON 导致格式错误，Karabiner 将无法加载配置并报错。
