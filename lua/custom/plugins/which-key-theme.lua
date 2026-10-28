-- ============================================================
-- Link which-key highlights to the active colorscheme (xcode).
-- Needed because the colorscheme is applied AFTER which-key's
-- setup, which clears its default color links.
-- ============================================================

local function link_whichkey_highlights()
  local links = {
    WhichKey = 'Function', -- the pressed key
    WhichKeyGroup = 'Keyword', -- groups (+prefix)
    WhichKeyDesc = 'Identifier', -- the action description
    WhichKeySeparator = 'Comment', -- the separator (→)
    WhichKeyNormal = 'Normal', -- popup background = editor background
    WhichKeyBorder = 'Normal', -- border = same color (fg) as the text
    WhichKeyTitle = 'Title', -- title
    WhichKeyValue = 'Comment',
  }
  for group, target in pairs(links) do
    vim.api.nvim_set_hl(0, group, { link = target })
  end
end

-- Reapply on every colorscheme change...
vim.api.nvim_create_autocmd('ColorScheme', {
  desc = 'Link which-key highlights to the active colorscheme',
  callback = link_whichkey_highlights,
})

-- ...and right away, for the colorscheme already loaded.
link_whichkey_highlights()
