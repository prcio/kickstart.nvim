local function gh(repo) return 'https://github.com/' .. repo end

vim.pack.add { gh 'stevearc/conform.nvim' }
require('conform').setup {
  notify_on_error = false,
  format_on_save = function(bufnr)
    local name = vim.api.nvim_buf_get_name(bufnr)
    if name:match '%.ipynb$' then return nil end
    -- Vault notes are hand-kept and shared with the Obsidian app; format them only on request.
    local vault = require('config.settings').vault
    if vault and vim.fs.relpath(vim.fn.expand(vault), name) then return nil end
    local enabled_filetypes = {
      lua = true,
      python = true,
      markdown = true,
    }
    if enabled_filetypes[vim.bo[bufnr].filetype] then
      return { timeout_ms = 500 }
    else
      return nil
    end
  end,
  default_format_opts = {
    lsp_format = 'fallback', -- Use external formatters if configured below, otherwise use LSP formatting. Set to `false` to disable LSP formatting entirely.
  },
  formatters_by_ft = {
    lua = { 'stylua' },
    python = { 'isort', 'black' },
    markdown = { 'markdownlint' },
  },
}

vim.keymap.set({ 'n', 'v' }, '<leader>f', function() require('conform').format { async = true } end, { desc = '[F]ormat buffer' })
