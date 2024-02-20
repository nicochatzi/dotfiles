local extension_path = vim.env.HOME .. '/.local/share/nvim/mason/packages/codelldb/extension/'

return {
  codelldb_path = extension_path .. 'adapter/codelldb',
  liblldb_path = extension_path .. 'lldb/lib/liblldb.dylib'
}
