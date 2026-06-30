-- ============================================================
-- Colorscheme : Xcode Dark (esthétique « macOS Dark » d'Apple)
-- Chargé après init.lua, donc remplace le tokyonight par défaut.
-- ============================================================

vim.pack.add { 'https://github.com/arzg/vim-colors-xcode' }

-- Variantes disponibles :
--   xcodedark    → Xcode Dark (mode sombre macOS)
--   xcodedarkhc  → Dark, contraste élevé
--   xcodelight   → Xcode Light
--   xcodewwdc    → variante présentations WWDC
vim.cmd.colorscheme 'xcodedark'

-- ------------------------------------------------------------
-- Fond transparent : on laisse apparaître la couleur de fond
-- du terminal au lieu de celle du thème.
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

-- Réappliquer si le colorscheme est rechargé.
vim.api.nvim_create_autocmd('ColorScheme', {
  callback = make_transparent,
})
