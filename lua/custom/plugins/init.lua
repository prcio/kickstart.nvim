-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
return {
  {
    'prcio/startup.nvim',  -- Startup screen with custom theme
    requires = { 'nvim-telescope/telescope.nvim', 'nvim-lua/plenary.nvim' },
    config = function()
      require('startup').setup { theme = 'evil' }
    end,
  },
  {
    'ThePrimeagen/harpoon',  -- Quick file navigation
    branch = 'harpoon2',
    dependencies = { 'nvim-lua/plenary.nvim' },
  },
  'nvim-tree/nvim-web-devicons',  -- Adds icons for file types
  'echasnovski/mini.base16',  -- Color scheme based on base16
  {
    'nvim-tree/nvim-tree.lua',  -- File explorer
    version = '*',
    lazy = false,
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      require('nvim-tree').setup {}
    end,
  },
}

