# AstroNvim Configuration

基于 [AstroNvim/template](https://github.com/AstroNvim/template) 的用户配置。

## Structure

```
config/nvim/
├── config.sh          # 安装脚本（克隆 AstroNvim/template）
├── user-plugins.lua   # 自定义插件配置
└── README.md          # 此文件
```

## Installation

运行安装：

```bash
just standalone nvim
```

或重新安装（备份旧配置）：

```bash
just nvim-reinstall
```

## How it works

1. **Dotbot** 链接 `user-plugins.lua` 到 `~/.config/nvim/lua/plugins/`
2. **config.sh** 克隆 [AstroNvim/template](https://github.com/AstroNvim/template) 到 `~/.config/nvim`
3. AstroNvim 自动加载 `lua/plugins/` 目录下的所有插件配置

## Customization

### 添加插件

编辑 `~/.config/nvim/lua/plugins/user-plugins.lua` 或修改源文件 `config/nvim/user-plugins.lua`。

示例配置：

```lua
return {
  -- 添加新插件
  {
    "nvim-tree/nvim-tree.lua",
    opts = {
      view = {
        side = "left",
      },
    },
  },

  -- 修改现有插件
  {
    "AstroNvim/astrotheme",
    opts = {
      transparent = true,
      style = "dark",
    },
  },
}
```

### Key Bindings

Default leader key is `<Space>`. Common bindings:

| Key | Action |
|-----|--------|
| `<leader>ff` | Find files |
| `<leader>fg` | Live grep |
| `<leader>fb` | List buffers |
| `<leader>fs` | Save file |
| `<leader>fn` | New file |
| `<leader>un` | Toggle line numbers |
| `<S-h>` | Previous buffer |
| `<S-l>` | Next buffer |
| `<S-q>` | Close buffer |

## Maintenance

```bash
# 同步插件
just nvim-sync

# 更新 AstroNvim 核心
just nvim-update

# 检查健康状态
just nvim-health

# 打开插件配置
just nvim-config
```

## Features

- **LSP**: 通过 `nvim-lspconfig` 自动配置语言服务器
- **Completion**: `nvim-cmp` 智能补全
- **Treesitter**: 20+ 语言语法高亮
- **Git**: `gitsigns.nvim` 内联 diff 显示
- **File Explorer**: Neo-tree 项目文件树
- **Search**: Telescope 模糊查找文件、文本、buffers
- **Buffer Management**: Bufferline 标签式界面
- **Themes**: AstroNvim astrotheme 支持透明背景

## Troubleshooting

### 插件不加载

```bash
just nvim-sync
```

### LSP 不工作

确保安装了语言服务器：

```bash
mise install <language-server>
```

或在 Neovim 内使用 Mason.nvim：`:Mason`

### 重置所有

```bash
just nvim-reinstall
```

## Resources

- [AstroNvim 文档](https://astronvim.com/)
- [AstroNvim/template](https://github.com/AstroNvim/template)
- [Lazy.nvim](https://github.com/folke/lazy.nvim)
- [Neovim Lua 指南](https://neovim.io/doc/user/lua-guide.html)
