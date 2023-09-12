return function(capabilities, on_attach)
  local extension_path = vim.env.HOME .. "/.local/share/nvim/mason/packages/codelldb/extension/"
  local codelldb_path = extension_path .. "adapter/codelldb"
  local liblldb_path = extension_path .. "lldb/lib/liblldb.dylib"

  require("rust-tools").setup {
    capabilities = capabilities,
    on_attach = on_attach,
    server = {
      capabilities = capabilities,
      on_attach = on_attach,
      settings = {
        ['rust-analyzer'] = {
          cargo = {
            autoReload = true,
            allFeatures = true,
          },
          inlayHints = {
            bindingModeHints = true,
            chainingHints = true,
            closingBraceHints = true,
            closureReturnTypeHints = { enable = "with_block", },
            lifetimeElisionHints = { enable = "skip_trivial", },
          },
          checkOnSave = {
            enable = true,
            allTargets = false,
            command = "clippy",
            extraArgs = { "--all", "--", "-W", "clippy::all" },
          },
          lens = {
            enable = true,
            references = {
              implementatios = { enable = true },
              enumVariant = { enable = true },
              adt = { enable = true },
              method = { enable = true },
              trait = { enable = true },
            }
          },
        }
      }
    },
    tools = {
      executor = require("rust-tools.executors").quickfix,
      on_initialized = nil,
      reload_workspace_from_cargo_toml = true,
      inlay_hints = {
        auto = true,
        only_current_line = false,
        show_parameter_hints = true,
        parameter_hints_prefix = "<- ",
        other_hints_prefix = "=> ",
        max_len_align = false,
        max_len_align_padding = 1,
        right_align = false,
        right_align_padding = 7,
        highlight = "Comment",
      },
      hover_actions = {
        border = {
          { "╭", "FloatBorder" },
          { "─", "FloatBorder" },
          { "╮", "FloatBorder" },
          { "│", "FloatBorder" },
          { "╯", "FloatBorder" },
          { "─", "FloatBorder" },
          { "╰", "FloatBorder" },
          { "│", "FloatBorder" },
        },
        max_width = nil,
        max_height = nil,
        auto_focus = false,
      },
    },
    dap = {
      adapter = require("rust-tools.dap").get_codelldb_adapter(codelldb_path, liblldb_path)
    },
  }
end
