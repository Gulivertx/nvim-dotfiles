-- Neo-tree is a Neovim plugin to browse the file system
-- https://github.com/nvim-neo-tree/neo-tree.nvim

vim.pack.add {
  { src = 'https://github.com/nvim-neo-tree/neo-tree.nvim', version = vim.version.range '*' },
  'https://github.com/nvim-lua/plenary.nvim',
  'https://github.com/MunifTanjim/nui.nvim',
}

-- ── Raccourcis globaux (mode normal) ───────────────────────────────────────
vim.keymap.set('n', '<leader>e',  '<Cmd>Neotree toggle<CR>',     { desc = 'Neo-tree toggle',          silent = true })
vim.keymap.set('n', '<leader>ef', '<Cmd>Neotree reveal<CR>',     { desc = 'Neo-tree reveal file',     silent = true })
vim.keymap.set('n', '<leader>eg', '<Cmd>Neotree git_status<CR>', { desc = 'Neo-tree git status',      silent = true })
vim.keymap.set('n', '<leader>eb', '<Cmd>Neotree buffers<CR>',    { desc = 'Neo-tree open buffers',    silent = true })
-- Backward compat: \ always reveals current file
vim.keymap.set('n', '\\',         '<Cmd>Neotree reveal<CR>',     { desc = 'Neo-tree reveal',          silent = true })

require('neo-tree').setup {
  filesystem = {
    use_libuv_file_watcher = true,            -- surveille le disque en temps réel (pi agent, git…)
    follow_current_file = { enabled = true }, -- surligne le fichier courant
    hijack_netrw_behavior = 'open_current',   -- remplace netrw
    window = {
      width = 35,
      mappings = {
        -- Fermeture
        ['q']   = 'close_window',
        ['\\']  = 'close_window',
        -- Navigation style vim
        ['h']   = 'navigate_up',         -- remonter au dossier parent
        ['l']   = 'open',                -- ouvrir fichier / déplier dossier
        ['H']   = 'toggle_hidden',       -- afficher/masquer fichiers cachés
        -- Arbre
        ['z']   = 'close_all_nodes',     -- tout replier
        ['Z']   = 'expand_all_nodes',    -- tout déplier
        -- Fichiers
        ['a']   = 'add',                 -- nouveau fichier (/ à la fin = dossier)
        ['d']   = 'delete',
        ['r']   = 'rename',
        ['c']   = 'copy',
        ['m']   = 'move',
        -- Ouverture dans différentes fenêtres
        ['<CR>'] = 'open',
        ['s']    = 'open_split',         -- split horizontal
        ['v']    = 'open_vsplit',        -- split vertical
        ['t']    = 'open_tabnew',        -- nouvel onglet
        -- Misc
        ['R']   = 'refresh',
        ['?']   = 'show_help',
      },
    },
  },
}
