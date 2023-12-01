return {
    -- Set lualine as statusline
    'nvim-lualine/lualine.nvim',
    event = 'VeryLazy',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    -- See `:help lualine.txt`
    config = function()
        require('lualine').setup {
            options = {
                theme = 'auto',
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

        require('lualine').hide {
            place = { 'statusline', 'tabline' },
            unhide = false,
        }

        local function set_colors_for_each_hl(hl_setting, groups)
            for _, group in ipairs(groups) do
                vim.api.nvim_set_hl(0, group, hl_setting)
            end
        end

        local colors = require('config.colors')

        vim.api.nvim_set_hl(0, 'lualine_a_normal', { fg = colors.yellow, bg = colors.black })
        vim.api.nvim_set_hl(0, 'lualine_a_insert', { fg = colors.black, bg = colors.purple })
        vim.api.nvim_set_hl(0, 'lualine_a_visual', { fg = colors.black, bg = colors.teal })
        vim.api.nvim_set_hl(0, 'lualine_a_command', { fg = colors.black, bg = colors.blue })
        vim.api.nvim_set_hl(0, 'lualine_a_replace', { fg = colors.black, bg = colors.pink })
        vim.api.nvim_set_hl(0, 'lualine_a_terminal', { fg = colors.black, bg = colors.orange })

        set_colors_for_each_hl({ bg = 'none', fg = colors.teal }, {
            'lualine_b_diagnostics_hint_insert',
            'lualine_b_diagnostics_hint_normal',
            'lualine_b_diagnostics_hint_command',
            'lualine_b_diagnostics_hint_replace',
            'lualine_b_diagnostics_hint_inactive',
        })

        set_colors_for_each_hl({ bg = 'none', fg = colors.blue }, {
            'lualine_b_diagnostics_info_insert',
            'lualine_b_diagnostics_info_normal',
            'lualine_b_diagnostics_info_command',
            'lualine_b_diagnostics_info_replace',
            'lualine_b_diagnostics_info_inactive',
        })

        set_colors_for_each_hl({ bg = 'none', fg = colors.orange }, {
            'lualine_b_diagnostics_warn_insert',
            'lualine_b_diagnostics_warn_normal',
            'lualine_b_diagnostics_warn_command',
            'lualine_b_diagnostics_warn_replace',
            'lualine_b_diagnostics_warn_inactive',
        })

        set_colors_for_each_hl({ bg = 'none', fg = colors.red }, {
            'lualine_b_diagnostics_error_insert',
            'lualine_b_diagnostics_error_normal',
            'lualine_b_diagnostics_error_command',
            'lualine_b_diagnostics_error_replace',
            'lualine_b_diagnostics_error_inactive',
        })

        set_colors_for_each_hl({ bg = 'none', fg = colors.purple }, {
            'lualine_b_normal',
            'lualine_b_insert',
            'lualine_b_replace',
            'lualine_c_normal',
            'lualine_c_insert',
            'lualine_c_replace',
            'lualine_a_inactive',
            'lualine_b_inactive',
            'lualine_c_inactive',
        })
    end
}
