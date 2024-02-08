return {
  {
    'aca/marp.nvim',
    ft = { 'markdown', 'md' },
  },

  {
    'iamcco/markdown-preview.nvim',
    cmd = { 'MarkdownPreviewToggle' },
    ft = { 'markdown', 'md' },
    build = function()
      vim.fn['cd app && npx --yes yarn install']()
    end,
  },
}
