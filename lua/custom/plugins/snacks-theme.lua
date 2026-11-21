-- ============================================================
-- Align the background of snacks floating windows (picker, etc.)
-- with the editor background.
-- By default snacks links SnacksNormal -> NormalFloat, which the
-- xcode theme renders differently from the main background (Normal).
-- ============================================================

local function link_snacks_highlights()
  local links = {
    SnacksNormal = 'Normal', -- snacks window background = editor background
    SnacksNormalNC = 'Normal', -- same when the window is not focused
    SnacksBackdrop = 'Normal', -- remove the dimmed backdrop
    -- The picker remaps NormalFloat to these groups per sub-window:
    SnacksPicker = 'Normal', -- the outer box
    SnacksPickerList = 'Normal', -- the results list
    SnacksPickerInput = 'Normal', -- the input field
    SnacksPickerPreview = 'Normal', -- the preview
    SnacksPickerBox = 'Normal',
    -- Borders / titles: same background as the editor
    SnacksPickerBorder = 'Normal',
    SnacksPickerTitle = 'Normal',
    SnacksPickerFooter = 'Normal',
    SnacksPickerListBorder = 'Normal',
    SnacksPickerInputBorder = 'Normal',
    SnacksPickerPreviewBorder = 'Normal',
    SnacksPickerPreviewTitle = 'Normal',
    SnacksPickerInputTitle = 'Normal',
  }
  for group, target in pairs(links) do
    vim.api.nvim_set_hl(0, group, { link = target })
  end

  -- Dashboard (start screen): colors from the Xcode Dark palette.
  local xcode = require 'custom.xcode'
  local dashboard = {
    SnacksDashboardIcon = { fg = xcode.blue }, -- shortcut icons
    SnacksDashboardDesc = { fg = xcode.fg }, -- shortcut labels
    SnacksDashboardKey = { fg = xcode.pink, bold = true }, -- the key to press
    SnacksDashboardTitle = { fg = xcode.purple, bold = true }, -- section titles
    SnacksDashboardSpecial = { fg = xcode.orange },
    SnacksDashboardFile = { fg = xcode.cyan }, -- recent files / projects
    SnacksDashboardDir = { fg = xcode.comment },
    SnacksDashboardFooter = { fg = xcode.comment },
  }
  -- ASCII logo: one palette color per letter of "GULIVERT"
  local letters = { 'pink', 'salmon', 'orange', 'yellow', 'green', 'teal', 'blue', 'purple' }
  for i, color in ipairs(letters) do
    dashboard['GulivertLetter' .. i] = { fg = xcode[color], bold = true }
  end
  -- Motifs at the top of the right pane
  local swatches = { 'pink', 'green', 'orange', 'blue', 'purple', 'cyan' }
  for i, color in ipairs(swatches) do
    dashboard['DashboardSwatch' .. i] = { fg = xcode[color] }
  end
  for group, opts in pairs(dashboard) do
    vim.api.nvim_set_hl(0, group, opts)
  end
end

vim.api.nvim_create_autocmd('ColorScheme', {
  desc = 'Align snacks float background with editor background',
  callback = link_snacks_highlights,
})

link_snacks_highlights()

-- ------------------------------------------------------------
-- Logo animation: the colors slide from letter to letter (wave).
-- Only the 8 highlight groups are redefined, the buffer is untouched.
-- The timer runs only while a dashboard is visible.
-- ------------------------------------------------------------
local wave_colors = { 'pink', 'salmon', 'orange', 'yellow', 'green', 'teal', 'blue', 'purple' }
local wave_interval = 150 -- ms between two steps
local wave_timer, wave_offset = nil, 0

local function dashboard_visible()
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    if vim.bo[vim.api.nvim_win_get_buf(win)].filetype == 'snacks_dashboard' then
      return true
    end
  end
  return false
end

local function stop_wave()
  if wave_timer then
    wave_timer:stop()
    wave_timer:close()
    wave_timer = nil
  end
end

local function start_wave()
  if wave_timer then
    return
  end
  local xcode = require 'custom.xcode'
  wave_timer = vim.uv.new_timer()
  wave_timer:start(wave_interval, wave_interval, vim.schedule_wrap(function()
    if not dashboard_visible() then
      return stop_wave()
    end
    wave_offset = (wave_offset + 1) % #wave_colors
    for i = 1, #wave_colors do
      -- letter i takes the color of its left neighbour: the wave moves right
      local color = wave_colors[(i - 1 - wave_offset) % #wave_colors + 1]
      vim.api.nvim_set_hl(0, 'GulivertLetter' .. i, { fg = xcode[color], bold = true })
    end
  end))
end

vim.api.nvim_create_autocmd('User', {
  pattern = 'SnacksDashboardOpened',
  desc = 'Animate the dashboard logo',
  callback = start_wave,
})
-- The dashboard may already be open when this file is loaded.
vim.api.nvim_create_autocmd('VimEnter', { callback = vim.schedule_wrap(function()
  if dashboard_visible() then
    start_wave()
  end
end) })
