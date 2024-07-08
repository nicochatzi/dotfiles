local function on_attach(client, bufnr)
  -- patch because i didn't the clean way to do this
  if vim.bo[bufnr].filetype == 'python' then
    vim.lsp.buf.format = function()
      vim.cmd('silent !black %')
      vim.cmd('edit!')
    end
  end

  vim.fn.sign_define("DiagnosticSignError", { texthl = "DiagnosticSignError", text = "󰅚" })
  vim.fn.sign_define("DiagnosticSignWarn", { texthl = "DiagnosticSignWarn", text = "󰀪" })
  vim.fn.sign_define("DiagnosticSignInfo", { texthl = "DiagnosticSignInfo", text = "󰋽" })
  vim.fn.sign_define("DiagnosticSignHint", { texthl = "DiagnosticSignHint", text = "󰌶" })

  vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
    virtual_text = {
      prefix = "󰄮",
    },
  })

  -- setup all the keymaps to use when LSP is attached
  local nmap = function(keys, func, desc)
    if desc then
      desc = 'LSP: ' .. desc
    end
    vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
  end

  -- See `:help K` for why this keymap
  nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
  nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')

  -- LSP functionality
  nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
  nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')
  nmap('<leader>clr', vim.lsp.codelens.refresh, '[C]ode-lens [R]refresh')
  nmap('<leader>cln', vim.lsp.codelens.run, '[C]ode-lens ru[N]')
  nmap('<leader>af', vim.lsp.buf.format, '[A]uto [F]ormat')
  nmap('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
  nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
  nmap('gR', vim.lsp.buf.references, '[G]oto [R]eferences')
  nmap('gC', vim.lsp.buf.incoming_calls, '[G]oto [C]alls')
  nmap('gI', vim.lsp.buf.implementation, '[G]oto [I]mplementation')
  nmap('<leader>D', vim.lsp.buf.type_definition, 'Type [D]efinition')
  nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
  nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
  nmap('<leader>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, '[W]orkspace [L]ist Folders')
end

local lsp = require 'lspconfig'
local configs = require 'lspconfig.configs'

configs.ltex_ls = {
  default_config = {
    cmd = { 'ltex-ls' },
    filetypes = { 'ltex', 'markdown' },
    name = 'ltex_ls',
  }
}

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
  eslint = {},
  jsonls = {},
  html = {},
  cssls = {},
  bashls = {},
  sqlls = {},
  mdx_analyzer = {},
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
  pylsp = {
    pylsp = {
      plugins = {
        flake8 = { enabled = false },
        pycodestyle = { enabled = false },
        mccabe = { enabled = false },
        autopep8 = { enabled = false },
        black = {
          enabled = true,
          executable = 'black',
        },
        pylint = {
          enabled = true,
          executable = 'pylint',
          args = {
            '--disable=missing-module-docstring',
            '--disable=missing-function-docstring',
          },
        },
      },
    },
  },
  rust_analyzer = {},
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

local server_setups = {
  ['rust-analyzer'] = function()
    require('lang.rust')(capabilities, on_attach)
  end,
  ['nil_ls'] = function()
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
