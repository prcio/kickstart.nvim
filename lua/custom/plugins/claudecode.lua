-- Claude Code IDE integration: Claude sees your selection/open file and shows proposed
-- edits as Neovim diffs you accept or deny. https://github.com/coder/claudecode.nvim
--
-- From a Claude Code session in another terminal, run `/ide` to connect to this Neovim.
-- Or open Claude in a split inside Neovim with <leader>ac.
vim.pack.add { 'https://github.com/coder/claudecode.nvim' }

local claude_bin = require('config.platform').claude()

require('claudecode').setup {
  -- Headless instances (e.g. the one zathura spawns for SyncTeX inverse search) shouldn't
  -- advertise themselves to Claude Code's /ide list.
  auto_start = not vim.tbl_contains(vim.v.argv, '--headless'),
  -- Absolute path so it works even when Neovim is started outside a login shell.
  terminal_cmd = claude_bin,
  terminal = {
    split_side = 'right',
    split_width_percentage = 0.35,
    provider = 'native', -- snacks.nvim is not installed
  },
}

require('which-key').add { { '<leader>a', group = '[A]I / Claude Code', mode = { 'n', 'v' } } }

local map = function(keys, cmd, desc, mode) vim.keymap.set(mode or 'n', keys, cmd, { desc = desc }) end
map('<leader>ac', '<cmd>ClaudeCode<cr>', 'Toggle Claude')
map('<leader>af', '<cmd>ClaudeCodeFocus<cr>', 'Focus Claude')
map('<leader>ar', '<cmd>ClaudeCode --resume<cr>', 'Resume Claude')
map('<leader>aC', '<cmd>ClaudeCode --continue<cr>', 'Continue Claude')
map('<leader>am', '<cmd>ClaudeCodeSelectModel<cr>', 'Select Claude model')
map('<leader>ab', '<cmd>ClaudeCodeAdd %<cr>', 'Add current buffer')
map('<leader>as', '<cmd>ClaudeCodeSend<cr>', 'Send selection to Claude', 'v')
map('<leader>aa', '<cmd>ClaudeCodeDiffAccept<cr>', 'Accept diff')
map('<leader>ad', '<cmd>ClaudeCodeDiffDeny<cr>', 'Deny diff')

vim.api.nvim_create_autocmd('FileType', {
  group = vim.api.nvim_create_augroup('custom-claudecode-tree', { clear = true }),
  pattern = 'neo-tree',
  callback = function(args) vim.keymap.set('n', '<leader>as', '<cmd>ClaudeCodeTreeAdd<cr>', { buffer = args.buf, desc = 'Add file to Claude' }) end,
})
