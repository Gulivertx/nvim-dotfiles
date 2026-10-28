-- ============================================================
-- Gamedev: Godot / GDScript support
-- Project detection, LSP, launching Godot
-- ============================================================

local GODOT_BIN = '/Applications/Godot.app/Contents/MacOS/Godot'
local GODOT_LSP_PORT = 6005

-- Find the root of the current Godot project (the directory holding project.godot)
local function find_godot_project_root()
  local path = vim.fn.expand '%:p:h'
  while path ~= '/' do
    if vim.uv.fs_stat(path .. '/project.godot') then return path end
    path = vim.fn.fnamemodify(path, ':h')
  end
  return nil
end

vim.api.nvim_create_user_command('GodotOpen', function()
  local root = find_godot_project_root()
  if not root then
    vim.notify('No project.godot found', vim.log.levels.WARN)
    return
  end
  vim.notify('Opening Godot: ' .. root, vim.log.levels.INFO)
  vim.fn.jobstart({ GODOT_BIN, '--path', root }, { detach = true })
end, { desc = 'Open Godot for the current project' })

-- Keymap: <leader>go = open Godot
vim.keymap.set('n', '<leader>go', '<Cmd>GodotOpen<CR>', { desc = '[G]odot [O]pen editor' })

-- Warn when opening a .gd file while Godot (LSP port 6005) is not running
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'gdscript',
  once = false,
  callback = function()
    vim.defer_fn(function()
      -- Check whether the gdscript LSP is attached to the buffer
      local clients = vim.lsp.get_clients { bufnr = 0, name = 'gdscript' }
      if #clients == 0 then
        vim.notify(
          'GDScript LSP not connected (port ' .. GODOT_LSP_PORT .. ')\n'
          .. 'Run :GodotOpen to start Godot.',
          vim.log.levels.WARN
        )
      end
    end, 2000) -- give the LSP 2s to try connecting
  end,
})

-- Godot file types
-- .gd = GDScript, .tscn = scenes, .tres = resources, .gdshader = shaders
vim.filetype.add {
  extension = {
    gd       = 'gdscript',   -- GDScript (LSP + highlight)
    tscn     = 'gdresource', -- Godot scenes
    tres     = 'gdresource', -- Godot resources
    gdshader = 'gdshader',   -- Godot shaders
  },
  -- Detection by file name: project.godot → dedicated type
  filename = {
    ['project.godot'] = 'gdproject',
  },
}
