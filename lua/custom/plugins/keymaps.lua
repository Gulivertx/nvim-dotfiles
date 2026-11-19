-- ============================================================
-- Keymaps: LazyVim layout (https://www.lazyvim.org/keymaps)
-- General, search (Telescope), LSP, git, diagnostics, toggles.
-- Plugin-specific keymaps live next to their plugin:
--   bufferline.lua (buffers), neo-tree.lua (explorer),
--   markdown.lua (<leader>um), flash.lua (s / S).
-- ============================================================

-- snacks.nvim is set up in dashboard.lua; adding it here makes it
-- available regardless of the order files in this directory are loaded.
vim.pack.add { 'https://github.com/folke/snacks.nvim' }
local Snacks = require 'snacks'

local map = vim.keymap.set
local builtin = require 'telescope.builtin'

-- Project root: nearest directory with a root marker, or the cwd
local function root()
  return vim.fs.root(0, { '.git', 'composer.json', 'package.json' }) or vim.uv.cwd()
end

-- ── General ────────────────────────────────────────────────
-- Move by display line on wrapped text, unless a count is given
map({ 'n', 'x' }, 'j', "v:count == 0 ? 'gj' : 'j'", { desc = 'Down', expr = true, silent = true })
map({ 'n', 'x' }, '<Down>', "v:count == 0 ? 'gj' : 'j'", { desc = 'Down', expr = true, silent = true })
map({ 'n', 'x' }, 'k', "v:count == 0 ? 'gk' : 'k'", { desc = 'Up', expr = true, silent = true })
map({ 'n', 'x' }, '<Up>', "v:count == 0 ? 'gk' : 'k'", { desc = 'Up', expr = true, silent = true })

-- Resize windows (window navigation with <C-h/j/k/l> is in init.lua)
map('n', '<C-Up>', '<Cmd>resize +2<CR>', { desc = 'Increase Window Height' })
map('n', '<C-Down>', '<Cmd>resize -2<CR>', { desc = 'Decrease Window Height' })
map('n', '<C-Left>', '<Cmd>vertical resize -2<CR>', { desc = 'Decrease Window Width' })
map('n', '<C-Right>', '<Cmd>vertical resize +2<CR>', { desc = 'Increase Window Width' })

-- Move lines
map('n', '<A-j>', "<Cmd>execute 'move .+' . v:count1<CR>==", { desc = 'Move Down' })
map('n', '<A-k>', "<Cmd>execute 'move .-' . (v:count1 + 1)<CR>==", { desc = 'Move Up' })
map('i', '<A-j>', '<Esc><Cmd>m .+1<CR>==gi', { desc = 'Move Down' })
map('i', '<A-k>', '<Esc><Cmd>m .-2<CR>==gi', { desc = 'Move Up' })
map('v', '<A-j>', ":<C-u>execute \"'<,'>move '>+\" . v:count1<CR>gv=gv", { desc = 'Move Down' })
map('v', '<A-k>', ":<C-u>execute \"'<,'>move '<-\" . (v:count1 + 1)<CR>gv=gv", { desc = 'Move Up' })

-- Clear search highlight with <Esc>
map({ 'i', 'n', 's' }, '<Esc>', function()
  vim.cmd 'nohlsearch'
  return '<Esc>'
end, { expr = true, desc = 'Escape and Clear hlsearch' })
map('n', '<leader>ur', '<Cmd>nohlsearch<Bar>diffupdate<Bar>normal! <C-L><CR>', { desc = 'Redraw / Clear hlsearch / Diff Update' })

-- n always searches forward and N backward, whatever the search direction
map('n', 'n', "'Nn'[v:searchforward].'zv'", { expr = true, desc = 'Next Search Result' })
map({ 'x', 'o' }, 'n', "'Nn'[v:searchforward]", { expr = true, desc = 'Next Search Result' })
map('n', 'N', "'nN'[v:searchforward].'zv'", { expr = true, desc = 'Prev Search Result' })
map({ 'x', 'o' }, 'N', "'nN'[v:searchforward]", { expr = true, desc = 'Prev Search Result' })

-- Undo break-points in insert mode
map('i', ',', ',<C-g>u')
map('i', '.', '.<C-g>u')
map('i', ';', ';<C-g>u')

map({ 'i', 'x', 'n', 's' }, '<C-s>', '<Cmd>w<CR><Esc>', { desc = 'Save File' })
map('n', '<leader>K', '<Cmd>norm! K<CR>', { desc = 'Keywordprg' })

-- Keep the selection when indenting
map('x', '<', '<gv')
map('x', '>', '>gv')

-- Comments
map('n', 'gco', 'o<Esc>Vcx<Esc><Cmd>normal gcc<CR>fxa<BS>', { desc = 'Add Comment Below' })
map('n', 'gcO', 'O<Esc>Vcx<Esc><Cmd>normal gcc<CR>fxa<BS>', { desc = 'Add Comment Above' })

map('n', '<leader>fn', '<Cmd>enew<CR>', { desc = 'New File' })
map('n', '<leader>qq', '<Cmd>qa<CR>', { desc = 'Quit All' })
map('n', '<leader>?', function() require('which-key').show { global = false } end, { desc = 'Buffer Keymaps (which-key)' })

-- Inspect highlights / treesitter
map('n', '<leader>ui', vim.show_pos, { desc = 'Inspect Pos' })
map('n', '<leader>uI', function()
  vim.treesitter.inspect_tree()
  vim.api.nvim_input 'I'
end, { desc = 'Inspect Tree' })

-- ── Windows and tabs ───────────────────────────────────────
map('n', '<leader>-', '<C-W>s', { desc = 'Split Window Below', remap = true })
map('n', '<leader>|', '<C-W>v', { desc = 'Split Window Right', remap = true })
map('n', '<leader>wd', '<C-W>c', { desc = 'Delete Window', remap = true })
Snacks.toggle.zoom():map('<leader>wm'):map '<leader>uZ'
Snacks.toggle.zen():map '<leader>uz'

map('n', '<leader><tab>l', '<Cmd>tablast<CR>', { desc = 'Last Tab' })
map('n', '<leader><tab>o', '<Cmd>tabonly<CR>', { desc = 'Close Other Tabs' })
map('n', '<leader><tab>f', '<Cmd>tabfirst<CR>', { desc = 'First Tab' })
map('n', '<leader><tab><tab>', '<Cmd>tabnew<CR>', { desc = 'New Tab' })
map('n', '<leader><tab>]', '<Cmd>tabnext<CR>', { desc = 'Next Tab' })
map('n', '<leader><tab>d', '<Cmd>tabclose<CR>', { desc = 'Close Tab' })
map('n', '<leader><tab>[', '<Cmd>tabprevious<CR>', { desc = 'Previous Tab' })

-- ── Terminal ───────────────────────────────────────────────
map('n', '<leader>fT', function() Snacks.terminal() end, { desc = 'Terminal (cwd)' })
map('n', '<leader>ft', function() Snacks.terminal(nil, { cwd = root() }) end, { desc = 'Terminal (Root Dir)' })
map({ 'n', 't' }, '<C-/>', function() Snacks.terminal(nil, { cwd = root() }) end, { desc = 'Terminal (Root Dir)' })
map({ 'n', 't' }, '<C-_>', function() Snacks.terminal(nil, { cwd = root() }) end, { desc = 'which_key_ignore' })

-- ── Search (Telescope) ─────────────────────────────────────
map('n', '<leader><space>', function() builtin.find_files { cwd = root() } end, { desc = 'Find Files (Root Dir)' })
map('n', '<leader>,', function() builtin.buffers { sort_mru = true, sort_lastused = true } end, { desc = 'Buffers' })
map('n', '<leader>/', function() builtin.live_grep { cwd = root() } end, { desc = 'Grep (Root Dir)' })
map('n', '<leader>:', builtin.command_history, { desc = 'Command History' })

map('n', '<leader>fb', function() builtin.buffers { sort_mru = true, sort_lastused = true } end, { desc = 'Buffers' })
map('n', '<leader>fc', function() builtin.find_files { cwd = vim.fn.stdpath 'config', follow = true } end, { desc = 'Find Config File' })
map('n', '<leader>ff', function() builtin.find_files { cwd = root() } end, { desc = 'Find Files (Root Dir)' })
map('n', '<leader>fF', builtin.find_files, { desc = 'Find Files (cwd)' })
map('n', '<leader>fg', builtin.git_files, { desc = 'Find Files (git-files)' })
map('n', '<leader>fr', builtin.oldfiles, { desc = 'Recent' })
map('n', '<leader>fR', function() builtin.oldfiles { cwd_only = true } end, { desc = 'Recent (cwd)' })
map('n', '<leader>fp', function() Snacks.picker.projects() end, { desc = 'Projects' })

map('n', '<leader>s"', builtin.registers, { desc = 'Registers' })
map('n', '<leader>s/', builtin.search_history, { desc = 'Search History' })
map('n', '<leader>sa', builtin.autocommands, { desc = 'Autocmds' })
map('n', '<leader>sb', builtin.current_buffer_fuzzy_find, { desc = 'Buffer Lines' })
map('n', '<leader>sB', function() builtin.live_grep { grep_open_files = true, prompt_title = 'Grep Open Buffers' } end, { desc = 'Grep Open Buffers' })
map('n', '<leader>sc', builtin.command_history, { desc = 'Command History' })
map('n', '<leader>sC', builtin.commands, { desc = 'Commands' })
map('n', '<leader>sd', builtin.diagnostics, { desc = 'Diagnostics' })
map('n', '<leader>sD', function() builtin.diagnostics { bufnr = 0 } end, { desc = 'Buffer Diagnostics' })
map('n', '<leader>sg', function() builtin.live_grep { cwd = root() } end, { desc = 'Grep (Root Dir)' })
map('n', '<leader>sG', builtin.live_grep, { desc = 'Grep (cwd)' })
map('n', '<leader>sh', builtin.help_tags, { desc = 'Help Pages' })
map('n', '<leader>sH', builtin.highlights, { desc = 'Highlights' })
map('n', '<leader>sj', builtin.jumplist, { desc = 'Jumps' })
map('n', '<leader>sk', builtin.keymaps, { desc = 'Keymaps' })
map('n', '<leader>sl', builtin.loclist, { desc = 'Location List' })
map('n', '<leader>sm', builtin.marks, { desc = 'Marks' })
map('n', '<leader>sM', builtin.man_pages, { desc = 'Man Pages' })
map('n', '<leader>so', builtin.vim_options, { desc = 'Options' })
map('n', '<leader>sq', builtin.quickfix, { desc = 'Quickfix List' })
map('n', '<leader>sR', builtin.resume, { desc = 'Resume' })
map({ 'n', 'x' }, '<leader>sw', function() builtin.grep_string { cwd = root() } end, { desc = 'Word / Selection (Root Dir)' })
map({ 'n', 'x' }, '<leader>sW', builtin.grep_string, { desc = 'Word / Selection (cwd)' })
map('n', '<leader>st', '<Cmd>TodoTelescope<CR>', { desc = 'Todo' })
map('n', '<leader>sT', '<Cmd>TodoTelescope keywords=TODO,FIX,FIXME<CR>', { desc = 'Todo/Fix/Fixme' })
map('n', '<leader>uC', function() builtin.colorscheme { enable_preview = true } end, { desc = 'Colorschemes' })

map('n', ']t', function() require('todo-comments').jump_next() end, { desc = 'Next Todo Comment' })
map('n', '[t', function() require('todo-comments').jump_prev() end, { desc = 'Previous Todo Comment' })

-- ── LSP (buffer-local, when a server attaches) ─────────────
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('custom-lsp-keymaps', { clear = true }),
  callback = function(event)
    local function bmap(mode, lhs, rhs, desc, opts)
      vim.keymap.set(mode, lhs, rhs, vim.tbl_extend('force', { buffer = event.buf, desc = desc }, opts or {}))
    end

    bmap('n', 'gd', function() builtin.lsp_definitions { reuse_win = true } end, 'Goto Definition')
    -- nowait: fire immediately instead of waiting for Neovim's default gr* mappings
    bmap('n', 'gr', builtin.lsp_references, 'References', { nowait = true })
    bmap('n', 'gI', function() builtin.lsp_implementations { reuse_win = true } end, 'Goto Implementation')
    bmap('n', 'gy', function() builtin.lsp_type_definitions { reuse_win = true } end, 'Goto T[y]pe Definition')
    bmap('n', 'gD', vim.lsp.buf.declaration, 'Goto Declaration')
    bmap('n', 'K', function() vim.lsp.buf.hover() end, 'Hover')
    bmap('n', 'gK', function() vim.lsp.buf.signature_help() end, 'Signature Help')
    bmap('i', '<C-k>', function() vim.lsp.buf.signature_help() end, 'Signature Help')

    bmap({ 'n', 'x' }, '<leader>ca', vim.lsp.buf.code_action, 'Code Action')
    bmap({ 'n', 'x' }, '<leader>cc', vim.lsp.codelens.run, 'Run Codelens')
    bmap('n', '<leader>cC', vim.lsp.codelens.refresh, 'Refresh & Display Codelens')
    bmap('n', '<leader>cr', vim.lsp.buf.rename, 'Rename')
    bmap('n', '<leader>cR', function() Snacks.rename.rename_file() end, 'Rename File')
    bmap('n', '<leader>cA', function() vim.lsp.buf.code_action { context = { only = { 'source' }, diagnostics = {} } } end, 'Source Action')
    bmap('n', '<leader>co', function() vim.lsp.buf.code_action { apply = true, context = { only = { 'source.organizeImports' }, diagnostics = {} } } end, 'Organize Imports')

    bmap('n', '<leader>ss', builtin.lsp_document_symbols, 'LSP Symbols')
    bmap('n', '<leader>sS', builtin.lsp_dynamic_workspace_symbols, 'LSP Workspace Symbols')
  end,
})

map('n', '<leader>cl', '<Cmd>checkhealth vim.lsp<CR>', { desc = 'Lsp Info' })
map('n', '<leader>cm', '<Cmd>Mason<CR>', { desc = 'Mason' })
map({ 'n', 'x' }, '<leader>cf', function() require('conform').format { async = true } end, { desc = 'Format' })

-- ── Diagnostics and quickfix ───────────────────────────────
local function diagnostic_goto(next, severity)
  return function() vim.diagnostic.jump { count = (next and 1 or -1) * vim.v.count1, severity = severity, float = true } end
end
map('n', '<leader>cd', vim.diagnostic.open_float, { desc = 'Line Diagnostics' })
map('n', ']d', diagnostic_goto(true), { desc = 'Next Diagnostic' })
map('n', '[d', diagnostic_goto(false), { desc = 'Prev Diagnostic' })
map('n', ']e', diagnostic_goto(true, vim.diagnostic.severity.ERROR), { desc = 'Next Error' })
map('n', '[e', diagnostic_goto(false, vim.diagnostic.severity.ERROR), { desc = 'Prev Error' })
map('n', ']w', diagnostic_goto(true, vim.diagnostic.severity.WARN), { desc = 'Next Warning' })
map('n', '[w', diagnostic_goto(false, vim.diagnostic.severity.WARN), { desc = 'Prev Warning' })

map('n', '<leader>xl', function()
  local ok, err = pcall(vim.fn.getloclist(0, { winid = 0 }).winid ~= 0 and vim.cmd.lclose or vim.cmd.lopen)
  if not ok and err then vim.notify(err, vim.log.levels.ERROR) end
end, { desc = 'Location List' })
map('n', '<leader>xq', function()
  local ok, err = pcall(vim.fn.getqflist({ winid = 0 }).winid ~= 0 and vim.cmd.cclose or vim.cmd.copen)
  if not ok and err then vim.notify(err, vim.log.levels.ERROR) end
end, { desc = 'Quickfix List' })
map('n', '[q', vim.cmd.cprev, { desc = 'Previous Quickfix' })
map('n', ']q', vim.cmd.cnext, { desc = 'Next Quickfix' })

-- ── Git ────────────────────────────────────────────────────
-- <leader>gg / <leader>gl / <leader>gf: Neogit, defined in neogit.lua
map('n', '<leader>gG', function() Snacks.lazygit() end, { desc = 'Lazygit (cwd)' })
map('n', '<leader>gL', function() Snacks.lazygit.log() end, { desc = 'Git Log (cwd)' })
map('n', '<leader>gb', function() Snacks.git.blame_line() end, { desc = 'Git Blame Line' })
map({ 'n', 'x' }, '<leader>gB', function() Snacks.gitbrowse() end, { desc = 'Git Browse (open)' })
map({ 'n', 'x' }, '<leader>gY', function()
  Snacks.gitbrowse { open = function(url) vim.fn.setreg('+', url) end, notify = false }
end, { desc = 'Git Browse (copy)' })
map('n', '<leader>gc', builtin.git_commits, { desc = 'Commits' })
map('n', '<leader>gs', builtin.git_status, { desc = 'Git Status' })

-- Hunks (gitsigns)
local gitsigns = require 'gitsigns'
map('n', ']h', function()
  if vim.wo.diff then return vim.cmd.normal { ']c', bang = true } end
  gitsigns.nav_hunk 'next'
end, { desc = 'Next Hunk' })
map('n', '[h', function()
  if vim.wo.diff then return vim.cmd.normal { '[c', bang = true } end
  gitsigns.nav_hunk 'prev'
end, { desc = 'Prev Hunk' })
map('n', ']H', function() gitsigns.nav_hunk 'last' end, { desc = 'Last Hunk' })
map('n', '[H', function() gitsigns.nav_hunk 'first' end, { desc = 'First Hunk' })
map({ 'n', 'x' }, '<leader>ghs', '<Cmd>Gitsigns stage_hunk<CR>', { desc = 'Stage Hunk' })
map({ 'n', 'x' }, '<leader>ghr', '<Cmd>Gitsigns reset_hunk<CR>', { desc = 'Reset Hunk' })
map('n', '<leader>ghS', gitsigns.stage_buffer, { desc = 'Stage Buffer' })
map('n', '<leader>ghu', gitsigns.undo_stage_hunk, { desc = 'Undo Stage Hunk' })
map('n', '<leader>ghR', gitsigns.reset_buffer, { desc = 'Reset Buffer' })
map('n', '<leader>ghp', gitsigns.preview_hunk_inline, { desc = 'Preview Hunk Inline' })
map('n', '<leader>ghb', function() gitsigns.blame_line { full = true } end, { desc = 'Blame Line' })
map('n', '<leader>ghB', function() gitsigns.blame() end, { desc = 'Blame Buffer' })
map('n', '<leader>ghd', gitsigns.diffthis, { desc = 'Diff This' })
map('n', '<leader>ghD', function() gitsigns.diffthis '~' end, { desc = 'Diff This ~' })
map({ 'o', 'x' }, 'ih', '<Cmd>Gitsigns select_hunk<CR>', { desc = 'GitSigns Select Hunk' })

-- ── UI toggles ─────────────────────────────────────────────
Snacks.toggle.option('spell', { name = 'Spelling' }):map '<leader>us'
Snacks.toggle.option('wrap', { name = 'Wrap' }):map '<leader>uw'
Snacks.toggle.option('relativenumber', { name = 'Relative Number' }):map '<leader>uL'
Snacks.toggle.diagnostics():map '<leader>ud'
Snacks.toggle.line_number():map '<leader>ul'
Snacks.toggle.option('conceallevel', { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2, name = 'Conceal Level' }):map '<leader>uc'
Snacks.toggle.option('showtabline', { off = 0, on = vim.o.showtabline > 0 and vim.o.showtabline or 2, name = 'Tabline' }):map '<leader>uA'
Snacks.toggle.treesitter():map '<leader>uT'
Snacks.toggle.option('background', { off = 'light', on = 'dark', name = 'Dark Background' }):map '<leader>ub'
Snacks.toggle.inlay_hints():map '<leader>uh'
