return function(client, bufnr)
  if client.name == 'ruff' then
    client.server_capabilities.hoverProvider = false
  end

  if client.name == 'biome' then
    client.server_capabilities.renameProvider = nil
    client.server_capabilities.definitionProvider = nil
    client.server_capabilities.referencesProvider = nil
    client.server_capabilities.hoverProvider = nil
    client.server_capabilities.implementationProvider = nil
    client.server_capabilities.typeDefinitionProvider = nil
    client.server_capabilities.signatureHelpProvider = nil
    client.server_capabilities.completionProvider = nil
  end

  if client.name == 'ts_ls' or client.name == 'tsserver' then
    client.server_capabilities.documentFormattingProvider = false
    client.server_capabilities.documentRangeFormattingProvider = false
  end

  -- inlay hints on by default
  -- if client.server_capabilities.inlayHintProvider then
  --   vim.lsp.inlay_hint.enable()
  -- end

  -- refresh codelens on buffer enter
  -- if client.server_capabilities.codeLensProvider then
  --   vim.api.nvim_create_autocmd({ "BufEnter" }, {
  --     buffer = bufnr,
  --     callback = vim.lsp.codelens.refresh,
  --   })
  -- end

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
  nmap('<leader>ca', ':Lspsaga code_action<CR>', '[C]ode [A]ction')
  nmap('<leader>clr', vim.lsp.codelens.refresh, '[C]ode-lens [R]refresh')
  nmap('<leader>cln', vim.lsp.codelens.run, '[C]ode-lens ru[N]')
  nmap('<leader>cli', ':Lspsaga incoming_calls<CR>', '[C]al[l]l [I]ncoming')
  nmap('<leader>clo', ':Lspsaga outgoing_calls<CR>', '[C]al[l]l [O]utgoing')
  nmap('<leader>cs', vim.lsp.buf.format, '[C]ode [S]tyle: auto-format')
  nmap('<leader>ih', function() vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled()) end,
    'Toggle [I]nlay [H]ints')
  nmap('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
  nmap('gD', vim.lsp.buf.type_definition, '[G]oto [T]ype [D]efinition')
  -- nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
  nmap('gR', vim.lsp.buf.references, '[G]oto [R]eferences')
  nmap('gC', vim.lsp.buf.incoming_calls, '[G]oto [C]alls')
  nmap('gI', vim.lsp.buf.implementation, '[G]oto [I]mplementation')
  nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
  nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
  nmap('<leader>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, '[W]orkspace [L]ist Folders')
end
