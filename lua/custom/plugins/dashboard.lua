-- ============================================================
-- Dashboard / start screen via snacks.nvim
-- Loaded automatically by lua/custom/plugins/init.lua
-- ============================================================

-- Plugin install (vim.pack = built-in manager, as in init.lua)
vim.pack.add { 'https://github.com/folke/snacks.nvim' }

-- Git keymaps are in keymaps.lua (Neogit: <leader>gg/gl/gf in neogit.lua)

require('snacks').setup {
  -- Only the modules below are enabled; other snacks modules
  -- (notifier, terminal, etc.) can be enabled later.
  picker = { enabled = true }, -- required for Snacks.picker.projects()
  projects = { enabled = true }, -- recent project detection
  -- Snacks picker: project detection settings
  -- Adds project.godot as a root marker, plus the dev directories
  picker = {
    enabled = true,
    sources = {
      projects = {
        dev = { '~/develop', '~/dev', '~/projects' },
        patterns = {
          'project.godot',  -- Godot
          '.git',           -- git
          'package.json',   -- Node / web
          'Makefile',       -- C/C++
          'Cargo.toml',     -- Rust
          'go.mod',         -- Go
          'pyproject.toml', -- Python
        },
      },
    },
  },
  lazygit = { enabled = true }, -- floating lazygit integration
  dashboard = {
    enabled = true,
    preset = {
      -- Shortcuts shown on the start screen
      keys = {
        { icon = ' ', key = 'f', desc = 'Find file',          action = ':lua Snacks.dashboard.pick("files")' },
        { icon = ' ', key = 'n', desc = 'New file',           action = ':ene | startinsert' },
        { icon = ' ', key = 'g', desc = 'Search text',        action = ':lua Snacks.dashboard.pick("live_grep")' },
        { icon = ' ', key = 'p', desc = 'Projects',           action = ':lua Snacks.picker.projects()' },
        { icon = ' ', key = 'r', desc = 'Recent files',       action = ':lua Snacks.dashboard.pick("oldfiles")' },
        { icon = ' ', key = 'c', desc = 'Neovim config',      action = ":lua Snacks.dashboard.pick('files', { cwd = vim.fn.stdpath('config') })" },
        { icon = ' ', key = 'q', desc = 'Quit',               action = ':qa' },
      },
      header = [[
 ██████╗ ██╗   ██╗██╗     ██╗██╗   ██╗███████╗██████╗ ████████╗
██╔════╝ ██║   ██║██║     ██║██║   ██║██╔════╝██╔══██╗╚══██╔══╝
██║  ███╗██║   ██║██║     ██║██║   ██║█████╗  ██████╔╝   ██║   
██║   ██║██║   ██║██║     ██║╚██╗ ██╔╝██╔══╝  ██╔══██╗   ██║   
╚██████╔╝╚██████╔╝███████╗██║ ╚████╔╝ ███████╗██║  ██║   ██║   
 ╚═════╝  ╚═════╝ ╚══════╝╚═╝  ╚═══╝  ╚══════╝╚═╝  ╚═╝   ╚═╝   ]],
    },
    sections = {
      { section = 'header' },
      { section = 'keys', gap = 1, padding = 1 },
      -- No 'startup' section: it depends on lazy.nvim (not used here, this config uses vim.pack)
    },
  },
}
