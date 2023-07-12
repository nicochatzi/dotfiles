return {
  {
    'simrat39/rust-tools.nvim',
    dependencies = {
      'neovim/nvim-lspconfig',
      'nvim-lua/plenary.nvim',
      'mfussenegger/nvim-dap',
    },
    ft = { 'rust', 'rs' },
  },

  {
    'Saecki/crates.nvim',
    event = { 'BufReadPre Cargo.toml' },
    dependencies = { 'nvim-lua/plenary.nvim' },
    version = 'v0.3.x',
    opts = {},
  },

  {
    'alopatindev/cargo-limit',
    ft = 'rust',
    build = 'cargo install cargo-limit nvim-send',
  },
}
