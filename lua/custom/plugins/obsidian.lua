-- Obsidian vault support. Loaded only when settings.vault exists on this machine.
--
-- Keymaps (Space v...): vv find note, vs search text, vb backlinks, vi open inbox, vo open in the
-- Obsidian app. In a note, <CR> follows the link under the cursor and `[[` completes note names.
--
-- The Obsidian app owns note structure, so everything here that would write to notes on its own
-- stays off: frontmatter rewriting on save, templates, daily notes and sync. A note created from a
-- missing link is named exactly after the link and has no properties; the app's new-note picker
-- only runs on notes created in the app. lua/plugins/formatting.lua also skips format-on-save here.

local vault = vim.fn.expand(require('config.settings').vault)

vim.pack.add { { src = 'https://github.com/obsidian-nvim/obsidian.nvim', version = vim.version.range '3.*' } }
require('obsidian').setup {
  legacy_commands = false,
  workspaces = { { name = 'main', path = vault } },
  notes_subdir = 'Main Notes',
  new_notes_location = 'notes_subdir',
  note_id_func = function(title) return title end,
  note = { template = vim.NIL },
  frontmatter = { enabled = false },
  templates = { enabled = false },
  daily_notes = { enabled = false },
  ui = { enable = false },
  attachments = { folder = 'Attachments' },
  picker = { name = 'telescope.nvim' },
}

local function map(keys, command, desc) vim.keymap.set('n', '<leader>v' .. keys, command, { desc = desc }) end
map('v', '<cmd>Obsidian quick_switch<cr>', '[V]ault: find note')
map('s', '<cmd>Obsidian search<cr>', '[V]ault: [s]earch text')
map('b', '<cmd>Obsidian backlinks<cr>', '[V]ault: [b]acklinks')
map('o', '<cmd>Obsidian open<cr>', '[V]ault: [o]pen in Obsidian')
map('i', function() vim.cmd.edit(vim.fn.fnameescape(vim.fs.joinpath(vault, 'Main Notes', 'Inbox.md'))) end, '[V]ault: [i]nbox')
require('which-key').add { { '<leader>v', group = '[V]ault' } }
