-- Reload buffers when another program (an agent, git, a formatter) writes the file.
--
-- `autoread` + `checktime` covers the usual triggers (focus, buffer switch, idle cursor).
-- A filesystem watcher per buffer also catches writes while Neovim is idle or unfocused,
-- e.g. Claude Code or Codex editing in another terminal pane while you watch.
-- Unmodified buffers reload silently; if you have unsaved edits, Neovim asks (W12).

vim.o.autoread = true

local group = vim.api.nvim_create_augroup('custom-autoreload', { clear = true })

local function check(buf)
  if not vim.api.nvim_buf_is_valid(buf) or not vim.api.nvim_buf_is_loaded(buf) then return end
  -- A converted notebook cannot use native checktime reload: replacing all its
  -- lines invalidates Molten extmarks, including on output-only disk writes.
  if vim.api.nvim_buf_get_name(buf):match '%.ipynb$' and vim.bo[buf].filetype == 'python' and package.loaded.jupytext then
    require('custom.notebook').refresh(buf)
  else
    vim.cmd('checktime ' .. buf)
  end
end

vim.api.nvim_create_autocmd({ 'FocusGained', 'BufEnter', 'CursorHold', 'CursorHoldI', 'TermLeave' }, {
  group = group,
  desc = 'Check whether files changed outside Neovim',
  callback = function()
    if vim.fn.getcmdwintype() == '' then
      for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        check(buf)
      end
    end
  end,
})

vim.api.nvim_create_autocmd('FileChangedShellPost', {
  group = group,
  desc = 'Notify after reloading an externally changed file',
  callback = function(args) vim.notify('Reloaded ' .. vim.fn.fnamemodify(args.file, ':~:.'), vim.log.levels.INFO) end,
})

---@type table<integer, uv.uv_fs_event_t>
local watchers = {}
---@type table<integer, boolean>
local pending = {}

local function unwatch(buf)
  local w = watchers[buf]
  if w then
    w:stop()
    if not w:is_closing() then w:close() end
    watchers[buf] = nil
  end
end

local function watch(buf)
  unwatch(buf)
  if not vim.api.nvim_buf_is_valid(buf) or vim.bo[buf].buftype ~= '' then return end
  local path = vim.api.nvim_buf_get_name(buf)
  if path == '' or not vim.uv.fs_stat(path) then return end

  local w = vim.uv.new_fs_event()
  if not w then return end
  watchers[buf] = w
  w:start(path, {}, function(err)
    if err or pending[buf] then return end
    pending[buf] = true
    -- Debounce bursts of events, then re-arm: atomic saves replace the inode we watched.
    vim.defer_fn(function()
      pending[buf] = nil
      if not vim.api.nvim_buf_is_valid(buf) then return unwatch(buf) end
      check(buf)
      watch(buf)
    end, 100)
  end)
end

vim.api.nvim_create_autocmd({ 'BufReadPost', 'BufWritePost', 'BufFilePost' }, {
  group = group,
  desc = 'Watch file for external changes',
  callback = function(args) watch(args.buf) end,
})

vim.api.nvim_create_autocmd({ 'BufUnload', 'BufWipeout' }, {
  group = group,
  desc = 'Stop watching file',
  callback = function(args) unwatch(args.buf) end,
})
