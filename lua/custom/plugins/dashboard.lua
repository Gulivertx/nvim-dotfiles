-- ============================================================
-- Dashboard / start screen via snacks.nvim
-- Loaded automatically by lua/custom/plugins/init.lua
-- ============================================================

-- Plugin install (vim.pack = built-in manager, as in init.lua)
vim.pack.add { 'https://github.com/folke/snacks.nvim' }

-- ── Lazygit / Git keymaps ──────────────────────────────────
vim.keymap.set('n', '<leader>gg', function() Snacks.lazygit() end,            { desc = 'Lazygit (repo)' })
vim.keymap.set('n', '<leader>gf', function() Snacks.lazygit.log_file() end,   { desc = 'Lazygit log current file' })
vim.keymap.set('n', '<leader>gl', function() Snacks.lazygit.log() end,        { desc = 'Lazygit log (repo)' })

-- Gitsigns : hunk navigation and quick actions
vim.keymap.set('n', ']h', function() require('gitsigns').next_hunk() end,     { desc = 'Next hunk' })
vim.keymap.set('n', '[h', function() require('gitsigns').prev_hunk() end,     { desc = 'Previous hunk' })
vim.keymap.set('n', '<leader>hp', function() require('gitsigns').preview_hunk() end,   { desc = '[H]unk [P]review' })
vim.keymap.set('n', '<leader>hs', function() require('gitsigns').stage_hunk() end,    { desc = '[H]unk [S]tage' })
vim.keymap.set('n', '<leader>hu', function() require('gitsigns').undo_stage_hunk() end, { desc = '[H]unk [U]ndo stage' })
vim.keymap.set('n', '<leader>hr', function() require('gitsigns').reset_hunk() end,    { desc = '[H]unk [R]eset' })
vim.keymap.set('n', '<leader>hb', function() require('gitsigns').blame_line { full = true } end, { desc = '[H]unk [B]lame line' })

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
