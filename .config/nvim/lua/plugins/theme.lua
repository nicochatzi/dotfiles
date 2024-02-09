local colors = require('config.colors')

-- local dark = '#323d3d'
-- local deep = '#346152'
-- local light = teal

local dark = colors.black
local deep = colors.grey
local light = colors.purple

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
      vim.api.nvim_set_hl(0, 'CursorLine', { fg = light, bg = dark })
      -- vim.api.nvim_set_hl(0, 'LineNr', { fg = light, bg = 'none' })
      vim.api.nvim_set_hl(0, 'CursorLineNr', { fg = colors.yellow, bg = 'none' })
      vim.api.nvim_set_hl(0, 'CursorLine', { fg = 'none' })
      vim.api.nvim_set_hl(0, 'TelescopeSelection', { bg = dark, fg = 'none' })
      vim.api.nvim_set_hl(0, 'NeoTreeCursorLine', { bg = dark, fg = 'none' })

      -- vim.api.nvim_set_hl(0, 'Search', { bg = colors.purple, fg = colors.black })
      -- vim.api.nvim_set_hl(0, 'CurSearch', { bg = colors.purple, fg = colors.black })
      -- vim.api.nvim_set_hl(0, 'IncSearch', { bg = colors.purple, fg = colors.black })

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
    end,
  },
}
