return {
  {
    'saghen/blink.compat',
    version = '2.*',
    lazy = true,
    opts = {},
  },
  {
    'saghen/blink.cmp',
    dependencies = {
      { 'rafamadriz/friendly-snippets' },
      {
        "fang2hou/blink-copilot",
        opts = {
          max_completions = 1,
          max_attempts = 2,
        }
      }
    },
    version = '1.*',
    opts = {
      keymap = {
        preset = 'default',
        ['<C-z>'] = { 'accept', 'fallback' }
      },

      appearance = {
        nerd_font_variant = 'mono'
      },

      completion = {
        documentation = {
          auto_show = false
        },
        menu = {
          auto_show = true,
        },
        ghost_text = {
          enabled = false
        }
      },

      sources = {
        default = { 'lsp', 'path', 'snippets', 'buffer', 'copilot' },
        providers = {
          copilot = {
            name = "copilot",
            module = "blink-copilot",
            score_offset = 100,
            async = true,
            opts = {
              max_completions = 3,
              max_attempts = 2
            }
          },
        },
      },

      fuzzy = { implementation = "prefer_rust_with_warning" },
    },
    opts_extend = { "sources.default" }
  }
}
