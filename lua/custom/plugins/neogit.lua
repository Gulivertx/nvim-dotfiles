-- ============================================================
-- Neogit: magit-like Git interface for Neovim
-- Loaded automatically by lua/custom/plugins/init.lua
-- ============================================================

-- Dependencies (plenary.nvim is already added in init.lua, with Telescope)
vim.pack.add { 'https://github.com/sindrets/diffview.nvim' } -- built-in diff view (optional but recommended)

-- Main plugin
vim.pack.add { 'https://github.com/NeogitOrg/neogit' }

require('neogit').setup {
  -- diffview integration for diffs and log
  integrations = {
    diffview = true,
    telescope = false, -- use the snacks picker instead if needed
  },
  -- Open neogit in a tab (like the floating lazygit)
  kind = 'tab',
  -- Commit editor in a split
  commit_editor = {
    kind = 'split',
  },
}

-- ── Neogit keymaps ────────────────────────────────────────
-- Lazygit stays available on <leader>gG / <leader>gL (keymaps.lua)

-- <leader>gg → repo status
vim.keymap.set('n', '<leader>gg', function()
  require('neogit').open()
end, { desc = 'Neogit (repo)' })

-- <leader>gl → repo log
vim.keymap.set('n', '<leader>gl', function()
  require('neogit').open { 'log' }
end, { desc = 'Neogit log (repo)' })

-- <leader>gf → current file history via diffview
vim.keymap.set('n', '<leader>gf', function()
  local file = vim.fn.expand '%'
  if file == '' then
    vim.notify('Neogit: no file open', vim.log.levels.WARN)
    return
  end
  vim.cmd('DiffviewFileHistory ' .. vim.fn.fnameescape(file))
end, { desc = 'Current file history (diffview)' })
