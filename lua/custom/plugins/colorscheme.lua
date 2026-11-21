-- ============================================================
-- Colorscheme: Xcode Dark (Apple's "macOS Dark" look)
-- Loaded after init.lua.
-- ============================================================

vim.pack.add { 'https://github.com/arzg/vim-colors-xcode' }

-- Available variants:
--   xcodedark    → Xcode Dark (macOS dark mode)
--   xcodedarkhc  → Dark, high contrast
--   xcodelight   → Xcode Light
--   xcodewwdc    → WWDC presentation variant
vim.cmd.colorscheme 'xcodedark'

-- ------------------------------------------------------------
-- Transparent background: let the terminal background show
-- through instead of the theme's own.
-- ------------------------------------------------------------
local function make_transparent()
  for _, group in ipairs {
    'Normal',
    'NormalNC',
    'NormalFloat',
    'FloatBorder',
    'SignColumn',
    'EndOfBuffer',
  } do
    vim.api.nvim_set_hl(0, group, { bg = 'none' })
  end

  -- Line numbers: dimmed gray, the current line's number in bright text
  -- (CursorLineNr keeps the theme's cursorline background).
  local xcode = require 'custom.xcode'
  vim.api.nvim_set_hl(0, 'LineNr', { fg = xcode.comment, bg = 'none' })
  vim.api.nvim_set_hl(0, 'CursorLineNr', { fg = xcode.fg, bg = xcode.bg_dark })
end

make_transparent()

-- Reapply when the colorscheme is reloaded.
vim.api.nvim_create_autocmd('ColorScheme', {
  callback = make_transparent,
})
