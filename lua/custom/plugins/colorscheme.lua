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
