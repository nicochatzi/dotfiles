return {
  {
    'rmagatti/auto-session',
    dependencies = {
      'nvim-telescope/telescope.nvim',
    },
    config = function()
      require('auto-session').setup {
        auto_session_suppress_dirs = { '~/', '~/Projects', '~/Downloads', '/' },
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
