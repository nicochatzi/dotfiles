return {
  -- Set lualine as statusline
  'nvim-lualine/lualine.nvim',
  event = 'VeryLazy',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  -- See `:help lualine.txt`
  config = function()
    local config = {
      options = {
        theme = 'auto',
        icons_enabled = true,
        disabled_filetypes = { 'neo-tree' },
        component_separators = { left = '', right = '' },
        section_separators = { left = '|', right = '|' },
        always_divide_middle = false,
      },
      sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = {},
        lualine_x = {},
        lualine_y = {},
        lualine_z = {},
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = {},
        lualine_x = {},
        lualine_y = {},
        lualine_z = {},
      },
      winbar = {
        lualine_a = { {
          'filename',
          file_status = true, -- displays file status (readonly status, modified status)
          path = 1            -- 0 = just filename, 1 = relative path, 2 = absolute path
        } },
        lualine_b = { 'branch', 'diagnostics' },
        lualine_c = {},
        lualine_x = {},
        lualine_y = {},
        lualine_z = {},
      },
      inactive_winbar = {
        lualine_a = {},
        lualine_b = { {
          'filename',
          file_status = true, -- displays file status (readonly status, modified status)
          path = 1            -- 0 = just filename, 1 = relative path, 2 = absolute path
        }, 'diagnostics' },
        lualine_c = {},
        lualine_x = {},
        lualine_y = {},
        lualine_z = {}
      }
    }
    require('lualine').setup(config)
    require('lualine').hide({
      place = { 'statusline', 'tabline' }, -- The segment this change applies to.
      unhide = false,           -- whether to re-enable lualine again/
    })
    -- hack to remove lualine background
    vim.api.nvim_set_hl(0, 'lualine_b_normal', { bg = 'none' })
    vim.api.nvim_set_hl(0, 'lualine_c_normal', { bg = 'none' })
    vim.api.nvim_set_hl(0, 'lualine_c_insert', { bg = 'none' })
    vim.api.nvim_set_hl(0, 'lualine_x_normal', { bg = 'none' })
    vim.api.nvim_set_hl(0, 'lualine_x_insert', { bg = 'none' })
    vim.api.nvim_set_hl(0, 'lualine_a_inactive', { bg = 'none' })
    vim.api.nvim_set_hl(0, 'lualine_b_inactive', { bg = 'none' })
    vim.api.nvim_set_hl(0, 'lualine_c_inactive', { bg = 'none' })
    vim.api.nvim_set_hl(0, 'lualine_x_inactive', { bg = 'none' })
    vim.api.nvim_set_hl(0, 'lualine_y_inactive', { bg = 'none' })
    vim.api.nvim_set_hl(0, 'lualine_z_inactive', { bg = 'none' })
    vim.api.nvim_set_hl(0, 'lualine_a_normal', { fg = '#282a2e', bg = '#81a2be' })
    vim.api.nvim_set_hl(0, 'lualine_a_insert', { fg = '#282a2e', bg = '#b5bd68' })
    vim.api.nvim_set_hl(0, 'lualine_a_visual', { fg = '#282a2e', bg = '#b294bb' })
    vim.api.nvim_set_hl(0, 'lualine_a_command', { fg = '#282a2e', bg = '#81a2be' })
    vim.api.nvim_set_hl(0, 'lualine_a_replace', { fg = '#282a2e', bg = '#de935f' })
    vim.api.nvim_set_hl(0, 'lualine_a_terminal', { fg = '#282a2e', bg = '#b5bd68' })
  end
}
