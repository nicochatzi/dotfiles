return {
  'rebelot/kanagawa.nvim',
  priority = 1000,
  config = function()
    require('kanagawa').setup({
      compile = true,   -- enable compiling the colorscheme
      undercurl = true, -- enable undercurls
      commentStyle = { italic = true },
      functionStyle = {},
      keywordStyle = { italic = true },
      statementStyle = { bold = true },
      typeStyle = {},
      transparent = true,    -- do not set background color
      dimInactive = false,   -- dim inactive window `:h hl-NormalNC`
      terminalColors = true, -- define vim.g.terminal_color_{0,17}
      colors = {
        -- add/modify theme and palette colors
        palette = {},
        theme = { all = { ui = { bg = 'none', bg_gutter = 'none' } } },
      },
      theme = 'wave', -- Load 'wave' theme when 'background' option is not set
      background = {
        -- map the value of 'background' option to a theme
        dark = 'wave', -- try 'dragon' | 'wave'
        light = 'lotus'
      },
    })
    vim.cmd.colorscheme('kanagawa')

    local deep = '#346152'
    local teal = '#5faf94'
    -- vim.api.nvim_set_hl(0, 'CursorLine', { fg = '#4b5356' })
    vim.api.nvim_set_hl(0, 'Visual', { bg = '#323d3d' })
    vim.api.nvim_set_hl(0, 'FloatBorder', { bg = 'none' })
    vim.api.nvim_set_hl(0, 'WinSeparator', { fg = deep })
    vim.api.nvim_set_hl(0, 'StatusLine', { bg = 'none', fg = deep })
    vim.api.nvim_set_hl(0, 'StatusLineNc', { bg = 'none', fg = deep })
    vim.api.nvim_set_hl(0, 'TelescopeBorder', { bg = 'none', fg = deep })
    -- vim.api.nvim_set_hl(0, 'TreesitterContext', { bg = 'none', fg = deep })
    vim.api.nvim_set_hl(0, 'TelescopePromptBorder', { bg = 'none', fg = deep })
    vim.api.nvim_set_hl(0, 'TelescopeResultsBorder', { bg = 'none', fg = deep })
    vim.api.nvim_set_hl(0, 'TelescopePreviewBorder', { bg = 'none', fg = deep })
    vim.api.nvim_set_hl(0, 'TelescopePromptTitle', { fg = teal, bg = 'none' })
    vim.api.nvim_set_hl(0, 'TelescopeResultsTitle', { fg = teal, bg = 'none' })
    vim.api.nvim_set_hl(0, 'TelescopePreviewTitle', { fg = teal, bg = 'none' })
    -- vim.api.nvim_set_hl(0, 'NeoTreeTabActive', { bg = 'none' })
    vim.api.nvim_set_hl(0, 'NeoTreeTabInactive', { bg = 'none' })
  end
}
