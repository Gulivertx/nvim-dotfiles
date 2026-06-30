-- ============================================================
-- Dashboard / écran d'accueil via snacks.nvim
-- Chargé automatiquement par lua/custom/plugins/init.lua
-- ============================================================

-- Installation du plugin (vim.pack = gestionnaire intégré, comme dans init.lua)
vim.pack.add { 'https://github.com/folke/snacks.nvim' }

require('snacks').setup {
  -- On n'active que le module dashboard ici ; les autres modules snacks
  -- (notifier, terminal, lazygit, etc.) peuvent être activés plus tard.
  picker = { enabled = true }, -- requis pour Snacks.picker.projects()
  projects = { enabled = true }, -- détection des projets récents
  dashboard = {
    enabled = true,
    preset = {
      -- Raccourcis affichés sur l'écran d'accueil
      keys = {
        { icon = ' ', key = 'f', desc = 'Trouver un fichier', action = ':lua Snacks.dashboard.pick("files")' },
        { icon = ' ', key = 'n', desc = 'Nouveau fichier', action = ':ene | startinsert' },
        { icon = ' ', key = 'g', desc = 'Rechercher un texte', action = ':lua Snacks.dashboard.pick("live_grep")' },
        { icon = ' ', key = 'p', desc = 'Projets', action = ':lua Snacks.picker.projects()' },
        { icon = ' ', key = 'r', desc = 'Fichiers récents', action = ':lua Snacks.dashboard.pick("oldfiles")' },
        { icon = ' ', key = 'c', desc = 'Config Neovim', action = ":lua Snacks.dashboard.pick('files', { cwd = vim.fn.stdpath('config') })" },
        { icon = ' ', key = 'q', desc = 'Quitter', action = ':qa' },
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
