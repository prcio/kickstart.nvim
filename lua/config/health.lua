local M = {}

function M.check()
  local platform = require 'config.platform'
  local settings = require 'config.settings'
  vim.health.start 'Portable Neovim configuration'
  if vim.fn.has 'nvim-0.12' == 1 then
    vim.health.ok 'Neovim 0.12+ and vim.pack available'
  else
    vim.health.error 'Install Neovim 0.12 or newer; this config does not support 0.11.'
  end
  for _, name in ipairs { 'git', 'make', 'cc', 'unzip', 'rg', 'node', 'python3', 'tree-sitter' } do
    if platform.executable(name) then
      vim.health.ok(name .. ': ' .. vim.fn.exepath(name))
    else
      vim.health.warn(name .. ' missing; see README.md prerequisites for affected features')
    end
  end
  if platform.clipboard_available() then
    vim.health.ok 'System clipboard available'
  else
    vim.health.warn 'No desktop clipboard detected; ordinary Vim registers still work (normal over SSH).'
  end
  if settings.latex then
    vim.health.info('PDF viewer: ' .. platform.viewer())
    for _, name in ipairs { 'latexmk', 'biber', 'pdflatex' } do
      if platform.executable(name) then
        vim.health.ok(name .. ' available')
      else
        vim.health.warn(name .. ' missing: install TeX tools for LaTeX')
      end
    end
    if platform.viewer() == 'zathura_simple' and not platform.executable 'zathura' then
      vim.health.warn 'Zathura is missing; install it or override viewer in local.lua.'
    end
    if platform.viewer() == 'skim' then
      vim.health.info 'Install Skim and configure inverse search as described in README.md (not probed by launching apps).'
    end
  end
  if settings.ai and not platform.claude() then vim.health.info 'Claude executable absent: optional AI integration skipped.' end
  if settings.python_host and not platform.executable(settings.python_host) then vim.health.warn 'Configured Python provider is not executable.' end
  vim.health.info('Automatic tool/parser installation: ' .. tostring(settings.auto_install))
  vim.health.info 'Terminal notebook/Molten execution is disabled. Use Code or Jupyter for notebooks.'
end

return M
