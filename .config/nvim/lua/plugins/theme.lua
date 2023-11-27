return {
  {
     -- display colors in code
    'norcalli/nvim-colorizer.lua',
    config = function()
        require 'colorizer'.setup {
          '*'; -- Highlight all files, but customize some others.
          css = { rgb_fn = true; }; -- Enable parsing rgb(...) functions in css.
          html = { names = false; } -- Disable parsing "names" like Blue or Gray
        }
    end
  },

  {
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
      -- vim.cmd.colorscheme('kanagawa-lotus')
      vim.cmd.colorscheme('kanagawa')

      -- local dark = '#323d3d'
      -- local deep = '#346152'
      -- local light = '#5faf94'

      local dark = '#2a2a37'
      local deep = '#54546d'
      local light = '#947fb8'

      -- cursor line highlights
      vim.api.nvim_set_hl(0, 'CursorLine', { fg = light, bg = dark })
      -- vim.api.nvim_set_hl(0, 'LineNr', { fg = light, bg = 'none' })
      vim.api.nvim_set_hl(0, 'CursorLineNr', { fg = light, bg = 'none' })
      vim.api.nvim_set_hl(0, 'CursorLine', { fg = 'none' })
      vim.api.nvim_set_hl(0, 'TelescopeSelection', { bg = dark, fg = 'none' })
      vim.api.nvim_set_hl(0, 'NeoTreeCursorLine', { bg = dark, fg = 'none' })

      vim.api.nvim_set_hl(0, 'Visual', { bg = dark })
      vim.api.nvim_set_hl(0, 'FloatBorder', { bg = 'none', fg = deep })
      vim.api.nvim_set_hl(0, 'WinSeparator', { fg = deep })
      vim.api.nvim_set_hl(0, 'StatusLine', { bg = 'none', fg = deep })
      vim.api.nvim_set_hl(0, 'StatusLineNc', { bg = 'none', fg = deep })
      vim.api.nvim_set_hl(0, 'TelescopeBorder', { bg = 'none', fg = deep })
      -- vim.api.nvim_set_hl(0, 'TreesitterContext', { bg = 'none', fg = deep })
      vim.api.nvim_set_hl(0, 'TelescopePromptBorder', { bg = 'none', fg = deep })
      vim.api.nvim_set_hl(0, 'TelescopeResultsBorder', { bg = 'none', fg = deep })
      vim.api.nvim_set_hl(0, 'TelescopePreviewBorder', { bg = 'none', fg = deep })
      vim.api.nvim_set_hl(0, 'TelescopePromptTitle', { fg = light, bg = 'none' })
      vim.api.nvim_set_hl(0, 'TelescopeResultsTitle', { fg = light, bg = 'none' })
      vim.api.nvim_set_hl(0, 'TelescopePreviewTitle', { fg = light, bg = 'none' })
      -- vim.api.nvim_set_hl(0, 'NeoTreeTabActive', { bg = 'none' })
      vim.api.nvim_set_hl(0, 'NeoTreeTabInactive', { bg = 'none' })
    end
  },
}
