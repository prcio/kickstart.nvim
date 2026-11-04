-- Quick capture: start a timestamped line at the end of the current buffer, in insert mode.
-- Used by the desktop capture hotkey. :q leaves the file untouched until something is typed,
-- and :wq with nothing typed drops the empty line.
local M = {}

function M.start()
  local buf = vim.api.nvim_get_current_buf()
  local stamp = os.date '- %Y-%m-%d %H:%M '
  vim.api.nvim_buf_set_lines(buf, -1, -1, false, { stamp })
  vim.bo[buf].modified = false

  vim.api.nvim_create_autocmd('BufWritePre', {
    buffer = buf,
    once = true,
    callback = function()
      local last = vim.api.nvim_buf_line_count(buf)
      if vim.api.nvim_buf_get_lines(buf, last - 1, last, false)[1] == stamp then vim.api.nvim_buf_set_lines(buf, last - 1, last, false, {}) end
    end,
  })

  vim.api.nvim_win_set_cursor(0, { vim.api.nvim_buf_line_count(buf), #stamp })
  vim.cmd.startinsert { bang = true }
end

return M
