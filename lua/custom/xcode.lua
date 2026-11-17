-- ============================================================
-- Xcode Dark palette (taken from vim-colors-xcode/xcodedark).
-- Shared by the statusline, the tab bar and neo-tree.
-- Lives outside custom/plugins/ so it is not loaded as a plugin.
-- ============================================================

return {
  bg       = '#292a30', -- editor background
  bg_dark  = '#2f3037', -- current line
  bg_mid   = '#414453', -- selection / StatusLine
  fg       = '#dfdfe0', -- main text
  comment  = '#7f8c98',
  muted    = '#53606e', -- indent guides, ignored files
  blue     = '#4eb0cc', -- functions / project types
  cyan     = '#6bdfff', -- other types
  teal     = '#78c2b3',
  green    = '#84b360',
  purple   = '#b281eb',
  yellow   = '#d9c97c', -- numbers
  pink     = '#ff7ab2', -- keywords
  salmon   = '#ff8170', -- strings
  orange   = '#ffa14f', -- preprocessor
}
