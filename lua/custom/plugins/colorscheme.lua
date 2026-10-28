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
    'LineNr',
    'EndOfBuffer',
  } do
    vim.api.nvim_set_hl(0, group, { bg = 'none' })
  end
end

make_transparent()

-- Reapply when the colorscheme is reloaded.
vim.api.nvim_create_autocmd('ColorScheme', {
  callback = make_transparent,
})
