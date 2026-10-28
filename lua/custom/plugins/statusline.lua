-- ============================================================
-- Statusline : lualine.nvim
-- Replaces mini.statusline (configured in init.lua)
-- ============================================================

vim.pack.add {
  'https://github.com/nvim-lualine/lualine.nvim',
  -- nvim-web-devicons already loaded by bufferline
}

-- Theme: 'auto' reads the highlight groups of the active colorscheme (xcodedark here).
-- If you change colorscheme, the statusline adapts automatically.
-- Other options: 'auto', 'onedark', 'gruvbox', 'tokyonight', ...
--
-- How it works:
--   section A  → bg/fg from hl 'Normal' + an accent color per mode
--   section B  → bg from 'StatusLine', fg from 'Normal'
--   section C  → colors from 'StatusLineNC'
--
-- To inspect the groups available in the current theme:
--   :hi Normal
--   :Telescope highlights  (if telescope is installed)
local lualine_theme = 'auto'

-- Component: git branch (Nerd Font icon)
local function git_branch()
  local branch = vim.b.gitsigns_head
  if not branch or branch == '' then return '' end
  return '  ' .. branch
end

-- Component: git diff (added/changed/removed via gitsigns)
local function git_diff()
  local status = vim.b.gitsigns_status_dict
  if not status then return '' end
  local parts = {}
  if (status.added or 0) > 0    then table.insert(parts, '%#GitSignsAdd#+' .. status.added) end
  if (status.changed or 0) > 0  then table.insert(parts, '%#GitSignsChange#~' .. status.changed) end
  if (status.removed or 0) > 0  then table.insert(parts, '%#GitSignsDelete#-' .. status.removed) end
  return table.concat(parts, ' ')
end

-- Component: relative file name + modified state
local function filename()
  local name = vim.fn.expand '%:~:.'
  if name == '' then name = '[No Name]' end
  if vim.bo.modified then name = name .. ' ●' end
  if vim.bo.readonly then name = name .. ' ' end
  return name
end

-- Component: LSP diagnostics (E/W/I/H)
local diagnostics = {
  'diagnostics',
  sources       = { 'nvim_lsp', 'nvim_diagnostic' },
  sections      = { 'error', 'warn', 'info', 'hint' },
  symbols       = { error = ' ', warn = ' ', info = ' ', hint = '󰌵 ' },
  colored       = true,
  always_visible = false,
}

-- Component: file type with icon
local filetype = {
  'filetype',
  icon_only = false,
  colored   = true,
}

require('lualine').setup {
  options = {
    theme                = lualine_theme,
    component_separators = { left = '', right = '' },  -- thin separators
    section_separators   = { left = '', right = '' },  -- powerline separators
    globalstatus         = true,   -- a single statusline for all windows
    refresh              = { statusline = 1000 },
  },

  sections = {
    -- Left
    lualine_a = { 'mode' },
    lualine_b = { git_branch, git_diff },
    lualine_c = { filename },

    -- Right
    lualine_x = { diagnostics, filetype },
    lualine_y = {
      { 'encoding', fmt = string.upper },
      { 'fileformat', icons_enabled = true },
    },
    lualine_z = { 'location', 'progress' },
  },

  inactive_sections = {
    lualine_c = { filename },
    lualine_x = { 'location' },
  },

  -- Extensions: adapt the display to special windows
  extensions = { 'neo-tree', 'quickfix', 'lazy', 'mason', 'nvim-dap-ui' },
}
