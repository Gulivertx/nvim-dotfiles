-- ============================================================
-- Dashboard / écran d'accueil via snacks.nvim
-- Chargé automatiquement par lua/custom/plugins/init.lua
-- ============================================================

-- Installation du plugin (vim.pack = gestionnaire intégré, comme dans init.lua)
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
  -- On n'active que le module dashboard ici ; les autres modules snacks
  -- (notifier, terminal, lazygit, etc.) peuvent être activés plus tard.
  picker = { enabled = true }, -- requis pour Snacks.picker.projects()
  projects = { enabled = true }, -- détection des projets récents
  lazygit = { enabled = true }, -- intégration lazygit flottant
  dashboard = {
    enabled = true,
    preset = {
      -- Raccourcis affichés sur l'écran d'accueil
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
      -- Pas de section 'startup' : elle dépend de lazy.nvim (non utilisé ici, on est sous vim.pack)
    },
  },
}
