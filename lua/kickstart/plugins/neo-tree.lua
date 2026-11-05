-- Neo-tree is a Neovim plugin to browse the file system
-- https://github.com/nvim-neo-tree/neo-tree.nvim

vim.pack.add {
  { src = 'https://github.com/nvim-neo-tree/neo-tree.nvim', version = vim.version.range '*' },
  'https://github.com/nvim-lua/plenary.nvim',
  'https://github.com/MunifTanjim/nui.nvim',
}

vim.keymap.set('n', '\\', '<Cmd>Neotree reveal<CR>', { desc = 'NeoTree reveal', silent = true })

require('neo-tree').setup {
  event_handlers = {
    -- Open PDFs in a real viewer instead of as a buffer. Zathura is named directly because
    -- the desktop default for PDFs may be a browser; vim.ui.open covers machines without it.
    {
      event = 'file_open_requested',
      handler = function(args)
        if vim.fn.fnamemodify(args.path, ':e'):lower() ~= 'pdf' then return end
        if vim.fn.executable 'zathura' == 1 then
          vim.system({ 'zathura', args.path }, { detach = true })
        else
          vim.ui.open(args.path)
        end
        return { handled = true }
      end,
    },
  },
  filesystem = {
    window = {
      mappings = {
        ['\\'] = 'close_window',
      },
    },
  },
}
