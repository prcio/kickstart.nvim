-- Harpoon 2: pin a handful of files and jump between them.
-- (Installed but unmapped in the old config; these keymaps are new.)
vim.pack.add {
  'https://github.com/nvim-lua/plenary.nvim',
  { src = 'https://github.com/ThePrimeagen/harpoon', version = 'harpoon2' },
}

local harpoon = require 'harpoon'
harpoon:setup()

require('which-key').add { { '<leader>j', group = 'Harpoon [J]ump' } }

vim.keymap.set('n', '<leader>ja', function() harpoon:list():add() end, { desc = 'Harpoon [A]dd file' })
vim.keymap.set('n', '<leader>jm', function() harpoon.ui:toggle_quick_menu(harpoon:list()) end, { desc = 'Harpoon [M]enu' })
vim.keymap.set('n', '<C-e>', function() harpoon.ui:toggle_quick_menu(harpoon:list()) end, { desc = 'Harpoon menu' })
for i = 1, 4 do
  vim.keymap.set('n', '<leader>' .. i, function() harpoon:list():select(i) end, { desc = 'Harpoon file ' .. i })
end
