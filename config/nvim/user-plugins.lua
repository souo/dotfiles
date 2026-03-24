-- ==============================================================================
-- AstroNvim User Plugin Configuration
-- Customize your AstroNvim setup here
-- ==============================================================================

return {
  -- ============================================================================
  -- 🎨 UI & Appearance
  -- ============================================================================

  -- Transparent background
  {
    "AstroNvim/astrotheme",
    opts = {
      transparent = true,
      style = "dark",
    },
  },

  -- Better UI components
  {
    "stevearc/dressing.nvim",
    opts = {},
  },

  -- ============================================================================
  -- 📦 File Management
  -- ============================================================================

  -- File explorer (NeoTREE)
  {
    "nvim-neo-tree/neo-tree.nvim",
    opts = {
      filesystem = {
        filtered_items = {
          visible = false,
          hide_dotfiles = false,
          hide_gitignored = false,
        },
      },
      window = {
        position = "left",
        width = 30,
      },
    },
  },

  -- Buffer management
  {
    "akinsho/bufferline.nvim",
    event = "VeryLazy",
    opts = {
      options = {
        mode = "buffers",
        style_preset = require("bufferline").style_preset.default,
        show_buffer_close_icons = true,
        show_close_icon = true,
        show_buffer_icons = true,
        diagnostics = "nvim_lsp",
        diagnostics_update_in_insert = false,
        offsets = {
          {
            filetype = "neo-tree",
            text = "File Explorer",
            highlight = "Directory",
            text_align = "left",
          },
        },
      },
    },
  },

  -- ============================================================================
  -- 🔍 Search & Navigation
  -- ============================================================================

  -- Fuzzy finder (Telescope)
  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    opts = {
      defaults = {
        file_ignore_patterns = { "node_modules", ".git", "dist", "build" },
        path_display = { "smart" },
      },
    },
  },

  -- Better telescope theme
  {
    "nvim-telescope/telescope-ui-select.nvim",
    lazy = true,
    config = function()
      require("telescope").setup({
        extensions = {
          ["ui-select"] = {
            require("telescope.themes").get_dropdown({}),
          },
        },
      })
      require("telescope").load_extension("ui-select")
    end,
  },

  -- ============================================================================
  -- 💻 Code & LSP
  -- ============================================================================

  -- LSP configuration
  {
    "neovim/nvim-lspconfig",
    config = function()
      require("astrocore").on_load("lspconfig", function()
        local lsp = require("astrocore.lsp")
        lsp.setup()
      end)
    end,
  },

  -- Autocomplete
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    opts = {
      completion = {
        completeopt = "menu,menuone,noinsert",
      },
    },
  },

  -- ============================================================================
  -- 🌳 Treesitter
  -- ============================================================================

  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "bash",
        "css",
        "dockerfile",
        "gitignore",
        "html",
        "javascript",
        "json",
        "lua",
        "markdown",
        "markdown_inline",
        "python",
        "query",
        "regex",
        "rust",
        "toml",
        "tsx",
        "typescript",
        "vim",
        "vimdoc",
        "yaml",
      },
      highlight = {
        enable = true,
      },
      indent = {
        enable = true,
      },
    },
  },

  -- ============================================================================
  -- 📝 Editing Utilities
  -- ============================================================================

  -- Auto pairs
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = {},
  },

  -- Better comments
  {
    "folke/todo-comments.nvim",
    event = "LazyFile",
    opts = {
      signs = true,
      sign_priority = 8,
    },
  },

  -- Git integration
  {
    "lewis6991/gitsigns.nvim",
    event = "LazyFile",
    opts = {
      signs = {
        add = { text = "│" },
        change = { text = "│" },
        delete = { text = "_" },
        topdelete = { text = "‾" },
        changedelete = { text = "~" },
      },
    },
  },

  -- ============================================================================
  -- 🐛 Debugging
  -- ============================================================================

  {
    "mfussenegger/nvim-dap",
    lazy = true,
    dependencies = {
      "rcarriga/nvim-dap-ui",
      "theHamsta/nvim-dap-virtual-text",
    },
  },

  -- ============================================================================
  -- 🔧 Utilities
  -- ============================================================================

  -- Better which-key
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      plugins = { spelling = true },
      defaults = {},
    },
  },

  -- Colorscheme switching
  {
    "zaldih/themery.nvim",
    cmd = "Themery",
  },

  -- ============================================================================
  -- ⚡ Performance
  -- ============================================================================

  -- Fast plugins loading
  {
    "folke/lazy.nvim",
    opts = {
      defaults = {
        lazy = true,
      },
      performance = {
        rtp = {
          disabled_plugins = {
            "gzip",
            "tarPlugin",
            "tohtml",
            "tutor",
            "zipPlugin",
          },
        },
      },
    },
  },

  -- ============================================================================
  -- 🎯 Keybindings (Leader keys)
  -- ============================================================================

  {
    "AstroNvim/astrocore",
    ---@type AstroCoreOpts
    opts = {
      mappings = {
        -- Better buffer management
        ["<S-h>"] = { "<cmd>bprevious<cr>", desc = "Previous buffer" },
        ["<S-l>"] = { "<cmd>bnext<cr>", desc = "Next buffer" },
        ["<S-q>"] = { "<cmd>bdelete<cr>", desc = "Close buffer" },

        -- File operations
        ["<leader>ff"] = { "<cmd>Telescope find_files<cr>", desc = "Find files" },
        ["<leader>fg"] = { "<cmd>Telescope live_grep<cr>", desc = "Live grep" },
        ["<leader>fb"] = { "<cmd>Telescope buffers<cr>", desc = "Buffers" },
        ["<leader>fh"] = { "<cmd>Telescope help_tags<cr>", desc = "Help tags" },

        -- Git
        ["<leader>gs"] = { "<cmd>Telescope git_status<cr>", desc = "Git status" },
        ["<leader>gb"] = { "<cmd>Telescope git_branches<cr>", desc = "Git branches" },

        -- Toggle UI
        ["<leader>un"] = { "<cmd>set nonumber<cr> <cmd>set norelativenumber<cr>", desc = "Disable line numbers" },
        ["<leader>ue"] = { "<cmd>set number<cr> <cmd>set relativenumber<cr>", desc = "Enable line numbers" },
      },
    },
  },
}
