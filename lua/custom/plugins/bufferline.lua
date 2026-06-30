-- ============================================================
-- Bufferline : barre d'onglets en haut (un onglet par buffer ouvert)
-- ============================================================

vim.pack.add {
  { src = 'https://github.com/akinsho/bufferline.nvim', version = vim.version.range '*' },
  'https://github.com/nvim-tree/nvim-web-devicons',
}

require('bufferline').setup {
  options = {
    mode = 'buffers', -- un onglet par buffer (mets 'tabs' pour les tabpages natives)
    diagnostics = 'nvim_lsp', -- affiche les erreurs/warnings LSP dans l'onglet
    show_buffer_close_icons = true,
    show_close_icon = false,
    separator_style = 'slant',
    -- Laisse la place à la sidebar neo-tree à gauche
    offsets = {
      {
        filetype = 'neo-tree',
        text = 'Explorateur',
        text_align = 'left',
        separator = true,
      },
    },
  },
}

-- Raccourcis de navigation entre onglets/buffers
local map = vim.keymap.set
map('n', '<Tab>',   '<Cmd>BufferLineCycleNext<CR>', { desc = 'Next buffer' })
map('n', '<S-Tab>', '<Cmd>BufferLineCyclePrev<CR>', { desc = 'Previous buffer' })
map('n', '<leader>bd', '<Cmd>bdelete<CR>',          { desc = '[B]uffer [D]elete (close)' })
map('n', '<leader>bp', '<Cmd>BufferLinePick<CR>',   { desc = '[B]uffer [P]ick' })
-- Aller directement à l'onglet N
for i = 1, 9 do
  map('n', '<leader>' .. i, '<Cmd>BufferLineGoToBuffer ' .. i .. '<CR>', { desc = 'Go to buffer ' .. i })
end
