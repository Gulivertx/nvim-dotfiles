-- Neo-tree is a Neovim plugin to browse the file system
-- https://github.com/nvim-neo-tree/neo-tree.nvim

vim.pack.add {
  { src = 'https://github.com/nvim-neo-tree/neo-tree.nvim', version = vim.version.range '*' },
  'https://github.com/nvim-lua/plenary.nvim',
  'https://github.com/MunifTanjim/nui.nvim',
}

-- ── Global keymaps (normal mode) ───────────────────────────────────────────
vim.keymap.set('n', '<leader>e',  '<Cmd>Neotree toggle<CR>',     { desc = 'Neo-tree toggle',          silent = true })
vim.keymap.set('n', '<leader>ef', '<Cmd>Neotree reveal<CR>',     { desc = 'Neo-tree reveal file',     silent = true })
vim.keymap.set('n', '<leader>eg', '<Cmd>Neotree git_status<CR>', { desc = 'Neo-tree git status',      silent = true })
vim.keymap.set('n', '<leader>eb', '<Cmd>Neotree buffers<CR>',    { desc = 'Neo-tree open buffers',    silent = true })
-- Backward compat: \ always reveals current file
vim.keymap.set('n', '\\',         '<Cmd>Neotree reveal<CR>',     { desc = 'Neo-tree reveal',          silent = true })

require('neo-tree').setup {
  filesystem = {
    use_libuv_file_watcher = true,            -- watch the disk in real time (agents, git...)
    follow_current_file = { enabled = true }, -- highlight the current file
    hijack_netrw_behavior = 'open_current',   -- replace netrw
    window = {
      width = 35,
      mappings = {
        -- Close
        ['q']   = 'close_window',
        ['\\']  = 'close_window',
        -- Vim-style navigation
        ['h']   = 'navigate_up',         -- go up to the parent directory
        ['l']   = 'open',                -- open file / expand directory
        ['H']   = 'toggle_hidden',       -- show/hide hidden files
        -- Tree
        ['z']   = 'close_all_nodes',     -- collapse all
        ['Z']   = 'expand_all_nodes',    -- expand all
        -- Files
        ['a']   = 'add',                 -- new file (trailing / = directory)
        ['d']   = 'delete',
        ['r']   = 'rename',
        ['c']   = 'copy',
        ['m']   = 'move',
        -- Open in different windows
        ['<CR>'] = 'open',
        ['s']    = 'open_split',         -- horizontal split
        ['v']    = 'open_vsplit',        -- vertical split
        ['t']    = 'open_tabnew',        -- new tab
        -- Misc
        ['R']   = 'refresh',
        ['?']   = 'show_help',
      },
    },
  },
}
