-- ============================================================
-- In-buffer Markdown rendering (render-markdown.nvim)
-- ============================================================

vim.pack.add {
  { src = 'https://github.com/MeanderingProgrammer/render-markdown.nvim', version = vim.version.range '*' },
}

-- Make sure the markdown treesitter parsers are installed
pcall(function()
  require('nvim-treesitter').install { 'markdown', 'markdown_inline' }
end)

require('render-markdown').setup {
  -- Render in normal mode, show raw markdown in insert mode
  render_modes = { 'n', 'c', 't' },
  completions = { lsp = { enabled = true } },
}

-- Toggle rendered / raw
vim.keymap.set('n', '<leader>tm', '<Cmd>RenderMarkdown toggle<CR>', { desc = '[T]oggle [M]arkdown render' })
