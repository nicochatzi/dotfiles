local on_attach = require 'lang.on_attach'

local words = {}
for word in io.open(vim.fn.stdpath("config") .. "/spell/en.utf-8.add", "r"):lines() do
  table.insert(words, word)
end

-- noop on diag refresh
vim.lsp.handlers["workspace/diagnostic/refresh"] = function(_, _, ctx)
  local ok, diag = pcall(require, "vim.diagnostic")
  if ok then
    for _, c in pairs(vim.lsp.get_clients()) do
      if c.id == ctx.client_id then
        diag.reset(nil) -- noop-ish refresh
        break
      end
    end
  end
  return true
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
  -- prettier = {},
  biome = {},
  jsonls = {},
  html = {},
  cssls = {},
  bashls = {},
  sqlls = {},
  mdx_analyzer = {},
  marksman = {},
  asm_lsp = {},
  tflint = {},
  terraformls = {},
  gopls = {},
  clangd = {},
  cmake = {},
  zls = {},
  -- rustowl = {
  --   trigger = { hover = false }
  -- },
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
-- capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)
capabilities.textDocument.completion.completionItem.snippetSupport = false
capabilities.workspace = capabilities.workspace or {}
capabilities.workspace.didChangeWatchedFiles = { dynamicRegistration = true }
capabilities.workspace.diagnostic = { refreshSupport = true }
capabilities.textDocument = capabilities.textDocument or {}
capabilities.textDocument.diagnostic = { dynamicRegistration = false }

-- Set global defaults for all LSP servers
vim.lsp.config('*', {
  capabilities = capabilities,
  on_attach = on_attach,
  root_markers = { '.git' },
  flags = {
    debounce_text_changes = 150,
  }
})

-- Configure servers with custom commands or special settings
vim.lsp.config('nil_ls', {
  cmd = { 'nil' },
  filetypes = { 'nix' },
  root_markers = { 'flake.nix', '.git' },
  settings = servers['nil_ls'],
})

vim.lsp.config('biome', {
  cmd = { 'biome', 'lsp-proxy' },
  filetypes = { "javascript", "javascriptreact", "json", "jsonc", "typescript", "typescript.tsx", "typescriptreact", "astro", "svelte", "vue", "css" },
  root_markers = { 'biome.json', 'biome.jsonc', '.git' },
  settings = servers['biome'],
})

vim.lsp.config('jsonls', {
  cmd = { 'vscode-json-language-server', '--stdio' },
  filetypes = { 'json', 'jsonc' },
  settings = servers['jsonls'],
})

vim.lsp.config('html', {
  cmd = { 'vscode-html-language-server', '--stdio' },
  filetypes = { 'html', 'htm' },
  settings = servers['html'],
})

vim.lsp.config('cssls', {
  cmd = { 'vscode-css-language-server', '--stdio' },
  filetypes = { 'css', 'scss', 'less' },
})

-- ruff only has init_options, no settings
vim.lsp.config('ruff', {
  init_options = servers['ruff'].init_options,
})

-- pyright has settings nested under .settings key
vim.lsp.config('pyright', {
  settings = servers['pyright'].settings,
})

-- lua_ls settings are at top level (Lua = {...})
vim.lsp.config('lua_ls', {
  settings = servers['lua_ls'],
})

-- yamlls settings are at top level
vim.lsp.config('yamlls', {
  settings = servers['yamlls'],
})

-- Configure remaining servers with default settings
for server_name, server_config in pairs(servers) do
  -- Skip servers that were already explicitly configured above
  local configured_servers = {
    nil_ls = true, biome = true, jsonls = true, html = true, cssls = true,
    ruff = true, pyright = true, lua_ls = true, yamlls = true
  }
  
  if not configured_servers[server_name] then
    vim.lsp.config(server_name, {
      settings = server_config,
    })
  end
end

-- Enable all configured servers
local server_names = {}
for server_name, _ in pairs(servers) do
  table.insert(server_names, server_name)
end
vim.lsp.enable(server_names)

require('lang.clangd')

require('ufo').setup()
