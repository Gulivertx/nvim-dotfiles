-- ============================================================
-- Auto-reload: reloads buffers changed by external tools
-- (coding agents, git, etc.) without restarting Neovim.
-- ============================================================

-- Enable automatic detection of file changes
vim.o.autoread = true

-- Triggers: check for changed files at every natural opportunity
vim.api.nvim_create_autocmd({
  'FocusGained',    -- Neovim regains focus (back from the terminal)
  'BufEnter',       -- entering a buffer
  'CursorHold',     -- cursor idle (delay = updatetime)
  'CursorHoldI',    -- same in insert mode
}, {
  desc = 'Reload buffers changed by external tools',
  callback = function()
    -- checktime silently reloads every buffer whose file on disk
    -- is newer than the version in memory.
    if vim.fn.getcmdwintype() == '' then
      vim.cmd 'checktime'
    end
  end,
})

-- Notify when a file is reloaded (optional, disable if too noisy)
vim.api.nvim_create_autocmd('FileChangedShellPost', {
  desc = 'Notify when a file is reloaded from disk',
  callback = function()
    vim.notify(
      '↻  ' .. vim.fn.expand '%:t' .. ' reloaded (changed outside Neovim)',
      vim.log.levels.INFO
    )
  end,
})
