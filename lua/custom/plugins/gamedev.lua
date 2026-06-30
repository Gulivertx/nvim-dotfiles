-- ============================================================
-- Gamedev : support Godot / GDScript
-- ============================================================

-- Détection des types de fichiers Godot
-- .tscn = scènes, .tres = ressources, .gdshader = shaders
vim.filetype.add {
  extension = {
    tscn     = 'gdresource',
    tres     = 'gdresource',
    gdshader = 'gdshader',
  },
}
