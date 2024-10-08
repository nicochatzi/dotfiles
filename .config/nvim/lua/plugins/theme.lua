local colors = require('config.colors')

return {
  {
    -- display colors in code
    'norcalli/nvim-colorizer.lua',
    event = 'VeryLazy',
    config = function()
      require('colorizer').setup {
        '*',                      -- Highlight all files, but customize some others.
        css = { rgb_fn = true },  -- Enable parsing rgb(...) functions in css.
        html = { names = false }, -- Disable parsing "names" like Blue or Gray
      }
    end,
  },

  {
    -- bracket colorization
    'HiPhish/rainbow-delimiters.nvim',
    event = 'VeryLazy',
    config = function()
      vim.api.nvim_set_hl(0, 'RainbowDelimiterA', { fg = colors.teal, bg = 'none' })
      vim.api.nvim_set_hl(0, 'RainbowDelimiterB', { fg = colors.purple, bg = 'none' })
      vim.api.nvim_set_hl(0, 'RainbowDelimiterC', { fg = colors.blue, bg = 'none' })
      vim.api.nvim_set_hl(0, 'RainbowDelimiterD', { fg = colors.pink, bg = 'none' })
      require('rainbow-delimiters.setup').setup {
        highlight = {
          'RainbowDelimiterA',
          'RainbowDelimiterB',
          'RainbowDelimiterC',
          'RainbowDelimiterD',
        },
      }
    end,
  },

  {
    'rebelot/kanagawa.nvim',
    priority = 1000,
    config = function()
      require('kanagawa').setup {
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
          light = 'lotus',
        },
      }

      require('config.theme')

      -- cursor line highlights
      vim.api.nvim_set_hl(0, 'CursorLine', { fg = colors.light, bg = colors.dark })
      -- vim.api.nvim_set_hl(0, 'LineNr', { fg = colors.light, bg = 'none' })
      vim.api.nvim_set_hl(0, 'CursorLineNr', { fg = colors.yellow, bg = 'none' })
      vim.api.nvim_set_hl(0, 'CursorLine', { fg = 'none' })
      vim.api.nvim_set_hl(0, 'TelescopeSelection', { bg = colors.dark, fg = 'none' })
      vim.api.nvim_set_hl(0, 'NeoTreeCursorLine', { bg = colors.dark, fg = 'none' })

      -- vim.api.nvim_set_hl(0, 'Search', { bg = colors.purple, fg = colors.black })
      -- vim.api.nvim_set_hl(0, 'CurSearch', { bg = colors.purple, fg = colors.black })
      -- vim.api.nvim_set_hl(0, 'IncSearch', { bg = colors.purple, fg = colors.black })

      vim.api.nvim_set_hl(0, 'Visual', { bg = colors.deep })
      vim.api.nvim_set_hl(0, 'FloatBorder', { bg = 'none', fg = colors.deep })
      vim.api.nvim_set_hl(0, 'WinSeparator', { fg = colors.deep })
      vim.api.nvim_set_hl(0, 'StatusLine', { bg = 'none', fg = colors.deep })
      vim.api.nvim_set_hl(0, 'StatusLineNc', { bg = 'none', fg = colors.deep })
      vim.api.nvim_set_hl(0, 'TelescopeBorder', { bg = 'none', fg = colors.deep })
      -- vim.api.nvim_set_hl(0, 'TreesitterContext', { bg = 'none', fg = colors.deep })
      vim.api.nvim_set_hl(0, 'TelescopePromptBorder', { bg = 'none', fg = colors.deep })
      vim.api.nvim_set_hl(0, 'TelescopeResultsBorder', { bg = 'none', fg = colors.deep })
      vim.api.nvim_set_hl(0, 'TelescopePreviewBorder', { bg = 'none', fg = colors.deep })
      vim.api.nvim_set_hl(0, 'TelescopePromptTitle', { fg = colors.light, bg = 'none' })
      vim.api.nvim_set_hl(0, 'TelescopeResultsTitle', { fg = colors.light, bg = 'none' })
      vim.api.nvim_set_hl(0, 'TelescopePreviewTitle', { fg = colors.light, bg = 'none' })
      -- vim.api.nvim_set_hl(0, 'NeoTreeTabActive', { bg = 'none' })
      vim.api.nvim_set_hl(0, 'NeoTreeTabInactive', { bg = 'none' })

      vim.api.nvim_set_hl(0, 'GitGraphHash', { bg = 'none', fg = colors.teal })
      vim.api.nvim_set_hl(0, 'GitGraphTimestamp', { bg = 'none', fg = colors.green })
      vim.api.nvim_set_hl(0, 'GitGraphAuthor', { bg = 'none', fg = colors.bblue })
      vim.api.nvim_set_hl(0, 'GitGraphBranchName', { bg = 'none', fg = colors.red })
      vim.api.nvim_set_hl(0, 'GitGraphBranchTag', { bg = 'none', fg = colors.pink })
      vim.api.nvim_set_hl(0, 'GitGraphBranchMsg', { bg = 'none', fg = colors.orange })
    end,
  },
}
