return {
  -- Autocompletion
  'hrsh7th/nvim-cmp',
  -- event = 'InsertEnter',
  dependencies = {
    { 'hrsh7th/cmp-nvim-lsp', },
    { 'hrsh7th/cmp-nvim-lsp-signature-help', },
    { 'hrsh7th/cmp-path', },
    { 'hrsh7th/cmp-buffer', },
    { 'hrsh7th/cmp-nvim-lua', },
    -- { 'hrsh7th/vim-vsnip', },
  },
  config = function()
  end
}
