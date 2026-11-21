-- ============================================================
-- Bufferline: tab bar at the top (one tab per open buffer)
-- ============================================================

vim.pack.add {
  { src = 'https://github.com/akinsho/bufferline.nvim', version = vim.version.range '*' },
  'https://github.com/nvim-tree/nvim-web-devicons',
}

-- ------------------------------------------------------------
-- Xcode Dark colors (palette in lua/custom/xcode.lua).
--   bar background → editor background
--   inactive tabs  → dark gray, dimmed text
--   selected tab   → mid gray (like the statusline), bright text,
--                    teal line underneath (indicator style 'underline')
-- bufferline calls this with its computed defaults: every group keeps its
-- default foreground (diagnostics, etc.) and only gets the right background.
-- ------------------------------------------------------------
local xcode = require 'custom.xcode'

local function xcode_highlights(defaults)
  local hl = vim.deepcopy(defaults.highlights)
  local bg = { fill = xcode.bg, inactive = xcode.bg_dark, visible = xcode.bg_dark, selected = xcode.bg_mid }

  for name, group in pairs(hl) do
    local state = name:match '_selected$' and 'selected' or name:match '_visible$' and 'visible' or 'inactive'
    group.bg = bg[state]
    if name:match 'separator' then group.fg = bg.fill end
    -- Colored line under the whole active tab (every selected segment)
    if state == 'selected' then
      group.underline = true
      group.sp = xcode.teal
    end
  end

  hl.fill = { bg = bg.fill }
  hl.trunc_marker = { fg = xcode.comment, bg = bg.fill }
  hl.offset_separator = { fg = xcode.bg_mid, bg = bg.fill }
  hl.group_separator = { fg = bg.fill, bg = bg.fill }

  hl.background.fg = xcode.comment
  hl.buffer_visible.fg = xcode.fg
  hl.buffer_selected = { fg = xcode.fg, bg = bg.selected, bold = true, italic = false, underline = true, sp = xcode.teal }
  hl.indicator_selected = { fg = xcode.teal, bg = bg.selected, underline = true, sp = xcode.teal }
  hl.tab = { fg = xcode.comment, bg = bg.inactive }
  hl.tab_selected = { fg = xcode.fg, bg = bg.selected, bold = true, underline = true, sp = xcode.teal }
  for _, state in ipairs { '', '_visible', '_selected' } do
    hl['modified' .. state].fg = xcode.orange
    hl['pick' .. state].fg = xcode.pink
  end
  return hl
end

require('bufferline').setup {
  options = {
    mode = 'buffers', -- one tab per buffer (use 'tabs' for native tabpages)
    diagnostics = 'nvim_lsp', -- show LSP errors/warnings in the tab
    show_buffer_icons = false, -- plain file names, no filetype icon
    show_buffer_close_icons = false,
    show_close_icon = false,
    -- Flat rectangular tabs: no separators, active tab underlined
    separator_style = { '', '' },
    indicator = { style = 'underline' },
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
  highlights = xcode_highlights,
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
