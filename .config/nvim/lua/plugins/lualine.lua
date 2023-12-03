local function is_git_repo()
    local git_check_handle = io.popen('git rev-parse --is-inside-work-tree 2>/dev/null')

    if not git_check_handle then
        return false
    end

    local is_in_repo = git_check_handle:read('*all')
    git_check_handle:close()

    return is_in_repo:find("true") ~= nil
end

local function get_git_diff_stats()
    if not is_git_repo() then
        return 0, 0
    end

    local handle = io.popen('git diff --numstat', 'r')
    if not handle then
        return 0, 0
    end

    local total_added, total_deleted = 0, 0
    for line in handle:lines() do
        local added, deleted = line:match('(%d+)%s+(%d+)')
        total_added = total_added + tonumber(added or 0)
        total_deleted = total_deleted + tonumber(deleted or 0)
    end
    handle:close()

    return total_added, total_deleted
end

local function git_diff_stats()
    local total_added, total_deleted = get_git_diff_stats()

    if total_added == 0 and total_deleted == 0 then
        return ''
    end

    return '%#custom_lualine_gitadded#+' .. total_added .. ' %#custom_lualine_gitremoved#-' .. total_deleted
end

return {
    -- Set lualine as statusline
    'nvim-lualine/lualine.nvim',
    event = 'VeryLazy',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    -- See `:help lualine.txt`
    config = function()
        local function sections_color(color)
            return { a = color, b = color, c = color, x = color, y = color, z = color }
        end

        local function filename(color)
            return {
                'filename',
                color = color,
                file_status = true,
                -- 0: Just the filename
                -- 1: Relative path
                -- 2: Absolute path
                -- 3: Absolute path, with tilde as the home directory
                -- 4: Filename and parent dir, with tilde as the home directory
                path = 1,
                symbols = {
                    modified = '[+]',
                    readonly = '[ro]',
                    unnamed = '[noname]',
                    newfile = '[new]',
                }
            }
        end

        local diff = {
            'diff',
            colored = true,
            diff_color = {
                added    = 'custom_lualine_gitadded',
                modified = 'custom_lualine_gitmodified',
                removed  = 'custom_lualine_gitremoved',
            },
        }

        local colors = require('config.colors')

        require('lualine').setup {
            options = {
                theme = {
                    normal = sections_color({ fg = colors.grey, bg = 'none' }),
                    insert = sections_color({ fg = colors.grey, bg = 'none' }),
                    visual = sections_color({ fg = colors.grey, bg = 'none' }),
                    replace = sections_color({ fg = colors.grey, bg = 'none' }),
                    inactive = sections_color({ fg = colors.grey, bg = 'none' }),
                },
                icons_enabled = true,
                disabled_filetypes = {
                    statusline = {},
                    winbar = { 'neo-tree' },
                },
                component_separators = { left = '|', right = '|' },
                section_separators = { left = '|', right = '|' },
                always_divide_middle = false,
            },
            sections = {
                lualine_a = {},
                lualine_b = { {
                    'branch',
                    color = { fg = colors.bblue, bg = 'none' }
                } },
                lualine_c = { git_diff_stats },
                lualine_x = { {
                    'selectioncount',
                    color = { fg = colors.blue, bg = 'none' },
                } },
                lualine_y = { {
                    'searchcount',
                    color = { fg = colors.teal, bg = 'none' },
                    maxcount = 9999,
                    timeout = 1000,
                } },
                lualine_z = { {
                    'progress',
                    color = { fg = colors.bblue, bg = 'none' },
                } },
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
                lualine_a = {
                    filename({ fg = colors.bblue, bg = 'none', gui = 'bold' }),
                },
                lualine_b = { {
                    'filesize',
                    color = { fg = colors.purple, bg = 'none' },
                } },
                lualine_c = {
                    diff,
                    'diagnostics'
                },
                lualine_x = {},
                lualine_y = {},
                lualine_z = {},
            },
            inactive_winbar = {
                lualine_a = {
                    filename({ fg = colors.grey, bg = 'none' }),
                },
                lualine_b = { {
                    'filesize',
                    color = { fg = colors.grey, bg = 'none' },
                } },
                lualine_c = {
                    diff,
                    'diagnostics'
                },
                lualine_x = {},
                lualine_y = {},
                lualine_z = {}
            }
        }

        require('lualine').hide {
            place = { 'tabline' },
            unhide = false,
        }

        vim.api.nvim_set_hl(0, 'custom_lualine_gitadded', { fg = colors.green, bg = 'none' })
        vim.api.nvim_set_hl(0, 'custom_lualine_gitmodified', { fg = colors.yellow, bg = 'none' })
        vim.api.nvim_set_hl(0, 'custom_lualine_gitremoved', { fg = colors.pink, bg = 'none' })

        local function set_colors_for_all_modes(prefix, setting)
            for _, mode in ipairs({ 'insert', 'normal', 'command', 'replace', 'inactive' }) do
                vim.api.nvim_set_hl(0, prefix .. '_' .. mode, setting)
            end
        end

        set_colors_for_all_modes('lualine_b_diagnostics_hint', {
            bg = 'none',
            fg = colors.teal,
        })

        set_colors_for_all_modes('lualine_b_diagnostics_info', {
            bg = 'none',
            fg = colors.blue,
        })

        set_colors_for_all_modes('lualine_b_diagnostics_warn', {
            bg = 'none',
            fg = colors.orange,
        })

        set_colors_for_all_modes('lualine_b_diagnostics_error', {
            bg = 'none',
            fg = colors.red,
        })
    end
}
