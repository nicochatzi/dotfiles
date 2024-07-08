return {
  {
    'aca/marp.nvim',
    ft = { 'markdown', 'md' },
  },

  {
    'iamcco/markdown-preview.nvim',
    cmd = { 'MarkdownPreview', 'MarkdownPreviewToggle' },
    ft = { 'markdown', 'md' },
    build = function() vim.fn["mkdp#util#install"]() end,
  },
}
