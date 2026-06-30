-- ============================================================
-- Ouvre Neo-tree automatiquement au démarrage si on est dans un projet.
-- Un « projet » = le cwd contient un de ces marqueurs racine.
-- Ne se déclenche pas si nvim est lancé sur un fichier précis ou en pipe.
-- ============================================================

local project_markers = {
  '.git',
  'composer.json', -- projets PHP / Symfony
  'package.json', -- projets JS/TS
  'devenv.nix', -- ce projet (devenv)
  '.luarc.json',
}

local function in_project()
  for _, marker in ipairs(project_markers) do
    if vim.uv.fs_stat(vim.fn.getcwd() .. '/' .. marker) then return true end
  end
  return false
end

-- Détecte si l'entrée provient d'un pipe / stdin (ex. `cat f | nvim -`)
local stdin_read = false
vim.api.nvim_create_autocmd('StdinReadPre', {
  callback = function() stdin_read = true end,
})

vim.api.nvim_create_autocmd('VimEnter', {
  desc = 'Ouvre Neo-tree au démarrage si on est dans un projet',
  callback = function()
    -- Ne rien faire si des fichiers ont été passés en argument
    if vim.fn.argc() > 0 then return end
    -- Ne rien faire si l'entrée vient d'un pipe / stdin
    if stdin_read then return end
    if not in_project() then return end

    -- `show` ouvre la sidebar SANS lui donner le focus,
    -- pour que le dashboard reste actif dans la fenêtre principale.
    vim.schedule(function() vim.cmd 'Neotree show left' end)
  end,
})
