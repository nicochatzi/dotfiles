local M = {}

function M.setup()
  require('htz.config.keymaps')
  require('htz.config.options')
  require('htz.config.lsp')
  require('htz.config.completion')
end

return M
