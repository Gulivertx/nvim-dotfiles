-- ============================================================
-- Align the background of snacks floating windows (picker, etc.)
-- with the editor background.
-- By default snacks links SnacksNormal -> NormalFloat, which the
-- xcode theme renders differently from the main background (Normal).
-- ============================================================

local function link_snacks_highlights()
  local links = {
    SnacksNormal = 'Normal', -- snacks window background = editor background
    SnacksNormalNC = 'Normal', -- same when the window is not focused
    SnacksBackdrop = 'Normal', -- remove the dimmed backdrop
    -- The picker remaps NormalFloat to these groups per sub-window:
    SnacksPicker = 'Normal', -- the outer box
    SnacksPickerList = 'Normal', -- the results list
    SnacksPickerInput = 'Normal', -- the input field
    SnacksPickerPreview = 'Normal', -- the preview
    SnacksPickerBox = 'Normal',
    -- Borders / titles: same background as the editor
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
