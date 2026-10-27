-- All OS-specific discovery lives here. No machine/user name is hardcoded.
local M = {}

-- Pure decision function, also tested with macOS paths on Linux.
function M.plan(os_name, home)
  local dirs = { home .. '/.local/bin' }
  if os_name == 'Darwin' then
    vim.list_extend(dirs, { '/opt/homebrew/bin', '/usr/local/bin', '/Library/TeX/texbin' })
  elseif os_name == 'Linux' then
    vim.list_extend(dirs, { '/usr/bin/site_perl', '/usr/bin/vendor_perl', '/usr/bin/core_perl' })
  end
  return { paths = dirs, viewer = os_name == 'Darwin' and 'skim' or 'zathura_simple' }
end

function M.executable(name) return type(name) == 'string' and vim.fn.executable(vim.fn.expand(name)) == 1 end

function M.clipboard_available()
  if vim.fn.has 'mac' == 1 then return M.executable 'pbcopy' and M.executable 'pbpaste' end
  if vim.env.WAYLAND_DISPLAY and M.executable 'wl-copy' and M.executable 'wl-paste' then return true end
  if vim.env.DISPLAY and (M.executable 'xclip' or M.executable 'xsel') then return true end
  return false
end

function M.viewer()
  local choice = require('config.settings').viewer
  if choice ~= 'auto' then return choice end
  return M.plan(vim.uv.os_uname().sysname, vim.fn.expand '~').viewer
end

function M.claude()
  local override = require('config.settings').claude
  if override then return M.executable(override) and vim.fn.expand(override) or nil end
  local found = vim.fn.exepath 'claude'
  return found ~= '' and found or nil
end

function M.setup()
  local paths = vim.split(vim.env.PATH or '', ':', { plain = true })
  for _, dir in ipairs(M.plan(vim.uv.os_uname().sysname, vim.fn.expand '~').paths) do
    if vim.fn.isdirectory(dir) == 1 and not vim.tbl_contains(paths, dir) then paths[#paths + 1] = dir end
  end
  vim.env.PATH = table.concat(paths, ':')
  local host = require('config.settings').python_host
  if host and M.executable(host) then vim.g.python3_host_prog = vim.fn.expand(host) end
end

return M
