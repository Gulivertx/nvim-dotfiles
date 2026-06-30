-- ============================================================
-- Gamedev : support Godot / GDScript
-- Détection du projet, LSP, lancement de Godot
-- ============================================================

local GODOT_BIN = '/Applications/Godot.app/Contents/MacOS/Godot'
local GODOT_LSP_PORT = 6005

-- Lance l'éditeur Godot pour le projet courant (détecté via project.godot)
local function find_godot_project_root()
  local path = vim.fn.expand '%:p:h'
  while path ~= '/' do
    if vim.uv.fs_stat(path .. '/project.godot') then return path end
    path = vim.fn.fnamemodify(path, ':h')
  end
  return nil
end

vim.api.nvim_create_user_command('GodotOpen', function()
  local root = find_godot_project_root()
  if not root then
    vim.notify('Aucun project.godot trouvé', vim.log.levels.WARN)
    return
  end
  vim.notify('Ouverture Godot : ' .. root, vim.log.levels.INFO)
  vim.fn.jobstart({ GODOT_BIN, '--path', root }, { detach = true })
end, { desc = 'Ouvre Godot pour le projet courant' })

-- Keymap : <leader>go = ouvrir Godot
vim.keymap.set('n', '<leader>go', '<Cmd>GodotOpen<CR>', { desc = '[G]odot [O]pen editor' })

-- Avertissement si on ouvre un .gd et que Godot (LSP port 6005) ne tourne pas
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'gdscript',
  once = false,
  callback = function()
    vim.defer_fn(function()
      -- Vérifie si le LSP gdscript est attaché au buffer
      local clients = vim.lsp.get_clients { bufnr = 0, name = 'gdscript' }
      if #clients == 0 then
        vim.notify(
          'GDScript LSP non connecté (port ' .. GODOT_LSP_PORT .. ')\n'
          .. 'Lance :GodotOpen pour démarrer Godot.',
          vim.log.levels.WARN
        )
      end
    end, 2000) -- attend 2s que le LSP tente la connexion
  end,
})

-- Détection des types de fichiers Godot
-- .gd = GDScript, .tscn = scènes, .tres = ressources, .gdshader = shaders
vim.filetype.add {
  extension = {
    gd       = 'gdscript',   -- GDScript (LSP + highlight)
    tscn     = 'gdresource', -- Scènes Godot
    tres     = 'gdresource', -- Ressources Godot
    gdshader = 'gdshader',   -- Shaders Godot
  },
  -- Détection par nom de fichier : project.godot → type dédié
  filename = {
    ['project.godot'] = 'gdproject',
  },
}
