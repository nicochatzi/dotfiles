return {
  -- LSP Configuration & Plugins
  'neovim/nvim-lspconfig',
  -- event = 'VeryLazy',
  event = { 'BufReadPre', 'BufNewFile' },
  dependencies = {
    { 'williamboman/mason.nvim', config = true },
    { 'williamboman/mason-lspconfig.nvim' },
    { 'p00f/clangd_extensions.nvim' },
    { 'folke/neodev.nvim', opts = {} },
    -- good for symbolic search and referencing but it's
    -- way too busy for my taste, worth some digging
    -- at some point!
    -- {
    --     'ray-x/navigator.lua',
    --     dependencies = {
    --         { 'ray-x/guihua.lua', run = 'cd lua/fzy && make' },
    --     },
    --     config = function()
    --         require("navigator").setup({
    --             mason = true,
    --         })
    --     end,
    -- },
    {
      'j-hui/fidget.nvim',
      branch = 'legacy',
      opts = {
        window = {
          blend = 0,
          border = 'none',
        },
      },
    },
  },
  config = function()
    require('lang.lsp')
  end,
}
