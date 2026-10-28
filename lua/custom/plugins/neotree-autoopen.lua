-- ============================================================
-- Open Neo-tree automatically on startup when inside a project.
-- A "project" = the cwd contains one of these root markers.
-- Does not trigger when nvim is started on a specific file or from a pipe.
-- ============================================================

local project_markers = {
  '.git',
  'composer.json', -- PHP / Symfony projects
  'package.json', -- JS/TS projects
  'devenv.nix', -- devenv projects
  '.luarc.json',
}

local function in_project()
  for _, marker in ipairs(project_markers) do
    if vim.uv.fs_stat(vim.fn.getcwd() .. '/' .. marker) then return true end
  end
  return false
end

-- Detect input coming from a pipe / stdin (e.g. `cat f | nvim -`)
local stdin_read = false
vim.api.nvim_create_autocmd('StdinReadPre', {
  callback = function() stdin_read = true end,
})

vim.api.nvim_create_autocmd('VimEnter', {
  desc = 'Open Neo-tree on startup when inside a project',
  callback = function()
    -- Do nothing if files were passed as arguments
    if vim.fn.argc() > 0 then return end
    -- Do nothing if input comes from a pipe / stdin
    if stdin_read then return end
    if not in_project() then return end

    -- `show` opens the sidebar WITHOUT focusing it,
    -- so the dashboard stays active in the main window.
    vim.schedule(function() vim.cmd 'Neotree show left' end)
  end,
})
