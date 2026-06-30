-- ============================================================
-- Auto-reload : recharge les buffers modifiés par des outils
-- externes (pi agent, git, etc.) sans redémarrer Neovim.
-- ============================================================

-- Active la détection automatique des changements de fichiers
vim.o.autoread = true

-- Triggers : vérifie les fichiers modifiés à chaque occasion naturelle
vim.api.nvim_create_autocmd({
  'FocusGained',    -- Neovim reprend le focus (retour depuis le terminal)
  'BufEnter',       -- on entre dans un buffer
  'CursorHold',     -- curseur immobile (délai = updatetime)
  'CursorHoldI',    -- idem en mode insertion
}, {
  desc = 'Recharge les buffers modifiés par des outils externes',
  callback = function()
    -- checktime recharge silencieusement tous les buffers dont le fichier
    -- sur disque est plus récent que la version en mémoire.
    if vim.fn.getcmdwintype() == '' then
      vim.cmd 'checktime'
    end
  end,
})

-- Notifie quand un fichier est rechargé (optionnel, désactiver si trop verbeux)
vim.api.nvim_create_autocmd('FileChangedShellPost', {
  desc = 'Notifie quand un fichier est rechargé depuis le disque',
  callback = function()
    vim.notify(
      '↻  ' .. vim.fn.expand '%:t' .. ' rechargé (modifié en dehors de Neovim)',
      vim.log.levels.INFO
    )
  end,
})

-- Raccourci manuel : <leader>rr pour forcer le rechargement du buffer courant
vim.keymap.set('n', '<leader>rr', '<Cmd>checktime<CR>', {
  desc = '[R]eload : recharge les buffers modifiés',
  silent = true,
})
