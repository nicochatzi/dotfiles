return {
  {
    'rmagatti/auto-session',
    dependencies = {
      'nvim-telescope/telescope.nvim',
    },
    opts = {
      auto_save = true,
      auto_restore = true,
      auto_restore_last_session = false,
      use_git_branch = true,
      suppressed_dirs = { '~/', '~/Projects', '~/Downloads', '/', },
      pre_save_cmds = { "Neotree close" },
      -- save_extra_cmds = { "Neotree toggle" },
      -- post_restore_cmds = { "Neotree toggle" },
    }
  },

  {
    'rmagatti/session-lens',
    dependencies = {
      'nvim-telescope/telescope.nvim',
      'rmagatti/auto-session',
    },
    opts = {
      theme = 'ivy',
      theme_conf = { border = true },
      previewer = true
    }
  },
}
