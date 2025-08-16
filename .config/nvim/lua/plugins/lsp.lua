return {
  {
    -- LSP Configuration & Plugins
    'neovim/nvim-lspconfig',
    -- event = 'VeryLazy',
    event = { 'BufReadPre', 'BufNewFile' },
    dependencies = {
      { 'p00f/clangd_extensions.nvim' },
      {
        'folke/neodev.nvim',
        opts = {
          library = { plugins = { "neotest" }, types = true },
        }
      },
      -- good for symbolic search and referencing but it's
      -- way too busy for my taste, worth some digging
      -- at some point!
      -- {
      --     'ray-x/navigator.lua',
      --     dependencies = {
      --         { 'ray-x/guihua.lua', run = 'cd lua/fzy && make' },
      --     },
      --     config = function()
      --         require("navigator").setup {}
      --     end,
      -- },
      {
        'j-hui/fidget.nvim',
        tag = "*",
        opts = {
          notification = {
            window = {
              normal_hl = "Comment",
              winblend = 0,
              border = "none",
            },
          },
          progress = {
            display = {
              render_limit = 32,
              done_ttl = 10
            }
          },
        }
      }
    },
    config = function()
      require('lang.config')
    end,
  },
  {
    'nvimdev/lspsaga.nvim',
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
      'nvim-tree/nvim-web-devicons',
    },
    config = function()
      require('lspsaga').setup {
        ui = {
          code_action = "󰌶",
          diagnostic = "",
        },
        lightbulb = {
          virtual_text = false,
        },
        symbol_in_winbar = { enable = false },
        callhiearachy = {
          layout = 'float',
          keys = {
            edit = 'e',
            vsplit = 'v',
            split = 's',
            tabe = 't',
            quit = 'q',
            shuttle = '[w',
            toggle_or_req = 'u',
            close = '<C-c>k',
          }
        },
        code_action = {
          show_server_name = true,
        },
        outline = {
          keys = {
            toggle_or_jump = 'o',
            jump = 'e',
            quit = 'q',
          }
        }
      }
    end,
  }
}
