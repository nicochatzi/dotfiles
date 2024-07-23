local on_attach = require 'lang.on_attach'
local lsp = require 'lspconfig'
local configs = require 'lspconfig.configs'

configs.ltex_ls = {
  default_config = {
    cmd = { 'ltex-ls' },
    filetypes = { 'ltex', 'markdown' },
    name = 'ltex_ls',
  }
}

-- server settings
local servers = {
  ltex_ls = {
    enabled = { 'latex', 'tex', 'bib', 'markdown' },
    language = 'en-US',
    diagnosticSeverity = 'information',
    setenceCacheSize = 2000,
    additionalRules = {
      enablePickyRules = true,
      motherTongue = 'en-US',
    },
    trace = { server = 'verbose' },
    dictionary = {},
    disabledRules = {},
    hiddenFalsePositives = {},
  },
  robotframework_ls = {},
  ruff = {
    init_options = {
      settings = {
        logLevel = "debug",
        logFile = "~/.local/state/nvim/ruff.log"
      }
    }
  },
  pyright = {
    settings = {
      pyright = {
        -- Using Ruff's import organizer
        disableOrganizeImports = true,
      },
      python = {
        analysis = {
          -- Ignore all files for analysis to exclusively use Ruff for linting
          ignore = { '*' },
        },
      },
    },
  },
  eslint = {},
  jsonls = {},
  html = {},
  cssls = {},
  bashls = {},
  sqlls = {},
  mdx_analyzer = {},
  marksman = {},
  asm_lsp = {},
  tflint = {},
  gopls = {},
  clangd = {},
  cmake = {},
  zls = {
    enable_snippets = true,
    enable_argument_placeholders = false,
    enable_ast_check_diagnostics = false,
    enable_build_on_save = false,
    enable_autofix = false,
    enable_inlay_hints = true,
    inlay_hints_show_variable_type_hints = true,
    inlay_hints_show_parameter_name = true,
    inlay_hints_show_builtin = true,
    inlay_hints_exclude_single_argument = true,
    inlay_hints_hide_redundant_param_names = true,
    inlay_hints_hide_redundant_param_names_last_token = true,
    highlight_global_var_declarations = true,
    record_session = false,
  },
  -- rust_analyzer = {},
  -- luau_lsp = {},
  tsserver = {},
  taplo = {},
  dockerls = {},
  nil_ls = {
    ['nil'] = {
      testSetting = 42,
      formatting = {
        command = { 'nixfmt' },
      },
      nix = {
        flake = {
          autoArchive = true,
        },
      },
    },
  },
  lua_ls = {
    Lua = {
      workspace = { checkThirdParty = false },
      telemetry = { enable = false },
      diagnostics = {
        globals = { 'vim' },
      },
    },
  },
  yamlls = {
    schemaStore = { enable = true },
  },
}

-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)
capabilities.textDocument.completion.completionItem.snippetSupport = false

-- manual overrides for lspconfig settings on certain servers
local server_setups = {
  -- ['rust-analyzer'] = function()
  --   require('lang.rust')(capabilities, on_attach)
  -- end,
  nil_ls = function()
    lsp.nil_ls.setup {
      capabilities = capabilities,
      on_attach = on_attach,
      cmd = { 'nil' },
      filetypes = { 'nix' },
      settings = servers['nil_ls'],
      autostart = true,
      single_file_support = true,
      flags = {
        debounce_text_changes = 150,
      }
    }
  end,
}

for server_name, server_config in pairs(servers) do
  if server_setups[server_name] then
    server_setups[server_name]()
  else
    lsp[server_name].setup {
      capabilities = capabilities,
      on_attach = on_attach,
      settings = server_config,
      autostart = true,
      single_file_support = true,
      flags = {
        debounce_text_changes = 150,
      }
    }
  end
end

require('lang.clangd')

require('ufo').setup()
