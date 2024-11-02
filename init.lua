-- Disable Netrw to avoid conflicts with file explorer plugins
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.opt.termguicolors = true  -- Enable true color support

-- Leader key settings
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Set Nerd Font availability
vim.g.have_nerd_font = true

-- UI and Editor Behavior
vim.opt.number = true                -- Show line numbers
vim.opt.mouse = 'a'                  -- Enable mouse mode
vim.opt.showmode = false             -- Don't display mode (e.g., -- INSERT --) in command line
vim.schedule(function()
  vim.opt.clipboard = 'unnamedplus'  -- Sync clipboard with OS
end)
vim.opt.breakindent = true           -- Enable break indent
vim.opt.undofile = true              -- Save undo history across sessions
vim.opt.ignorecase = true            -- Case insensitive search
vim.opt.smartcase = true             -- But be case sensitive if query contains capital letters
vim.opt.signcolumn = 'yes'           -- Always show sign column
vim.opt.updatetime = 250             -- Faster update time for better UI feedback
vim.opt.timeoutlen = 300             -- Shorter timeout for mapped sequences
vim.opt.splitright = true            -- Open new vertical splits to the right
vim.opt.splitbelow = true            -- Open new horizontal splits below
vim.opt.list = true                  -- Show special characters like tabs
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }
vim.opt.inccommand = 'split'         -- Live preview for search/replace
vim.opt.cursorline = true            -- Highlight the current line
vim.opt.scrolloff = 10               -- Keep cursor away from screen edge

-- Keymaps for navigation and functionality
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')  -- Clear search highlights
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- Arduino Keymaps
local function open_split_term(cmd)
  vim.cmd('split')  -- Open a horizontal split
  vim.cmd('resize 15')  -- Resize to 15 lines high
  local buf = vim.api.nvim_create_buf(false, true)  -- Create a new buffer
  vim.api.nvim_set_current_buf(buf)  -- Set buffer to split window
  vim.fn.termopen(cmd)  -- Run command in terminal
  vim.cmd('startinsert')  -- Enter insert mode
end

vim.keymap.set('n', '<leader>ac', function()
  open_split_term('arduino-cli compile --fqbn arduino:avr:uno "' .. vim.fn.expand('%:p') .. '"')
end, { desc = '[A]rduino [C]ompile' })

vim.keymap.set('n', '<leader>au', function()
  open_split_term('arduino-cli upload -p /dev/ttyACM* --fqbn arduino:avr:uno "' .. vim.fn.expand('%:p:h') .. '"')
end, { desc = '[A]rduino [U]pload' })

-- Window navigation
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- Highlight text on yank
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- Plugin Manager - Lazy.nvim
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.uv.fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
  if vim.v.shell_error ~= 0 then
    error('Error cloning lazy.nvim:\n' .. out)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Load default plugins and custom plugins from plugins.lua
require('lazy').setup({
  -- Default Plugins
  'tpope/vim-sleuth',  -- Auto-detect indentation style
  'nvim-lua/plenary.nvim',  -- Utility library for various plugins
  {
    'lewis6991/gitsigns.nvim',  -- Git signs in gutter
    opts = {
      signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
      },
    },
  },
  {
    'folke/which-key.nvim',  -- Keybinding pop-up
    event = 'VimEnter',
    config = function()
      require('which-key').setup()
      require('which-key').add {
        { '<leader>c', group = '[C]ode' },
        { '<leader>d', group = '[D]ocument' },
        { '<leader>r', group = '[R]ename' },
        { '<leader>s', group = '[S]earch' },
        { '<leader>w', group = '[W]orkspace' },
        { '<leader>t', group = '[T]oggle' },
        { '<leader>h', group = 'Git [H]unk', mode = { 'n', 'v' } },
      }
    end,
  },
  {
    'nvim-telescope/telescope.nvim',  -- Fuzzy Finder
    event = 'VimEnter',
    branch = '0.1.x',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      require('telescope').setup {
        defaults = { mappings = { i = { ['<c-x>'] = 'close' } } },
        extensions = {
          ['ui-select'] = { require('telescope.themes').get_dropdown() },
        },
      }
      pcall(require('telescope').load_extension, 'fzf')
      pcall(require('telescope').load_extension, 'ui-select')
    end,
  },
  {
    'folke/tokyonight.nvim',  -- Colorscheme
    priority = 1000,
    init = function()
      vim.cmd.colorscheme 'tokyonight-night'
      vim.cmd.hi 'Comment gui=none'
    end,
  },
  'folke/todo-comments.nvim',  -- Highlights TODO comments
  {
    'nvim-treesitter/nvim-treesitter',  -- Enhanced syntax highlighting
    opts = {
      ensure_installed = { 'lua', 'python', 'javascript' },
      highlight = { enable = true },
      indent = { enable = true },
    },
  },
  {
    'neovim/nvim-lspconfig',  -- LSP configurations
    dependencies = {
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',
      'hrsh7th/cmp-nvim-lsp',
      'j-hui/fidget.nvim',  -- LSP status notifications
    },
    config = function()
      require('mason').setup()
      require('mason-lspconfig').setup {
        ensure_installed = { 'lua_ls', 'clangd' },
      }
      require('lspconfig').lua_ls.setup {}
    end,
  },
  'hrsh7th/nvim-cmp',  -- Autocompletion plugin
  'L3MON4D3/LuaSnip',  -- Snippet engine

  -- Custom plugins from plugins.lua
  { import = 'custom.plugins' },
})

-- Terminal background restore for Kitty
vim.cmd [[
augroup RestoreBackground
  autocmd!
  autocmd VimLeave * silent !kitty @ set-colors background=#1e1e2e
augroup END
]]
