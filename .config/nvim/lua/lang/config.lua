local on_attach = require 'lang.on_attach'

local function exepath_or(name)
  local resolved = vim.fn.exepath(name)
  if resolved ~= nil and resolved ~= '' then
    return resolved
  end
  return name
end

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
  eslint = {
    validate = 'on',
    packageManager = 'npm',
    useESLintClass = false,
    codeActionOnSave = {
      enable = false,
      mode = 'all',
    },
    format = true,
    quiet = false,
    onIgnoredFiles = 'off',
    rulesCustomizations = {},
    run = 'onType',
    problems = {
      shortenToSingleLine = false,
    },
    nodePath = '',
    workingDirectory = {
      mode = 'location',
    },
  },
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
  tsserver = {
    typescript = {
      inlayHints = {
        includeInlayParameterNameHints = 'all',
        includeInlayParameterNameHintsWhenArgumentMatchesName = false,
        includeInlayFunctionParameterTypeHints = true,
        includeInlayVariableTypeHints = true,
        includeInlayPropertyDeclarationTypeHints = true,
        includeInlayFunctionLikeReturnTypeHints = true,
        includeInlayEnumMemberValueHints = true,
      },
    },
    javascript = {
      inlayHints = {
        includeInlayParameterNameHints = 'all',
        includeInlayParameterNameHintsWhenArgumentMatchesName = false,
        includeInlayFunctionParameterTypeHints = true,
        includeInlayVariableTypeHints = true,
        includeInlayPropertyDeclarationTypeHints = true,
        includeInlayFunctionLikeReturnTypeHints = true,
        includeInlayEnumMemberValueHints = true,
      },
    },
  },
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

-- Configure diagnostic signs (do this once, not in on_attach)
vim.diagnostic.config({
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = "󰅚",
      [vim.diagnostic.severity.WARN] = "󰀪",
      [vim.diagnostic.severity.INFO] = "󰋽",
      [vim.diagnostic.severity.HINT] = "󰌶",
    },
  },
  virtual_text = {
    prefix = "󰄮",
  },
})

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
  cmd = { exepath_or('nil') },
  filetypes = { 'nix' },
  root_markers = { 'flake.nix', '.git' },
  settings = servers['nil_ls'],
})

vim.lsp.config('biome', {
  -- cmd = { exepath_or('biome'), 'lsp-proxy' },
  filetypes = { 'javascript', 'javascriptreact', 'typescript', 'typescriptreact', 'json', 'jsonc', 'astro', 'svelte', 'vue', 'css' },
  root_markers = { 'biome.json', 'biome.jsonc' },
  settings = servers['biome'],
})

vim.lsp.config('eslint', {
  cmd = { exepath_or('vscode-eslint-language-server'), '--stdio' },
  filetypes = { 'javascript', 'javascriptreact', 'typescript', 'typescriptreact', 'vue', 'astro', 'svelte' },
  root_markers = { '.eslintrc', '.eslintrc.js', '.eslintrc.cjs', '.eslintrc.yaml', '.eslintrc.yml', '.eslintrc.json', 'eslint.config.js', 'eslint.config.mjs' },
  settings = {
    eslint = servers['eslint']
  },
})

vim.lsp.config('jsonls', {
  cmd = { exepath_or('vscode-json-language-server'), '--stdio' },
  filetypes = { 'json', 'jsonc' },
  settings = servers['jsonls'],
})

vim.lsp.config('html', {
  cmd = { exepath_or('vscode-html-language-server'), '--stdio' },
  filetypes = { 'html', 'htm' },
  settings = servers['html'],
})

vim.lsp.config('cssls', {
  cmd = { exepath_or('vscode-css-language-server'), '--stdio' },
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

vim.lsp.config('tsserver', {
  cmd = { exepath_or('typescript-language-server'), '--stdio' },
  filetypes = { 'javascript', 'javascriptreact', 'typescript', 'typescriptreact' },
  root_dir = vim.fs.root(0, { 'package.json', 'tsconfig.json', 'jsconfig.json', '.git' }),
  settings = servers['tsserver'],
})

-- Configure remaining servers with default settings
for server_name, server_config in pairs(servers) do
  -- Skip servers that were already explicitly configured above
  local configured_servers = {
    nil_ls = true,
    biome = true,
    jsonls = true,
    html = true,
    cssls = true,
    ruff = true,
    pyright = true,
    lua_ls = true,
    yamlls = true,
    tsserver = true,
    eslint = true
  }

  if not configured_servers[server_name] then
    vim.lsp.config(server_name, {
      settings = server_config,
    })
  end
end

-- Enable all configured servers
local server_names = vim.tbl_keys(servers)
table.sort(server_names)
vim.lsp.enable(server_names)

require('lang.clangd')

require('ufo').setup()
