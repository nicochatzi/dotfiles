local home = vim.fn.expand('~')
local obsidian_vault_path
-- on macOS
if string.match(home, "^/Users") then
  obsidian_vault_path = home .. '/Library/Mobile Documents/iCloud~md~obsidian/Documents/htz'
else
  obsidian_vault_path = home .. '/obsidian'
end

-- only set conceallevel if we're in the obsidian_vault_path
vim.api.nvim_create_augroup('ObsidianDirectory', { clear = true })
vim.api.nvim_create_autocmd('FileType', {
  group = 'ObsidianDirectory',
  pattern = 'markdown',
  callback = function()
    if vim.fn.expand('%:p'):match(obsidian_vault_path) then
      vim.wo.conceallevel = 2
    end
  end
})

return {
  'epwalsh/obsidian.nvim',
  event = {
    'BufReadPre ' .. obsidian_vault_path .. '/**.md',
    'VeryLazy',
  },
  dependencies = {
    'nvim-lua/plenary.nvim',
    -- 'hrsh7th/nvim-cmp',
    'nvim-telescope/telescope.nvim',
  },
  opts = {
    mappings = {
      -- Overrides the 'gf' mapping to work on markdown/wiki links within your vault.
      ["gf"] = {
        action = function()
          return require("obsidian").util.gf_passthrough()
        end,
        opts = { noremap = false, expr = true, buffer = true },
      },
      -- Toggle check-boxes.
      ["<leader>ch"] = {
        action = function()
          return require("obsidian").util.toggle_checkbox()
        end,
        opts = { buffer = true },
      },
      -- Smart action depending on context, either follow link or toggle checkbox.
      ["<cr>"] = {
        action = function()
          return require("obsidian").util.smart_action()
        end,
        opts = { buffer = true, expr = true },
      }
    },
    workspaces = {
      {
        name = 'dev',
        path = obsidian_vault_path,
      },
    },
    dir = obsidian_vault_path,
    notes_subdir = 'notes',
    -- Optional, set the log level for Obsidian. This is an integer corresponding to one of the log
    -- levels defined by "vim.log.levels.*" or nil, which is equivalent to DEBUG (1).
    log_level = vim.log.levels.WARN,
    daily_notes = {
      folder = 'dev/dailies',
      date_format = '%Y-%m-%d',
    },
    ui = {
      enable = true,
    },
    completion = {
      -- nvim_cmp = false,
      min_chars = 2,
    },
    -- Where to put new notes created from completion. Valid options are
    --  * "current_dir" - put new notes in same directory as the current buffer.
    --  * "notes_subdir" - put new notes in the default notes subdirectory.
    new_notes_location = 'current_dir',

    -- Optional, customize how names/IDs for new notes are created.
    note_id_func = function(title)
      -- Create note IDs in a Zettelkasten format with a timestamp and a suffix.
      -- In this case a note with the title 'My new note' will given an ID that looks
      -- like '1657296016-my-new-note', and therefore the file name '1657296016-my-new-note.md'
      local suffix = ''
      if title ~= nil then
        -- If title is given, transform it into valid file name.
        suffix = title:gsub(' ', '-'):gsub('[^A-Za-z0-9-]', ''):lower()
      else
        -- If title is nil, just add 4 random uppercase letters to the suffix.
        for _ = 1, 4 do
          suffix = suffix .. string.char(math.random(65, 90))
        end
      end
      return tostring(os.time()) .. '-' .. suffix
    end,

    -- Optional, set to true if you don't want Obsidian to manage frontmatter.
    disable_frontmatter = false,

    -- Optional, alternatively you can customize the frontmatter data.
    note_frontmatter_func = function(note)
      -- This is equivalent to the default frontmatter function.
      local out = { id = note.id, aliases = note.aliases, tags = note.tags }
      -- `note.metadata` contains any manually added fields in the frontmatter.
      -- So here we just make sure those fields are kept in the frontmatter.
      if note.metadata ~= nil and require('obsidian').util.table_length(note.metadata) > 0 then
        for k, v in pairs(note.metadata) do
          out[k] = v
        end
      end
      return out
    end,

    -- -- Optional, for templates (see below).
    -- templates = {
    --   subdir = "templates",
    --   date_format = "%Y-%m-%d-%a",
    --   time_format = "%H:%M",
    -- },

    -- Optional, by default when you use `:ObsidianFollowLink` on a link to an external
    -- URL it will be ignored but you can customize this behavior here.
    follow_url_func = function(url)
      -- Open the URL in the default web browser.
      vim.fn.jobstart { 'open', url } -- Mac OS
      -- vim.fn.jobstart({"xdg-open", url})  -- linux
    end,

    -- Optional, set to true if you use the Obsidian Advanced URI plugin.
    -- https://github.com/Vinzent03/obsidian-advanced-uri
    use_advanced_uri = true,

    -- Optional, set to true to force ':ObsidianOpen' to bring the app to the foreground.
    open_app_foreground = false,

    -- Optional, by default commands like `:ObsidianSearch` will attempt to use
    -- telescope.nvim, fzf-lua, and fzf.nvim (in that order), and use the
    -- first one they find. By setting this option to your preferred
    -- finder you can attempt it first. Note that if the specified finder
    -- is not installed, or if it the command does not support it, the
    -- remaining finders will be attempted in the original order.
    finder = 'telescope.nvim',
  },
  -- config = function(_, opts)
  --   require("obsidian").setup(opts)
  -- end,
}
