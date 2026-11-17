-- ============================================================
-- Neo-tree colors in the Xcode Dark style (palette in lua/custom/xcode.lua):
-- blue folders, pink root, git states in the theme's colors.
-- neo-tree only defines its groups with `highlight default`,
-- so these settings take precedence.
-- ============================================================

local xcode = require 'custom.xcode'

local function set_neotree_highlights()
  if vim.g.colors_name ~= 'xcodedark' then return end

  local groups = {
    -- Window (background stays transparent, like the editor)
    NeoTreeNormal = { fg = xcode.fg },
    NeoTreeNormalNC = { fg = xcode.fg },
    NeoTreeEndOfBuffer = { fg = xcode.bg },
    NeoTreeWinSeparator = { fg = xcode.bg_mid },
    NeoTreeVertSplit = { fg = xcode.bg_mid },
    NeoTreeCursorLine = { bg = xcode.bg_mid }, -- selected line, like Xcode's navigator

    -- Tree
    NeoTreeRootName = { fg = xcode.pink, bold = true },
    NeoTreeDirectoryIcon = { fg = xcode.blue },
    NeoTreeDirectoryName = { fg = xcode.fg },
    NeoTreeFileName = { fg = xcode.fg },
    NeoTreeFileNameOpened = { fg = xcode.cyan },
    NeoTreeIndentMarker = { fg = xcode.muted },
    NeoTreeExpander = { fg = xcode.comment },
    NeoTreeSymbolicLinkTarget = { fg = xcode.purple },
    NeoTreeModified = { fg = xcode.orange },

    -- Hidden / ignored files
    NeoTreeDotfile = { fg = xcode.comment },
    NeoTreeHiddenByName = { fg = xcode.comment },
    NeoTreeIgnored = { fg = xcode.muted },
    NeoTreeWindowsHidden = { fg = xcode.muted },

    -- Git status
    NeoTreeGitAdded = { fg = xcode.green },
    NeoTreeGitStaged = { fg = xcode.green },
    NeoTreeGitModified = { fg = xcode.yellow },
    NeoTreeGitUnstaged = { fg = xcode.yellow },
    NeoTreeGitUntracked = { fg = xcode.teal },
    NeoTreeGitRenamed = { fg = xcode.purple },
    NeoTreeGitDeleted = { fg = xcode.salmon },
    NeoTreeGitConflict = { fg = xcode.pink, bold = true },
    NeoTreeGitIgnored = { fg = xcode.muted },

    -- Texts, filters and floating windows
    NeoTreeDimText = { fg = xcode.comment },
    NeoTreeMessage = { fg = xcode.comment, italic = true },
    NeoTreeFileStats = { fg = xcode.comment },
    NeoTreeFileStatsHeader = { fg = xcode.blue, bold = true },
    NeoTreeFilterTerm = { fg = xcode.yellow, bold = true },
    NeoTreeTitleBar = { fg = xcode.bg, bg = xcode.blue, bold = true },
    NeoTreeFloatBorder = { fg = xcode.bg_mid },
    NeoTreeFloatTitle = { fg = xcode.blue, bold = true },

    -- Source selector (filesystem / buffers / git tabs, when enabled)
    NeoTreeTabActive = { fg = xcode.fg, bg = xcode.bg_mid, bold = true },
    NeoTreeTabInactive = { fg = xcode.comment, bg = xcode.bg_dark },
    NeoTreeTabSeparatorActive = { fg = xcode.bg_mid, bg = xcode.bg_mid },
    NeoTreeTabSeparatorInactive = { fg = xcode.bg_dark, bg = xcode.bg_dark },
  }
  for group, spec in pairs(groups) do
    vim.api.nvim_set_hl(0, group, spec)
  end
end

vim.api.nvim_create_autocmd('ColorScheme', {
  desc = 'Xcode Dark colors for neo-tree',
  callback = set_neotree_highlights,
})

set_neotree_highlights()
