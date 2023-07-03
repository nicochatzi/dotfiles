return {
  -- Git related plugins
  'tpope/vim-fugitive',
  -- 'tpope/vim-rhubarb',
  'tpope/vim-sleuth',     -- detect tabstop and shiftwidth automatically
  'tpope/vim-surround',   -- (ys) delete, change and insert surroundings
  'Raimondi/delimitMate', -- auto-closing braces
  'mhinz/vim-startify',

  {
    'nvim-pack/nvim-spectre',
    lazy = true,
  },

  {
    'aca/marp.nvim',
    ft = 'markdown',
  },

  {
    'NoahTheDuke/vim-just',
    ft = 'just',
  },

  {
    'sindrets/diffview.nvim',
    lazy = true,
  },

  {
    -- "gcc" => line,  gc" visual, "gc" + motion
    'numToStr/Comment.nvim',
    opts = {}
  },

  {
    -- LSP Configuration & Plugins
    'neovim/nvim-lspconfig',
    dependencies = {
      { 'williamboman/mason.nvim', config = true },
      'simrat39/rust-tools.nvim',
      'williamboman/mason-lspconfig.nvim',
      'folke/neodev.nvim',
      {
        'j-hui/fidget.nvim',
        branch = 'legacy',
        opts = {
          window = {
            blend = 0,
            border = "none",
          }
        },
      },
    },
  },

  {
    'simrat39/rust-tools.nvim',
    dependencies = {
      'neovim/nvim-lspconfig',
      'nvim-lua/plenary.nvim',
      'mfussenegger/nvim-dap',
    },
    ft = { 'rust', 'rs' },
    lazy = true,
  },

  {
    'Saecki/crates.nvim',
    ft = 'toml',
    lazy = true,
    dependencies = { 'nvim-lua/plenary.nvim' },
    version = 'v0.3.x',
    config = function()
      require('crates').setup()
      local crates = require('crates')
      local opts = { silent = true }
      vim.keymap.set('n', '<leader>rv', crates.show_versions_popup, opts)
      vim.keymap.set('n', '<leader>rf', crates.show_features_popup, opts)
      vim.keymap.set('n', '<leader>rd', crates.show_dependencies_popup, opts)
    end,
  },

  {
    -- Autocompletion
    'hrsh7th/nvim-cmp',
    lazy = true,
    event = "InsertEnter",
    dependencies = {
      'hrsh7th/cmp-nvim-lsp',
    },
  },
  { 'hrsh7th/nvim-cmp' },
  { 'hrsh7th/cmp-nvim-lsp' },
  { 'hrsh7th/cmp-nvim-lua' },
  { 'hrsh7th/cmp-nvim-lsp-signature-help' },
  { 'hrsh7th/cmp-vsnip' },
  { 'hrsh7th/cmp-path' },
  { 'hrsh7th/cmp-buffer' },
  { 'hrsh7th/vim-vsnip' },

  -- Useful plugin to show you pending keybinds.
  {
    'folke/which-key.nvim',
    event = "VeryLazy",
    init = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 300
    end,
    opts = {},
  },

  {
    -- Adds git releated signs to the gutter, as well as utilities for managing changes
    'lewis6991/gitsigns.nvim',
    opts = {
      -- See `:help gitsigns.txt`
      signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
      },
      on_attach = function(bufnr)
        vim.keymap.set('n', '<leader>gp', require('gitsigns').prev_hunk,
          { buffer = bufnr, desc = '[G]o to [P]revious Hunk' })
        vim.keymap.set('n', '<leader>gn', require('gitsigns').next_hunk, { buffer = bufnr, desc = '[G]o to [N]ext Hunk' })
        vim.keymap.set('n', '<leader>ph', require('gitsigns').preview_hunk, { buffer = bufnr, desc = '[P]review [H]unk' })
      end,
    },
  },

  -- theme
  {
    'rebelot/kanagawa.nvim',
    priority = 1000,
    config = function()
      require('kanagawa').setup({
        compile = true,   -- enable compiling the colorscheme
        undercurl = true, -- enable undercurls
        commentStyle = { italic = true },
        functionStyle = {},
        keywordStyle = { italic = true },
        statementStyle = { bold = true },
        typeStyle = {},
        transparent = true,    -- do not set background color
        dimInactive = false,   -- dim inactive window `:h hl-NormalNC`
        terminalColors = true, -- define vim.g.terminal_color_{0,17}
        colors = {
          -- add/modify theme and palette colors
          palette = {},
          theme = { all = { ui = { bg = 'none', bg_gutter = 'none' } } },
        },
        theme = "wave", -- Load "wave" theme when 'background' option is not set
        background = {
          -- map the value of 'background' option to a theme
          dark = "wave", -- try "dragon" | "wave"
          light = "lotus"
        },
      })
      vim.cmd.colorscheme('kanagawa')

      local deep = "#346152"
      local teal = "#5faf94"
      -- vim.api.nvim_set_hl(0, "CursorLine", { fg = '#4b5356' })
      vim.api.nvim_set_hl(0, "Visual", { bg = '#323d3d' })
      vim.api.nvim_set_hl(0, "FloatBorder", { bg = 'none' })
      vim.api.nvim_set_hl(0, "WinSeparator", { fg = deep })
      vim.api.nvim_set_hl(0, "StatusLine", { bg = 'none', fg = deep })
      vim.api.nvim_set_hl(0, "StatusLineNc", { bg = 'none', fg = deep })
      vim.api.nvim_set_hl(0, "TelescopeBorder", { bg = "none", fg = deep })
      -- vim.api.nvim_set_hl(0, "TreesitterContext", { bg = "none", fg = deep })
      vim.api.nvim_set_hl(0, "TelescopePromptBorder", { bg = "none", fg = deep })
      vim.api.nvim_set_hl(0, "TelescopeResultsBorder", { bg = "none", fg = deep })
      vim.api.nvim_set_hl(0, "TelescopePreviewBorder", { bg = "none", fg = deep })
      vim.api.nvim_set_hl(0, "TelescopePromptTitle", { fg = teal, bg = "none" })
      vim.api.nvim_set_hl(0, "TelescopeResultsTitle", { fg = teal, bg = "none" })
      vim.api.nvim_set_hl(0, "TelescopePreviewTitle", { fg = teal, bg = "none" })
      -- vim.api.nvim_set_hl(0, "NeoTreeTabActive", { bg = "none" })
      vim.api.nvim_set_hl(0, "NeoTreeTabInactive", { bg = "none" })
    end
  },

  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v2.x",
    lazy = true,
    cmd = { "Neotree" },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
      "MunifTanjim/nui.nvim",
      "mrbjarksen/neo-tree-diagnostics.nvim",
    },
    opts = {
      popup_border_style = "rounded",
      close_if_last_window = true,
      sources = {
        "filesystem",
        "buffers",
        "git_status",
        "document_symbols",
        "diagnostics",
      },
      window = {
        position = "left",
        width = 40,
        mappings = {
          ["<C-x>"] = "open_split",
          ["<C-v>"] = "open_vsplit",
          ["a"] = {
            "add",
            config = {
              show_path = "relative" -- "none", "relative", "absolute"
            }
          },
          ["c"] = {
            "copy",
            config = {
              show_path = "relative" -- "none", "relative", "absolute"
            }
          },
          ["m"] = {
            "move",
            config = {
              show_path = "relative" -- "none", "relative", "absolute"
            }
          },
        },
        popup = {
          position = "50%",
          size = {
            height = "80%",
            width = "100%",
          },
        },
      },
      filesystem = {
        filtered_items = {
          visible = true,
          hide_dotfiles = false,
          hide_gitignored = false,
          hide_hidden = false,
        },
        follow_current_file = true,
      },
      source_selector = {
        winbar = true,
        statusline = false,
        sources = {
          { source = "filesystem",       display_name = "  󰉓  " },
          { source = "git_status",       display_name = "  󰊢  " },
          { source = "buffers",          display_name = "    " },
          { source = "document_symbols", display_name = "    " },
          { source = "diagnostics",      display_name = "    " },
        },
      },
      buffers = {
        follow_current_file = true,
      },
      -- These are the defaults
      diagnostics = {
        auto_preview = {
          -- May also be set to `true`
          enabled = false,                 -- Whether to automatically enable preview mode
          preview_config = {},             -- Config table to pass to auto preview (for example `{ use_float = true }`)
          event = "neo_tree_buffer_enter", -- The event to enable auto preview upon (for example `"neo_tree_window_after_open"`)
        },
        bind_to_cwd = true,
        diag_sort_function = "severity", -- "severity" means diagnostic items are sorted by severity in addition to their positions.
        -- "position" means diagnostic items are sorted strictly by their positions.
        -- May also be a function.
        follow_behavior = {
          -- Behavior when `follow_current_file` is true
          always_focus_file = false, -- Focus the followed file, even when focus is currently on a diagnostic item belonging to that file.
          expand_followed = true,    -- Ensure the node of the followed file is expanded
          collapse_others = true,    -- Ensure other nodes are collapsed
        },
        follow_current_file = true,
        group_dirs_and_files = true,        -- when true, empty folders and files will be grouped together
        group_empty_dirs = true,            -- when true, empty directories will be grouped together
        show_unloaded = true,               -- show diagnostics from unloaded buffers
        refresh = {
          delay = 100,                      -- Time (in ms) to wait before updating diagnostics. Might resolve some issues with Neovim hanging.
          event = "vim_diagnostic_changed", -- Event to use for updating diagnostics (for example `"neo_tree_buffer_enter"`)
          -- Set to `false` or `"none"` to disable automatic refreshing
          max_items = false,                -- The maximum number of diagnostic items to attempt processing
          -- Set to `false` for no maximum
        },
      },
    }
  },

  {
    "mrbjarksen/neo-tree-diagnostics.nvim",
    dependencies = { "nvim-neo-tree/neo-tree.nvim" },
    lazy = true,
  },

  {
    -- Add indentation guides even on blank lines
    'lukas-reineke/indent-blankline.nvim',
    -- Enable `lukas-reineke/indent-blankline.nvim`
    -- See `:help indent_blankline.txt`
    config = function()
      vim.opt.list = true
      vim.cmd [[highlight IndentBlanklineIndent1 guibg=#1f1f1f gui=nocombine]]
      vim.cmd [[highlight IndentBlanklineIndent2 guibg=#1a1a1a gui=nocombine]]
      require("indent_blankline").setup {
        char = "",
        space_char_blankline = " ",
        show_trailing_blankline_indent = true,
        show_current_context = true,
        show_current_context_start = false,
      }
    end
  },

  -- Fuzzy Finder (files, lsp, etc)
  {
    'nvim-telescope/telescope.nvim',
    branch = '0.1.x',
    lazy = true,
    dependencies = {
      'nvim-lua/plenary.nvim',
      'debugloop/telescope-undo.nvim',
    },
    config = function()
      local telescope = require('telescope')
      telescope.setup({
        defaults = {
          border = true,
          sorting_strategy = 'ascending',
          layout_strategy = 'bottom_pane',
          layout_config = {
            height = 0.4,
            prompt_position = 'top',
          },
        },
        pickers = {
          find_files = {
            theme = "ivy",
          }
        },
        extensions = {
          undo = {
            side_by_side = true,
            sorting_strategy = 'ascending',
            layout_strategy = 'bottom_pane',
            layout_config = {
              height = 0.4,
              prompt_position = 'top',
            },
          },
          project = {},
          file_browser = {
            grouped = true,
            hijack_netrw = true,
            auto_depth = true,
            initial_browser = "tree",
            depth = 1,
          },
          ["ui-select"] = {
            require("telescope.themes").get_cursor {
              -- even more opts
              width = 0.8,
              previewer = false,
              prompt_title = false,
              borderchars = {
                { "─", "│", "─", "│", "┌", "┐", "┘", "└" },
                prompt = { "─", "│", " ", "│", "┌", "┐", "│", "│" },
                results = { "─", "│", "─", "│", "├", "┤", "┘", "└" },
                preview = { "─", "│", "─", "│", "┌", "┐", "┘", "└" },
              },
            }
          },
        }
      })
      telescope.load_extension("file_browser")
      telescope.load_extension('undo')
      telescope.load_extension("ui-select")
      telescope.load_extension('project')
    end
  },

  {
    'nvim-telescope/telescope-ui-select.nvim',
    lazy = true,
  },

  {
    "nvim-telescope/telescope-file-browser.nvim",
    dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
    branch = "feat/tree",
    lazy = true,
  },

  {
    'nvim-telescope/telescope-project.nvim',
    lazy = true,
  },

  {
    'nvim-telescope/telescope-fzf-native.nvim',
    -- NOTE: If you are having trouble with this installation,
    --       refer to the README for telescope-fzf-native for more instructions.
    build = 'make',
    lazy = true,
    cond = function()
      return vim.fn.executable 'make' == 1
    end,
    config = function()
      require('telescope').setup {
        defaults = {
          mappings = {
            i = {
              ['<C-u>'] = false,
              ['<C-d>'] = false,
            },
          },
        }
      }
      -- Enable telescope fzf native, if installed
      pcall(require('telescope').load_extension, 'fzf')
    end
  },

  -- {
  --   "nvim-telescope/telescope-frecency.nvim",
  --   dependencies = { "kkharji/sqlite.lua" },
  --   config = function()
  --     require "telescope".load_extension("frecency")
  --   end,
  -- },

  {
    -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    dependencies = {
      'nvim-treesitter/nvim-treesitter-textobjects',
    },
    build = ':TSUpdate',
    config = function()
      require 'nvim-treesitter.configs'.setup {
        indent = {
          enable = true
        }
      }
    end
  },

  'nvim-treesitter/nvim-treesitter-context',

  -- debugging
  {
    'mfussenegger/nvim-dap',
    lazy = true,
    config = function()
      vim.fn.sign_define('DapBreakpoint', { text = '🛑', texthl = '', linehl = '', numhl = '' })
      local dap = require('dap')
      dap.adapters.codelldb = {
        type = 'server',
        host = '127.0.0.1',
        port = 13000, -- 💀 Use the port printed out or specified with `--port`
        -- type = 'server',
        -- port = "${port}",
        -- executable = {
        --   -- CHANGE THIS to your path!
        --   command = '~/.codelldb/extension/adapter/codelldb',
        --   args = { "--port", "${port}" },
        --   -- On windows you may have to uncomment this:
        --   -- detached = false,
        -- }
      }
    end
  },

  {
    'rcarriga/nvim-dap-ui',
    dependencies = { 'mfussenegger/nvim-dap' },
    lazy = true,
    config = function()
      require("dapui").setup({
        layouts = { {
          elements = { {
            id = "scopes",
            size = 0.40
          }, {
            id = "stacks",
            size = 0.40
          }, {
            id = "breakpoints",
            size = 0.10
          }, {
            id = "watches",
            size = 0.10
          } },
          position = "right",
          size = 100
        }, {
          elements = { {
            id = "repl",
            size = 0.5
          }, {
            id = "console",
            size = 0.5
          } },
          position = "bottom",
          size = 15
        } },
      })
      local dap, dapui = require("dap"), require("dapui")
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
      end
    end
  },

  {
    'folke/neodev.nvim',
    opts = {
      library = { plugins = { "nvim-dap-ui" }, types = true },
    }
  },

  {
    'Civitasv/cmake-tools.nvim',
    ft = 'cpp',
    opts = {
      cmake_command = "cmake",
      cmake_build_directory = "",
      cmake_build_directory_prefix = "cmake_build_",                                     -- when cmake_build_directory is "", this option will be activated
      cmake_generate_options = { "-D", "CMAKE_EXPORT_COMPILE_COMMANDS=1" },
      cmake_regenerate_on_save = true,                                                   -- Saves CMakeLists.txt file only if mofified.
      cmake_soft_link_compile_commands = true,                                           -- if softlink compile commands json file
      cmake_compile_commands_from_lsp = false,                                           -- automatically set compile commands location using lsp
      cmake_build_options = {},
      cmake_console_size = 10,                                                           -- cmake output window height
      cmake_console_position = "belowright",                                             -- "belowright", "aboveleft", ...
      cmake_show_console = "always",                                                     -- "always", "only_on_error"
      cmake_kits_path = nil,                                                             -- global cmake kits path
      cmake_dap_configuration = { name = "cpp", type = "codelldb", request = "launch" }, -- dap configuration, optional
      cmake_variants_message = {
        short = { show = true },
        long = { show = true, max_length = 40 }
      }
    }
  },

  {
    'iamcco/markdown-preview.nvim',
    cmd = { "MarkdownPreviewToggle" },
    ft = { "markdown" },
    lazy = true,
    build = function() vim.fn["mkdp#util#install"]() end,
  },

  {
    -- Set lualine as statusline
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons', opt = true },
    -- See `:help lualine.txt`
    config = function()
      local config = {
        options = {
          theme = 'auto',
          icons_enabled = true,
          disabled_filetypes = { 'neo-tree' },
          component_separators = { left = '', right = '' },
          section_separators = { left = '|', right = '|' },
          always_divide_middle = false,
        },
        sections = {
          lualine_a = {},
          lualine_b = {},
          lualine_c = {},
          lualine_x = {},
          lualine_y = {},
          lualine_z = {},
        },
        inactive_sections = {
          lualine_a = {},
          lualine_b = {},
          lualine_c = {},
          lualine_x = {},
          lualine_y = {},
          lualine_z = {},
        },
        winbar = {
          lualine_a = { {
            'filename',
            file_status = true, -- displays file status (readonly status, modified status)
            path = 1            -- 0 = just filename, 1 = relative path, 2 = absolute path
          } },
          lualine_b = { 'branch', 'diagnostics' },
          lualine_c = {},
          lualine_x = {},
          lualine_y = {},
          lualine_z = {},
        },
        inactive_winbar = {
          lualine_a = {},
          lualine_b = { {
            'filename',
            file_status = true, -- displays file status (readonly status, modified status)
            path = 1            -- 0 = just filename, 1 = relative path, 2 = absolute path
          }, 'diagnostics' },
          lualine_c = {},
          lualine_x = {},
          lualine_y = {},
          lualine_z = {}
        }
      }
      require('lualine').setup(config)
      require('lualine').hide({
        place = { 'statusline', 'tabline' }, -- The segment this change applies to.
        unhide = false,                      -- whether to re-enable lualine again/
      })
      -- hack to remove lualine background
      vim.api.nvim_set_hl(0, "lualin_b_normal", { bg = "none" })
      vim.api.nvim_set_hl(0, "lualine_c_normal", { bg = "none" })
      vim.api.nvim_set_hl(0, "lualine_c_insert", { bg = "none" })
      vim.api.nvim_set_hl(0, "lualine_x_normal", { bg = "none" })
      vim.api.nvim_set_hl(0, "lualine_x_insert", { bg = "none" })
      vim.api.nvim_set_hl(0, "lualine_a_inactive", { bg = "none" })
      vim.api.nvim_set_hl(0, "lualine_b_inactive", { bg = "none" })
      vim.api.nvim_set_hl(0, "lualine_c_inactive", { bg = "none" })
      vim.api.nvim_set_hl(0, "lualine_x_inactive", { bg = "none" })
      vim.api.nvim_set_hl(0, "lualine_y_inactive", { bg = "none" })
      vim.api.nvim_set_hl(0, "lualine_z_inactive", { bg = "none" })
      vim.api.nvim_set_hl(0, "lualine_a_normal", { fg = "#282a2e", bg = "#81a2be" })
      vim.api.nvim_set_hl(0, "lualine_a_insert", { fg = "#282a2e", bg = "#b5bd68" })
      vim.api.nvim_set_hl(0, "lualine_a_visual", { fg = "#282a2e", bg = "#b294bb" })
      vim.api.nvim_set_hl(0, "lualine_a_command", { fg = "#282a2e", bg = "#81a2be" })
      vim.api.nvim_set_hl(0, "lualine_a_replace", { fg = "#282a2e", bg = "#de935f" })
      vim.api.nvim_set_hl(0, "lualine_a_terminal", { fg = "#282a2e", bg = "#b5bd68" })
    end
  },

  {
    'alopatindev/cargo-limit',
    ft = 'rust',
    build = 'cargo install cargo-limit nvim-send',
  },

  {
    'kevinhwang91/nvim-bqf',
    ft = 'qf',
    opts = {
      preview = {
        winblend = 0,
      }
    }
  },

  -- {
  --   "folke/persistence.nvim",
  --   event = "BufReadPre", -- this will only start session saving when an actual file was opened
  --   module = "persistence",
  --   config = function()
  --     require("persistence").setup {
  --       dir = vim.fn.expand(vim.fn.stdpath "config" .. "/session/"),
  --       options = { "buffers", "curdir", "tabpages", "winsize" },
  --     }
  --     -- restore the session for the current directory
  --     vim.api.nvim_set_keymap("n", "<leader>qs", [[<cmd>lua require("persistence").load()<cr>]], {})
  --     -- restore the last session
  --     vim.api.nvim_set_keymap("n", "<leader>ql", [[<cmd>lua require("persistence").load({ last = true })<cr>]], {})
  --     -- stop Persistence => session won't be saved on exit
  --     vim.api.nvim_set_keymap("n", "<leader>qd", [[<cmd>lua require("persistence").stop()<cr>]], {})
  --   end,
  -- },
}
