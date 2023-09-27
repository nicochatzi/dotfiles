local function config_completion()
  local cmp = require('cmp')

  cmp.setup {
    snippet = {
      expand = function(args)
        -- vim.fn["vsnip#anonymous"](args.body)
      end,
    },
    mapping = cmp.mapping.preset.insert {
      ['<C-n>'] = cmp.mapping.select_next_item(),
      ['<C-p>'] = cmp.mapping.select_prev_item(),
      -- ['<C-d>'] = cmp.mapping.scroll_docs(-4),
      -- ['<C-f>'] = cmp.mapping.scroll_docs(4),
      ['<C-Space>'] = cmp.mapping.complete(),
      ['<Tab>'] = cmp.mapping.confirm {
        behavior = cmp.ConfirmBehavior.Replace,
        select = true,
      },
      -- ['<Tab>'] = cmp.mapping(function(fallback)
      --   if cmp.visible() then
      --     cmp.select_next_item()
      --   else
      --     fallback()
      --   end
      -- end, { 'i', 's' }),
      -- ['<S-Tab>'] = cmp.mapping(function(fallback)
      --   if cmp.visible() then
      --     cmp.select_prev_item()
      --   else
      --     fallback()
      --   end
      -- end, { 'i', 's' }),
    },
    sources = {
      { name = 'path' },                                       -- file paths
      { name = "copilot",                group_index = 2 },
      { name = 'nvim_lsp',               keyword_length = 1 }, -- from language server
      { name = 'nvim_lsp_signature_help' },                    -- display function signatures with current parameter emphasized
      { name = 'nvim_lua',               keyword_length = 2 }, -- complete neovim's Lua runtime API such vim.lsp.*
      { name = 'buffer',                 keyword_length = 1 }, -- source current buffer
      -- { name = 'vsnip',                  keyword_length = 2 },   -- nvim-cmp source for vim-vsnip
      -- { name = 'calc' },                                         -- source for math calculation
      { name = "crates" },
    },
    window = {
      completion = cmp.config.window.bordered(),
      documentation = cmp.config.window.bordered(),
    },
    sorting = {
      comparators = {
        cmp.config.compare.offset,
        cmp.config.compare.exact,
        cmp.config.compare.recently_used,
        require("clangd_extensions.cmp_scores"),
        cmp.config.compare.kind,
        cmp.config.compare.sort_text,
        cmp.config.compare.length,
        cmp.config.compare.order,
      },
    },
  }
end

return {
  -- Autocompletion
  'hrsh7th/nvim-cmp',
  event = 'VeryLazy',
  dependencies = {
    { 'hrsh7th/cmp-nvim-lsp', },
    { 'hrsh7th/cmp-nvim-lsp-signature-help', },
    { 'hrsh7th/cmp-path', },
    { 'hrsh7th/cmp-buffer', },
    { 'hrsh7th/cmp-nvim-lua', },
    -- { 'hrsh7th/vim-vsnip', },
  },
  config = config_completion
}
