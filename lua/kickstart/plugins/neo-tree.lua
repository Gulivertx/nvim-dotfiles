-- Neo-tree is a Neovim plugin to browse the file system
-- https://github.com/nvim-neo-tree/neo-tree.nvim

vim.pack.add {
  { src = 'https://github.com/nvim-neo-tree/neo-tree.nvim', version = vim.version.range '*' },
  'https://github.com/nvim-lua/plenary.nvim',
  'https://github.com/MunifTanjim/nui.nvim',
}

-- ── Global keymaps (LazyVim layout) ────────────────────────────────────────
local function root() return vim.fs.root(0, { '.git', 'composer.json', 'package.json' }) or vim.uv.cwd() end
local function explorer(dir) return function() require('neo-tree.command').execute { toggle = true, dir = dir() } end end

vim.keymap.set('n', '<leader>fe', explorer(root), { desc = 'Explorer NeoTree (Root Dir)' })
vim.keymap.set('n', '<leader>fE', explorer(vim.uv.cwd), { desc = 'Explorer NeoTree (cwd)' })
vim.keymap.set('n', '<leader>e', '<leader>fe', { desc = 'Explorer NeoTree (Root Dir)', remap = true })
vim.keymap.set('n', '<leader>E', '<leader>fE', { desc = 'Explorer NeoTree (cwd)', remap = true })
vim.keymap.set('n', '<leader>ge', function() require('neo-tree.command').execute { source = 'git_status', toggle = true } end, { desc = 'Git Explorer' })
vim.keymap.set('n', '<leader>be', function() require('neo-tree.command').execute { source = 'buffers', toggle = true } end, { desc = 'Buffer Explorer' })

require('neo-tree').setup {
  filesystem = {
    use_libuv_file_watcher = true,            -- watch the disk in real time (agents, git...)
    follow_current_file = { enabled = true }, -- highlight the current file
    hijack_netrw_behavior = 'open_current',   -- replace netrw
  },
  window = {
    width = 35,
    -- LazyVim mappings, on top of the neo-tree defaults (press ? in the tree)
    mappings = {
      ['l'] = 'open',
      ['h'] = 'close_node',
      ['<space>'] = 'none',
      ['Y'] = {
        function(state) vim.fn.setreg('+', state.tree:get_node():get_id(), 'c') end,
        desc = 'Copy Path to Clipboard',
      },
      ['O'] = {
        function(state) vim.ui.open(state.tree:get_node().path) end,
        desc = 'Open with System Application',
      },
      ['P'] = { 'toggle_preview', config = { use_float = false } },
    },
  },
}
