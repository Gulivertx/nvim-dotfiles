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

-- Buffer keymaps (LazyVim layout)
local map = vim.keymap.set
map('n', '<S-h>', '<Cmd>BufferLineCyclePrev<CR>', { desc = 'Prev Buffer' })
map('n', '<S-l>', '<Cmd>BufferLineCycleNext<CR>', { desc = 'Next Buffer' })
map('n', '[b', '<Cmd>BufferLineCyclePrev<CR>', { desc = 'Prev Buffer' })
map('n', ']b', '<Cmd>BufferLineCycleNext<CR>', { desc = 'Next Buffer' })
map('n', '[B', '<Cmd>BufferLineMovePrev<CR>', { desc = 'Move buffer prev' })
map('n', ']B', '<Cmd>BufferLineMoveNext<CR>', { desc = 'Move buffer next' })
map('n', '<leader>bb', '<Cmd>e #<CR>', { desc = 'Switch to Other Buffer' })
map('n', '<leader>`', '<Cmd>e #<CR>', { desc = 'Switch to Other Buffer' })
map('n', '<leader>bd', function() Snacks.bufdelete() end, { desc = 'Delete Buffer' })
map('n', '<leader>bo', function() Snacks.bufdelete.other() end, { desc = 'Delete Other Buffers' })
map('n', '<leader>bD', '<Cmd>bd<CR>', { desc = 'Delete Buffer and Window' })
map('n', '<leader>bp', '<Cmd>BufferLineTogglePin<CR>', { desc = 'Toggle Pin' })
map('n', '<leader>bP', '<Cmd>BufferLineGroupClose ungrouped<CR>', { desc = 'Delete Non-Pinned Buffers' })
map('n', '<leader>br', '<Cmd>BufferLineCloseRight<CR>', { desc = 'Delete Buffers to the Right' })
map('n', '<leader>bl', '<Cmd>BufferLineCloseLeft<CR>', { desc = 'Delete Buffers to the Left' })
map('n', '<leader>bj', '<Cmd>BufferLinePick<CR>', { desc = 'Pick Buffer' })
