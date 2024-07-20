return {
  {
    'mrcjkb/rustaceanvim',
    version = '^4', -- Recommended
    lazy = false,   -- This plugin is already lazy
    config = function()
      local codelldb = require('lang.codelldb')
      local codelldb_path = codelldb.codelldb_path
      local liblldb_path = codelldb.liblldb_path

      vim.g.rustaceanvim = {
        -- adapters = {
        --   require('rustaceanvim.neotest')
        -- },
        -- dap = {
        --   adapter = require('rust-tools.dap').get_codelldb_adapter(codelldb_path, liblldb_path),
        -- },
        tools = {
          enable_nextest = true,
          enable_clippy = true,
          hover_actions = {
            border = {
              { '╭', 'FloatBorder' },
              { '─', 'FloatBorder' },
              { '╮', 'FloatBorder' },
              { '│', 'FloatBorder' },
              { '╯', 'FloatBorder' },
              { '─', 'FloatBorder' },
              { '╰', 'FloatBorder' },
              { '│', 'FloatBorder' },
            },
            max_width = nil,
            max_height = nil,
            auto_focus = false,
          },
        },
        server = {
          capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities()),
          on_attach = require 'lang.on_attach',
          default_settings = {
            ['rust-analyzer'] = {
              cargo = {
                allFeatures = true,
                autoReload = true,
                loadOutDirsFromCheck = true,
                runBuildScripts = true,
              },
              procMacro = {
                enable = true,
              },
              rust = {
                analyzerTargetDir = 'target/rust-analyzer',
              },
              inlayHints = {
                bindingModeHints = true,
                chainingHints = true,
                closingBraceHints = true,
                closureReturnTypeHints = { enable = 'with_block' },
                lifetimeElisionHints = { enable = 'skip_trivial' },
                expressionAdjustmentHints = { enable = 'always' },
              },
              checkOnSave = {
                enable = true,
                allTargets = true,
                command = 'clippy',
                extraArgs = { '--', '-D', 'clippy::all' },
              },
              lens = {
                enable = true,
                run = { enable = true },
                debug = { enable = true },
                references = {
                  implementatios = { enable = true },
                  enumVariant = { enable = true },
                  adt = { enable = true },
                  method = { enable = true },
                  trait = { enable = true },
                }
              },
              diagnostics = {
                enable = true,
                experimental = {
                  enable = true,
                },
                styleLints = {
                  enable = true,
                },
              },
              hover = {
                actions = {
                  references = {
                    enable = true,
                  }
                }
              },
            }
          }
        },
      }
    end
  },

  {
    'Saecki/crates.nvim',
    event = { 'BufReadPre Cargo.toml' },
    dependencies = { 'nvim-lua/plenary.nvim' },
    version = 'v0.3.x',
    opts = {},
  },

  {
    'alopatindev/cargo-limit',
    ft = 'rust',
    build = 'cargo install cargo-limit nvim-send',
  },
}
