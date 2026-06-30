-- ============================================================
-- Relie les highlights de which-key au colorscheme actif (xcode).
-- Nécessaire car le colorscheme est appliqué APRÈS le setup de
-- which-key, ce qui efface ses liens de couleur par défaut.
-- ============================================================

local function link_whichkey_highlights()
  local links = {
    WhichKey = 'Function', -- la touche pressée
    WhichKeyGroup = 'Keyword', -- les groupes (+prefix)
    WhichKeyDesc = 'Identifier', -- la description de l'action
    WhichKeySeparator = 'Comment', -- le séparateur (→)
    WhichKeyNormal = 'Normal', -- fond du popup = même fond que l'éditeur
    WhichKeyBorder = 'Normal', -- bordure = même couleur (fg) que la police
    WhichKeyTitle = 'Title', -- titre
    WhichKeyValue = 'Comment',
  }
  for group, target in pairs(links) do
    vim.api.nvim_set_hl(0, group, { link = target })
  end
end

-- Ré-applique à chaque changement de colorscheme...
vim.api.nvim_create_autocmd('ColorScheme', {
  desc = 'Link which-key highlights to the active colorscheme',
  callback = link_whichkey_highlights,
})

-- ...et tout de suite, pour le colorscheme déjà chargé.
link_whichkey_highlights()
