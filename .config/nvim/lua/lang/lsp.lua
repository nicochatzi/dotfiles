local function on_attach(client, bufnr)
  if vim.bo[bufnr].filetype == 'nix' then
    -- Set an autocmd to format with alejandra on buffer write
    vim.api.nvim_buf_create_user_command(bufnr, 'Format', function()
      vim.cmd('silent !alejandra %')
      vim.cmd('edit!')
    end, { nargs = 0 })
  end

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

-- Enable the following language servers
local servers = {
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
        flake8 = {
          enabled = true,
          -- Black's line length
          maxLineLength = 88,
        },
        -- Disable plugins overlapping with flake8
        pycodestyle = {
          enabled = false,
        },
        mccabe = {
          enabled = false,
        },
        pyflakes = {
          enabled = false,
        },
        -- Use Black as the formatter
        autopep8 = {
          enabled = false,
        },
      },
    },
  },
  rust_analyzer = {},
  -- luau_lsp = {},
  tsserver = {},
  taplo = {},
  dockerls = {},
  nil_ls = {},
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

for server_name, server_config in pairs(servers) do
  if server_name == 'rust-analyzer' then
    require('lang.rust')(capabilities, on_attach)
  elseif server_name == 'clangd' then
    require('lang.clangd')(capabilities, on_attach)
  else
    require('lspconfig')[server_name].setup {
      capabilities = capabilities,
      on_attach = on_attach,
      settings = server_config,
    }
  end
end

require('ufo').setup()
