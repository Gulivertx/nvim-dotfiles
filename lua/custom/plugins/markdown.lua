-- ============================================================
-- Rendu Markdown dans le buffer (render-markdown.nvim)
-- ============================================================

vim.pack.add {
  { src = 'https://github.com/MeanderingProgrammer/render-markdown.nvim', version = vim.version.range '*' },
}

-- S'assure que le parser treesitter markdown est installé
pcall(function()
  require('nvim-treesitter').install { 'markdown', 'markdown_inline' }
end)

require('render-markdown').setup {
  -- Affiche le rendu en mode normal, et le markdown brut en mode insertion
  render_modes = { 'n', 'c', 't' },
  completions = { lsp = { enabled = true } },
}

-- Bascule rendu / brut
vim.keymap.set('n', '<leader>tm', '<Cmd>RenderMarkdown toggle<CR>', { desc = '[T]oggle [M]arkdown render' })
