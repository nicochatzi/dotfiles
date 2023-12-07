local function is_git_repo()
  local git_check_handle = io.popen('git rev-parse --is-inside-work-tree 2>/dev/null')
  if not git_check_handle then return false end

  local is_in_repo = git_check_handle:read('*all')
  git_check_handle:close()

  return is_in_repo:find("true") ~= nil
end

local function project_git_diff()
  local total = { added = 0, modified = 0, removed = 0 }

  if not is_git_repo() then return total end

  local handle = io.popen('git diff --numstat', 'r')
  if not handle then return nil end

  for line in handle:lines() do
    local added, removed = line:match('(%d+)%s+(%d+)')
    total.added = total.added + tonumber(added or 0)
    total.removed = total.removed + tonumber(removed or 0)
  end
  handle:close()

  return total
end

local function buffer_based_git_diff()
  local status = vim.b.gitsigns_status_dict
  if not status then return '' end

  local diff_str = ''

  if status.added and status.added > 0 then
    diff_str = diff_str .. "%#custom_lualine_gitadded#" .. string.format('+%d ', status.added)
  end
  if status.changed and status.changed > 0 then
    diff_str = diff_str .. "%#custom_lualine_gitmodified#" .. string.format('~%d ', status.changed)
  end
  if status.removed and status.removed > 0 then
    diff_str = diff_str .. "%#custom_lualine_gitremoved#" .. string.format('-%d ', status.removed)
  end

  return diff_str
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
        lualine_c = {
          {
            'diff',
            colored = true,
            diff_color = {
              added    = 'custom_lualine_gitadded',
              modified = 'custom_lualine_gitmodified',
              removed  = 'custom_lualine_gitremoved',
            },
            source = project_git_diff,
          },
        },
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
          buffer_based_git_diff,
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
          buffer_based_git_diff,
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
