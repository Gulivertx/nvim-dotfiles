-- ============================================================
-- Statusline : lualine.nvim
-- Remplace mini.statusline (configuré dans init.lua)
-- ============================================================

vim.pack.add {
  'https://github.com/nvim-lualine/lualine.nvim',
  -- nvim-web-devicons déjà chargé par bufferline
}

-- Thème : 'auto' lit les highlight groups du colorscheme actif (xcodedark ici).
-- Si tu changes de colorscheme, la statusline s'adapte automatiquement.
-- Alternatives possibles : 'auto', 'onedark', 'gruvbox', 'tokyonight', ...
--
-- Comment ça marche :
--   section A  → reprend bg/fg de hl 'Normal' + couleur d'accent par mode
--   section B  → reprend bg de 'StatusLine', fg de 'Normal'
--   section C  → reprend les couleurs de 'StatusLineNC'
--
-- Pour inspecter les groupes disponibles dans ton thème courant :
--   :hi Normal
--   :Telescope highlights  (si telescope est installé)
local lualine_theme = 'auto'

-- Composant : branche git (icône Nerd Font)
local function git_branch()
  local branch = vim.b.gitsigns_head
  if not branch or branch == '' then return '' end
  return '  ' .. branch
end

-- Composant : diff git (ajouts/modifs/supprims via gitsigns)
local function git_diff()
  local status = vim.b.gitsigns_status_dict
  if not status then return '' end
  local parts = {}
  if (status.added or 0) > 0    then table.insert(parts, '%#GitSignsAdd#+' .. status.added) end
  if (status.changed or 0) > 0  then table.insert(parts, '%#GitSignsChange#~' .. status.changed) end
  if (status.removed or 0) > 0  then table.insert(parts, '%#GitSignsDelete#-' .. status.removed) end
  return table.concat(parts, ' ')
end

-- Composant : nom du fichier relatif + état modifié
local function filename()
  local name = vim.fn.expand '%:~:.'
  if name == '' then name = '[No Name]' end
  if vim.bo.modified then name = name .. ' ●' end
  if vim.bo.readonly then name = name .. ' ' end
  return name
end

-- Composant : diagnostics LSP (E/W/I/H)
local diagnostics = {
  'diagnostics',
  sources       = { 'nvim_lsp', 'nvim_diagnostic' },
  sections      = { 'error', 'warn', 'info', 'hint' },
  symbols       = { error = ' ', warn = ' ', info = ' ', hint = '󰌵 ' },
  colored       = true,
  always_visible = false,
}

-- Composant : type de fichier avec icône
local filetype = {
  'filetype',
  icon_only = false,
  colored   = true,
}

require('lualine').setup {
  options = {
    theme                = lualine_theme,
    component_separators = { left = '', right = '' },  -- séparateurs fins
    section_separators   = { left = '', right = '' },  -- séparateurs powerline
    globalstatus         = true,   -- une seule statusline pour toutes les fenêtres
    refresh              = { statusline = 1000 },
  },

  sections = {
    -- Gauche
    lualine_a = { 'mode' },
    lualine_b = { git_branch, git_diff },
    lualine_c = { filename },

    -- Droite
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

  -- Extensions : adapte l'affichage aux fenêtres spéciales
  extensions = { 'neo-tree', 'quickfix', 'lazy', 'mason', 'nvim-dap-ui' },
}
