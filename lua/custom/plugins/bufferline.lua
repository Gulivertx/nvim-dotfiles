-- ============================================================
-- Bufferline: tab bar at the top (one tab per open buffer)
-- ============================================================

vim.pack.add {
  { src = 'https://github.com/akinsho/bufferline.nvim', version = vim.version.range '*' },
  'https://github.com/nvim-tree/nvim-web-devicons',
}

require('bufferline').setup {
  options = {
    mode = 'buffers', -- one tab per buffer (use 'tabs' for native tabpages)
    diagnostics = 'nvim_lsp', -- show LSP errors/warnings in the tab
    show_buffer_close_icons = true,
    show_close_icon = false,
    separator_style = 'slant',
    -- Leave room for the neo-tree sidebar on the left
    offsets = {
      {
        filetype = 'neo-tree',
        text = 'Explorer',
        text_align = 'left',
        separator = true,
      },
    },
  },
}

-- Keymaps to navigate between tabs/buffers
local map = vim.keymap.set
map('n', '<Tab>',   '<Cmd>BufferLineCycleNext<CR>', { desc = 'Next buffer' })
map('n', '<S-Tab>', '<Cmd>BufferLineCyclePrev<CR>', { desc = 'Previous buffer' })
map('n', '<leader>bd', '<Cmd>bdelete<CR>',          { desc = '[B]uffer [D]elete (close)' })
map('n', '<leader>bp', '<Cmd>BufferLinePick<CR>',   { desc = '[B]uffer [P]ick' })
-- Jump straight to tab N
for i = 1, 9 do
  map('n', '<leader>' .. i, '<Cmd>BufferLineGoToBuffer ' .. i .. '<CR>', { desc = 'Go to buffer ' .. i })
end
