-- Run: nvim --clean -l /path/to/nvim/tests/portable.lua
local file = debug.getinfo(1, 'S').source:sub(2)
local root = vim.fs.dirname(vim.fs.dirname(vim.fn.fnamemodify(file, ':p')))
vim.opt.runtimepath:prepend(root)
local platform = require 'config.platform'
local settings = require 'config.settings'
local mac = platform.plan('Darwin', '/Users/example')
local linux = platform.plan('Linux', '/home/example')
assert(mac.viewer == 'skim' and linux.viewer == 'zathura_simple')
assert(vim.tbl_contains(mac.paths, '/opt/homebrew/bin'))
assert(vim.tbl_contains(mac.paths, '/usr/local/bin'))
assert(vim.tbl_contains(mac.paths, '/Library/TeX/texbin'))
assert(not vim.tbl_contains(mac.paths, '/usr/bin/vendor_perl'))
assert(vim.tbl_contains(linux.paths, '/usr/bin/vendor_perl'))
local path_before = vim.env.PATH
platform.setup()
local once = vim.env.PATH
platform.setup()
assert(vim.env.PATH == once, 'PATH entries must not duplicate')
vim.env.PATH = path_before

local viewer = settings.viewer
settings.viewer = 'general'
assert(platform.viewer() == 'general')
settings.viewer = viewer
local uname = vim.uv.os_uname
vim.uv.os_uname = function() return { sysname = 'Darwin' } end
assert(platform.viewer() == 'skim')
vim.uv.os_uname = uname

-- A missing optional executable must not cause a startup error.
local exepath = vim.fn.exepath
vim.fn.exepath = function() return '' end
assert(platform.claude() == nil)
vim.fn.exepath = exepath

-- Overrides are local to the copied config and reject misspelled settings.
local scratch = vim.fn.tempname()
vim.fn.mkdir(scratch, 'p')
local stdpath = vim.fn.stdpath
vim.fn.stdpath = function(kind) return kind == 'config' and scratch or stdpath(kind) end
vim.fn.writefile({ 'return { nerd_font = false, auto_install = false, viewer = "skim" }' }, scratch .. '/local.lua')
local overridden = dofile(root .. '/lua/config/settings.lua')
assert(not overridden.nerd_font and not overridden.auto_install and overridden.viewer == 'skim')
vim.fn.writefile({ 'return { typo = true }' }, scratch .. '/local.lua')
assert(not pcall(dofile, root .. '/lua/config/settings.lua'))
vim.fn.stdpath = stdpath
vim.fn.delete(scratch, 'rf')

-- Older Neovim must stop before touching plugin APIs.
local has, notify = vim.fn.has, vim.notify
local warned = false
vim.fn.has = function(feature) return feature == 'nvim-0.12' and 0 or has(feature) end
vim.notify = function(message) warned = message:find('0.12', 1, true) ~= nil end
dofile(root .. '/init.lua')
assert(warned)
vim.fn.has, vim.notify = has, notify

for _, path in ipairs(vim.fn.glob(root .. '/lua/**/*.lua', false, true)) do
  assert(loadfile(path))
end
print 'PASS: Linux/macOS decisions, PATH idempotence, optional executable, local overrides, version guard, Lua syntax'
