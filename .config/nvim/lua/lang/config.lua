local on_attach = require 'lang.on_attach'
local lsp = require 'lspconfig'

local words = {}
for word in io.open(vim.fn.stdpath("config") .. "/spell/en.utf-8.add", "r"):lines() do
  table.insert(words, word)
end

-- server settings
local servers = {
  -- ltex = {
  --   enabled = { 'latex', 'tex', 'bib', 'markdown' },
  --   language = 'en-US',
  --   diagnosticSeverity = 'information',
  --   setenceCacheSize = 2000,
  --   additionalRules = {
  --     enablePickyRules = true,
  --     motherTongue = 'en-US',
  --   },
  --   use_spellfile = true,
  --   trace = { server = 'verbose' },
  --   disabledRules = {},
  --   hiddenFalsePositives = {},
  --   dictionary = {
  --     ['en-US'] = words
  --   }
  -- },
  -- robotframework_ls = {},
  -- ruff = {
  --   init_options = {
  --     settings = {
  --       logLevel = "debug",
  --       logFile = "~/.local/state/nvim/ruff.log"
  --     }
  --   }
  -- },
  pyright = {
    settings = {
      pyright = {
        -- Using Ruff's import organizer
        -- disableOrganizeImports = true,
      },
      python = {
        analysis = {
          autoSearchPaths = true,
          useLibraryCodeForTypes = true,
          -- Ignore all files for analysis to exclusively use Ruff for linting
          -- ignore = { '*' },
          ignore = {},
        },
      },
    },
  },
  -- eslint = {},
  biome = {},
  jsonls = {},
  html = {},
  cssls = {},
  bashls = {},
  sqls = {},
  mdx_analyzer = {},
  marksman = {},
  asm_lsp = {},
  tflint = {},
  terraformls = {},
  gopls = {},
  clangd = {},
  cmake = {},
  zls = {},
  -- rust_analyzer = {},
  -- luau_lsp = {},
  ts_ls = {},
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
  biome = function()
    lsp.biome.setup {
      capabilities = capabilities,
      on_attach = on_attach,
      cmd = { 'npx', 'biome', 'lsp-proxy' },
      filetypes = { "javascript", "javascriptreact", "json", "jsonc", "typescript", "typescript.tsx", "typescriptreact", "astro", "svelte", "vue", "css" },
      settings = servers['biome'],
      autostart = true,
      single_file_support = true,
      flags = {
        debounce_text_changes = 150,
      }
    }
  end
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
