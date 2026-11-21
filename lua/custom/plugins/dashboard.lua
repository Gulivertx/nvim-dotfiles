-- ============================================================
-- Dashboard / start screen via snacks.nvim
-- Loaded automatically by lua/custom/plugins/init.lua
-- ============================================================

-- Plugin install (vim.pack = built-in manager, as in init.lua)
vim.pack.add { 'https://github.com/folke/snacks.nvim' }

-- Git keymaps are in keymaps.lua (Neogit: <leader>gg/gl/gf in neogit.lua)

-- Header: one color per letter of "GULIVERT".
-- Each letter is a column of the ASCII art (widths in display cells);
-- the highlight groups GulivertLetter1..8 are defined in snacks-theme.lua.
local header_lines = {
  ' ██████╗ ██╗   ██╗██╗     ██╗██╗   ██╗███████╗██████╗ ████████╗',
  '██╔════╝ ██║   ██║██║     ██║██║   ██║██╔════╝██╔══██╗╚══██╔══╝',
  '██║  ███╗██║   ██║██║     ██║██║   ██║█████╗  ██████╔╝   ██║   ',
  '██║   ██║██║   ██║██║     ██║╚██╗ ██╔╝██╔══╝  ██╔══██╗   ██║   ',
  '╚██████╔╝╚██████╔╝███████╗██║ ╚████╔╝ ███████╗██║  ██║   ██║   ',
  ' ╚═════╝  ╚═════╝ ╚══════╝╚═╝  ╚═══╝  ╚══════╝╚═╝  ╚═╝   ╚═╝   ',
}
local letter_widths = { 9, 9, 8, 3, 9, 8, 8, 9 } -- G U L I V E R T

local header = {}
for l, line in ipairs(header_lines) do
  local col = 0
  for i, width in ipairs(letter_widths) do
    local text = vim.fn.strcharpart(line, col, width)
    if i == #letter_widths and l < #header_lines then
      text = text .. '\n'
    end
    header[#header + 1] = { text, hl = 'GulivertLetter' .. i }
    col = col + width
  end
end

-- Right pane, top: a row of small motifs, one per palette color
-- (highlight groups DashboardSwatch1..6 are defined in snacks-theme.lua).
local swatch_lines = { '█ ▄ █', '▄▀█▀▄', '▀ ▀ ▀' }
local swatch_count = 6
local swatches = {}
for l, line in ipairs(swatch_lines) do
  for i = 1, swatch_count do
    local text = line .. (i < swatch_count and '   ' or (l < #swatch_lines and '\n' or ''))
    swatches[#swatches + 1] = { text, hl = 'DashboardSwatch' .. i }
  end
end

require('snacks').setup {
  -- Only the modules below are enabled; other snacks modules
  -- (notifier, terminal, etc.) can be enabled later.
  projects = { enabled = true }, -- recent project detection
  -- Snacks picker (required for Snacks.picker.projects()): project detection
  -- settings, with the root markers and the dev directories
  picker = {
    enabled = true,
    sources = {
      projects = {
        dev = { '~/develop', '~/dev', '~/projects' },
        patterns = {
          '.git',           -- git
          'package.json',   -- Node / web
          'Makefile',       -- C/C++
          'Cargo.toml',     -- Rust
          'go.mod',         -- Go
          'pyproject.toml', -- Python
        },
      },
    },
  },
  lazygit = { enabled = true }, -- floating lazygit integration
  dashboard = {
    enabled = true,
    preset = {
      -- Shortcuts shown on the start screen
      keys = {
        { icon = ' ', key = 'f', desc = 'Find file',          action = ':lua Snacks.dashboard.pick("files")' },
        { icon = ' ', key = 'n', desc = 'New file',           action = ':ene | startinsert' },
        { icon = ' ', key = 'g', desc = 'Search text',        action = ':lua Snacks.dashboard.pick("live_grep")' },
        { icon = ' ', key = 'p', desc = 'Projects',           action = ':lua Snacks.picker.projects()' },
        { icon = ' ', key = 'r', desc = 'Recent files',       action = ':lua Snacks.dashboard.pick("oldfiles")' },
        { icon = ' ', key = 'c', desc = 'Neovim config',      action = ":lua Snacks.dashboard.pick('files', { cwd = vim.fn.stdpath('config') })" },
        { icon = ' ', key = 'q', desc = 'Quit',               action = ':qa' },
      },
    },
    sections = {
      { text = header, align = 'center', padding = 2 },
      { section = 'keys', gap = 1, padding = 1 },
      -- No 'startup' section: it depends on lazy.nvim (not used here, this config uses vim.pack)

      -- Right pane (snacks folds it under the left one when the window is too narrow)
      { pane = 2, text = swatches, align = 'center', padding = 2 },
      { pane = 2, icon = '\u{f15b} ', title = 'Recent Files', section = 'recent_files', indent = 2, padding = 1 },
      { pane = 2, icon = '\u{f07c} ', title = 'Projects', section = 'projects', indent = 2, padding = 1 },
      {
        pane = 2,
        icon = '\u{e725} ',
        title = 'Git Status',
        section = 'terminal',
        enabled = function()
          return Snacks.git.get_root() ~= nil
        end,
        cmd = 'git status --short --branch --renames',
        height = 5,
        padding = 1,
        ttl = 5 * 60, -- cache the output for 5 minutes
        indent = 3,
      },
    },
  },
}
