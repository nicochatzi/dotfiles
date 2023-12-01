return {
    -- Set lualine as statusline
    'nvim-lualine/lualine.nvim',
    event = 'VeryLazy',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    -- See `:help lualine.txt`
    config = function()
        local conf = {
            options = {
                -- theme = 'auto',
                icons_enabled = true,
                disabled_filetypes = { 'neo-tree' },
                component_separators = { left = '', right = '' },
                section_separators = { left = '', right = '' },
                always_divide_middle = false,
            },
            sections = {
                lualine_a = { 'hostname' },
                lualine_b = { 'location' },
                lualine_c = {},
                lualine_x = { 'selectioncount' },
                lualine_y = { 'searchcount' },
                lualine_z = { 'filesize' },
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
                    file_status = true, -- displays file status ()
                    path = 1            -- 0 = just filename, 1 = relative path, 2 = absolute path
                } },
                lualine_b = { 'branch', 'diagnostics' },
                lualine_c = { 'filesize', 'selectioncount' },
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
        require('lualine').setup(conf)
        require('lualine').hide({
            place = { 'statusline', 'tabline' },
            unhide = false,
        })

        local colors = require('config.colors')
        local default = { bg = 'none', fg = colors.purple }

        vim.api.nvim_set_hl(0, 'lualine_b_normal', default)
        vim.api.nvim_set_hl(0, 'lualine_b_insert', default)
        vim.api.nvim_set_hl(0, 'lualine_c_normal', default)
        vim.api.nvim_set_hl(0, 'lualine_c_insert', default)
        vim.api.nvim_set_hl(0, 'lualine_x_normal', default)
        vim.api.nvim_set_hl(0, 'lualine_x_insert', default)
        vim.api.nvim_set_hl(0, 'lualine_a_inactive', default)
        vim.api.nvim_set_hl(0, 'lualine_b_inactive', default)
        vim.api.nvim_set_hl(0, 'lualine_c_inactive', default)
        vim.api.nvim_set_hl(0, 'lualine_x_inactive', default)
        vim.api.nvim_set_hl(0, 'lualine_y_inactive', default)
        vim.api.nvim_set_hl(0, 'lualine_z_inactive', default)

        vim.api.nvim_set_hl(0, 'lualine_a_normal', { fg = colors.yellow, bg = colors.black })
        vim.api.nvim_set_hl(0, 'lualine_a_insert', { fg = '#282a2e', bg = colors.purple })
        vim.api.nvim_set_hl(0, 'lualine_a_visual', { fg = '#282a2e', bg = colors.teal })
        vim.api.nvim_set_hl(0, 'lualine_a_command', { fg = '#282a2e', bg = colors.blue })
        vim.api.nvim_set_hl(0, 'lualine_a_replace', { fg = '#282a2e', bg = colors.pink })
        vim.api.nvim_set_hl(0, 'lualine_a_terminal', { fg = '#282a2e', bg = colors.orange })

        vim.api.nvim_set_hl(0, 'lualine_transitional_lualine_a_insert_to_lualine_b_insert', default)
        vim.api.nvim_set_hl(0, 'lualine_transitional_lualine_a_normal_to_lualine_b_normal', default)
        vim.api.nvim_set_hl(0, 'lualine_transitional_lualine_a_visual_to_lualine_b_visual', default)
        vim.api.nvim_set_hl(0, 'lualine_transitional_lualine_b_insert_to_lualine_c_normal', default)
        vim.api.nvim_set_hl(0, 'lualine_transitional_lualine_b_command_to_lualine_c_normal', default)
        vim.api.nvim_set_hl(0, 'lualine_transitional_lualine_b_normal_to_lualine_c_normal', default)
    end
}
