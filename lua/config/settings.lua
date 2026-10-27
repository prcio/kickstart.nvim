-- Shared defaults. Machine-specific overrides belong in ignored local.lua.
local defaults = {
  nerd_font = true,
  auto_install = true, -- Mason tools and Treesitter parsers; plugins use vim.pack.
  latex = true,
  ai = true, -- Loaded only when the Claude executable is available.
  viewer = 'auto', -- Skim on macOS, zathura_simple on Linux.
  python_host = false, -- Optional absolute path to a Python with pynvim installed.
  claude = false, -- Optional executable override; otherwise discovered on PATH.
}
local path = vim.fs.joinpath(vim.fn.stdpath 'config', 'local.lua')
if vim.uv.fs_stat(path) then
  local ok, overrides = pcall(dofile, path)
  if not ok or type(overrides) ~= 'table' then error('Invalid local.lua: expected a Lua file returning a settings table. ' .. tostring(overrides)) end
  for key in pairs(overrides) do
    if defaults[key] == nil then error('Unknown local.lua setting: ' .. tostring(key)) end
    local value = overrides[key]
    if key == 'python_host' or key == 'claude' then
      if value ~= false and type(value) ~= 'string' then error(key .. ' must be false or an executable path') end
    elseif type(value) ~= type(defaults[key]) then
      error('Wrong type for local.lua setting: ' .. key)
    end
  end
  defaults = vim.tbl_deep_extend('force', defaults, overrides)
end
return defaults
