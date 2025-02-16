return {
  {
    'mrcjkb/rustaceanvim',
    -- version = '^5',
    lazy = false, -- This plugin is already lazy
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
          -- cmd = { 'ra-multiplex' }, -- no longer required, rustaceanvim will auto-detect ra-multiplex, if running
          default_settings = {
            ['rust-analyzer'] = {
              cachePriming = {
                enable = true,
                -- numThreads = 8,
              },
              cargo = {
                -- numThreads = 8,
                allFeatures = true,
                autoReload = true,
                loadOutDirsFromCheck = true,
                runBuildScripts = true,
                buildScripts = {
                  enable = true,
                  invocationStrategy = 'per_workspace',
                  overrideCommand = nil,
                  rebuildOnSave = true,
                  useRustcWrapper = true
                },
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
                allFeatures = true,
                command = 'clippy',
                extraArgs = {
                  '--',
                  '-D', 'clippy::all',
                  '-W', 'clippy::pedantic',
                  -- '-W', 'clippy::nursery',
                  '-A', 'clippy::missing-errors-doc',
                  '-A', 'clippy::wildcard-imports',
                  -- from clippy::restriction
                  '-W', 'clippy::allow_attributes_without_reason',
                  '-W', 'clippy::clone_on_ref_ptr',
                  '-W', 'clippy::dbg_macro',
                  '-W', 'clippy::default_numeric_fallback',
                  '-W', 'clippy::empty_structs_with_brackets',
                  '-W', 'clippy::filetype_is_file',
                  '-W', 'clippy::format_push_string',
                  '-W', 'clippy::infinite_loop',
                  '-W', 'clippy::let_underscore_must_use',
                  '-W', 'clippy::multiple_unsafe_ops_per_block',
                  '-W', 'clippy::mutex_atomic',
                  '-W', 'clippy::rc_mutex',
                  '-D', 'clippy::if_then_some_else_none',
                  '-D', 'clippy::alloc_instead_of_core',
                  '-D', 'clippy::empty_enum_variants_with_brackets',
                  '-D', 'clippy::assertions_on_result_states',
                },
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

  { "cordx56/rustowl", dependencies = { "neovim/nvim-lspconfig" } },

  {
    'Saecki/crates.nvim',
    event = { 'BufReadPre Cargo.toml' },
    dependencies = { 'nvim-lua/plenary.nvim' },
    tag = 'stable',
    opts = {},
  },

  -- {
  --   'alopatindev/cargo-limit',
  --   ft = 'rust',
  --   build = 'cargo install cargo-limit nvim-send',
  -- },
}
