-- ============================================================
-- Aligne le fond des fenêtres flottantes de snacks (picker, etc.)
-- sur le fond de l'éditeur.
-- Par défaut snacks lie SnacksNormal -> NormalFloat, que le thème
-- xcode rend différent du fond principal (Normal).
-- ============================================================

local function link_snacks_highlights()
  local links = {
    SnacksNormal = 'Normal', -- fond des fenêtres snacks = fond éditeur
    SnacksNormalNC = 'Normal', -- idem quand la fenêtre n'a pas le focus
    SnacksBackdrop = 'Normal', -- supprime l'assombrissement de l'arrière-plan
    -- Le picker remappe NormalFloat vers ces groupes par sous-fenêtre :
    SnacksPicker = 'Normal', -- la boîte englobante
    SnacksPickerList = 'Normal', -- la liste des résultats
    SnacksPickerInput = 'Normal', -- le champ de saisie
    SnacksPickerPreview = 'Normal', -- l'aperçu
    SnacksPickerBox = 'Normal',
    -- Bordures / titres : même fond que l'éditeur
    SnacksPickerBorder = 'Normal',
    SnacksPickerTitle = 'Normal',
    SnacksPickerFooter = 'Normal',
    SnacksPickerListBorder = 'Normal',
    SnacksPickerInputBorder = 'Normal',
    SnacksPickerPreviewBorder = 'Normal',
    SnacksPickerPreviewTitle = 'Normal',
    SnacksPickerInputTitle = 'Normal',
  }
  for group, target in pairs(links) do
    vim.api.nvim_set_hl(0, group, { link = target })
  end
end

vim.api.nvim_create_autocmd('ColorScheme', {
  desc = 'Align snacks float background with editor background',
  callback = link_snacks_highlights,
})

link_snacks_highlights()
