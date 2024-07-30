return {
  {
    'rmagatti/auto-session',
    dependencies = {
      'nvim-telescope/telescope.nvim',
    },
    config = function()
      require('auto-session').setup {
        auto_save_enabled = true,
        auto_restore_enabled = true,
        auto_restore_lazy_delay_enabled = false,
        auto_session_use_git_branch = true,
        auto_session_suppress_dirs = { '~/', '~/Projects', '~/Downloads', '/', },
        pre_save_cmds = { "Neotree close" },
        -- save_extra_cmds = { "Neotree toggle" },
        -- post_restore_cmds = { "Neotree toggle" },
      }
    end,
  },

  {
    'rmagatti/session-lens',
    dependencies = {
      'nvim-telescope/telescope.nvim',
      'rmagatti/auto-session',
    },
    config = function()
      require('session-lens').setup {
        theme = 'ivy',
        theme_conf = { border = true },
        previewer = true
      }
    end
  },
}
