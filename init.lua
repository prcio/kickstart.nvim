-- Portable macOS/Linux setup. See README.md and lua/config/settings.lua.
if vim.fn.has 'nvim-0.12' ~= 1 then
  vim.notify('This configuration needs Neovim 0.12+ (vim.pack). Start with nvim --clean or upgrade Neovim.', vim.log.levels.ERROR)
  return
end

require('config.platform').setup()
require 'config.options'
require 'config.keymaps'
require 'config.packages'

-- Explicit order: UI before extensions; LSP before completion.
for _, name in ipairs { 'ui', 'search', 'lsp', 'formatting', 'completion', 'treesitter', 'extras' } do
  require('plugins.' .. name)
end
