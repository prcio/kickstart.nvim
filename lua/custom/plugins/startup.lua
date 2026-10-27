-- Startup screen: upstream startup.nvim with Dennis's ported "evil"/Berserk theme.
-- The old fork (prcio/startup.nvim) used APIs deprecated in Neovim 0.10+; upstream has fixed them.
vim.pack.add {
  'https://github.com/nvim-lua/plenary.nvim',
  'https://github.com/startup-nvim/startup.nvim',
}

require('startup').setup(require 'custom.startup_theme')
