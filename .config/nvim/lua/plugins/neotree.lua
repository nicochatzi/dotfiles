return {
  'nvim-neo-tree/neo-tree.nvim',
  branch = 'v3.x',
  cmd = { 'Neotree' },
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons',
    'MunifTanjim/nui.nvim',
    'mrbjarksen/neo-tree-diagnostics.nvim',
    { dir = '/home/nico/.config/nvim/plugins/neo-tree-dependencies.nvim' },
  },
  opts = {
    default_component_configs = {
      container = {
        enable_character_fade = false
      },
      file_size = {
        enabled = true,
        required_width = 50,
      },
      symlink_target = {
        enabled = true,
        required_width = 80,
      },
    },
    event_handlers = {
      {
        event = 'neo_tree_buffer_enter',
        handler = function()
          vim.cmd([[
          setlocal relativenumber
        ]])
        end,
      },
    },
    popup_border_style = 'rounded',
    close_if_last_window = true,
    use_libuv_file_watcher = true,
    sources = {
      'filesystem',
      'git_status',
      'document_symbols',
      'diagnostics',
      'dependencies',
    },
    window = {
      position = 'right',
      width = 30,
      mappings = {
        ['s'] = 'open_split',
        ['v'] = 'open_vsplit',
        ['<C-s>'] = 'split_with_window_picker',
        ['<C-v>'] = 'vsplit_with_window_picker',
        ['a'] = {
          'add',
          config = {
            show_path = 'relative', -- 'none', 'relative', 'absolute'
          },
        },
        ['c'] = {
          'copy',
          config = {
            show_path = 'relative', -- 'none', 'relative', 'absolute'
          },
        },
        ['m'] = {
          'move',
          config = {
            show_path = 'relative', -- 'none', 'relative', 'absolute'
          },
        },
        ['Y'] = function(state)
          local node = state.tree:get_node()
          local content = node.path
          -- relative
          -- local content = node.path:gsub(state.path, ""):sub(2)
          vim.fn.setreg('"', content)
          vim.fn.setreg('1', content)
          vim.fn.setreg('+', content)
        end,
      },
      popup = {
        position = '50%',
        size = {
          height = '80%',
          width = '100%',
        },
      },
    },
    source_selector = {
      winbar = true,
      statusline = false,
      sources = {
        { source = 'filesystem', display_name = '  ' },
        { source = 'git_status', display_name = '  ' },
        { source = 'document_symbols', display_name = '  ' },
        { source = 'diagnostics', display_name = '  ' },
        { source = 'dependencies', display_name = '  ' },
      },
    },
    filesystem = {
      filtered_items = {
        visible = true,
        hide_dotfiles = false,
        hide_gitignored = false,
        hide_hidden = false,
      },
      follow_current_file = {
        enabled = true,
        leave_files_open = true,
      },
    },
    buffers = {
      follow_current_file = {
        enabled = true,
        leave_files_open = true,
      },
    },
    diagnostics = {
      auto_preview = {
        -- May also be set to `true`
        enabled = false,                 -- Whether to automatically enable preview mode
        preview_config = {},             -- Config table to pass to auto preview (for example `{ use_float = true }`)
        event = 'neo_tree_buffer_enter', -- The event to enable auto preview upon (for example `'neo_tree_window_after_open'`)
      },
      bind_to_cwd = true,
      diag_sort_function = 'severity', -- 'severity' means diagnostic items are sorted by severity in addition to their positions.
      -- 'position' means diagnostic items are sorted strictly by their positions.
      -- May also be a function.
      follow_current_file = {
        enabled = true,
        leave_files_open = true,
      },
      group_dirs_and_files = true,        -- when true, empty folders and files will be grouped together
      group_empty_dirs = true,            -- when true, empty directories will be grouped together
      show_unloaded = true,               -- show diagnostics from unloaded buffers
      refresh = {
        delay = 100,                      -- Time (in ms) to wait before updating diagnostics. Might resolve some issues with Neovim hanging.
        event = 'vim_diagnostic_changed', -- Event to use for updating diagnostics (for example `'neo_tree_buffer_enter'`)
        -- Set to `false` or `'none'` to disable automatic refreshing
        max_items = false,                -- The maximum number of diagnostic items to attempt processing
        -- Set to `false` for no maximum
      },
    },
    document_symbols = {
      follow_cursor = true,
      client_filters = "first",
      kinds = {
        Unknown = { icon = "?", hl = "" },
        Root = { icon = "", hl = "NeoTreeRootName" },
        File = { icon = "󰈙", hl = "Tag" },
        Module = { icon = "", hl = "Exception" },
        Namespace = { icon = "󰌗", hl = "Include" },
        Package = { icon = "󰏖", hl = "Label" },
        Class = { icon = "󰌗", hl = "Include" },
        Method = { icon = "", hl = "Function" },
        Property = { icon = "󰆧", hl = "@property" },
        Field = { icon = "", hl = "@field" },
        Constructor = { icon = "", hl = "@constructor" },
        Enum = { icon = "󰒻", hl = "@number" },
        Interface = { icon = "", hl = "Type" },
        Function = { icon = "󰊕", hl = "Function" },
        Variable = { icon = "", hl = "@variable" },
        Constant = { icon = "", hl = "Constant" },
        String = { icon = "󰀬", hl = "String" },
        Number = { icon = "󰎠", hl = "Number" },
        Boolean = { icon = "", hl = "Boolean" },
        Array = { icon = "󰅪", hl = "Type" },
        Object = { icon = "󰅩", hl = "Type" },
        Key = { icon = "󰌋", hl = "" },
        Null = { icon = "", hl = "Constant" },
        EnumMember = { icon = "", hl = "Number" },
        Struct = { icon = "󰌗", hl = "Type" },
        Event = { icon = "", hl = "Constant" },
        Operator = { icon = "󰆕", hl = "Operator" },
        TypeParameter = { icon = "󰊄", hl = "Type" },

        -- ccls
        -- TypeAlias = { icon = ' ', hl = 'Type' },
        -- Parameter = { icon = ' ', hl = '@parameter' },
        -- StaticMethod = { icon = '󰠄 ', hl = 'Function' },
        -- Macro = { icon = ' ', hl = 'Macro' },
      }
    },
    dependencies = {
      bind_to_cwd = true,
      follow_current_file = {
        enabled = true,
        leave_files_open = true,
      },
    }
  },
}
