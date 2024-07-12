return function(client, bufnr)
  if client.name == "pyright" then
    client.server_capabilities.documentFormattingProvider = true
    vim.lsp.buf.format = function()
      bufnr = bufnr or vim.api.nvim_get_current_buf()
      local file_path = vim.api.nvim_buf_get_name(bufnr)

      vim.fn.system(string.format("isort %s", file_path))
      local cmd = string.format("autopep8 --in-place --aggressive --aggressive %s", file_path)
      local output = vim.fn.system(cmd)
      if vim.v.shell_error ~= 0 then
        print("Error running autopep8:", output)
        return
      end
      vim.cmd("checktime")
    end
  end

  -- inlay hints on by default
  if client.server_capabilities.inlayHintProvider then
    vim.lsp.inlay_hint.enable()
  end

  -- refresh codelens on buffer enter
  if client.server_capabilities.codeLensProvider then
    vim.api.nvim_create_autocmd({ "BufEnter" }, {
      buffer = bufnr,
      callback = vim.lsp.codelens.refresh,
    })
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
