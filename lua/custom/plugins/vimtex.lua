-- LaTeX: VimTeX (compile with latexmk, view in zathura, SyncTeX both ways).
--
-- Keymaps (localleader is <space>):
--   <space>ll  start/stop continuous compilation (latexmk -pvc; recompiles on every save,
--              including saves made by an agent, and zathura reloads the PDF)
--   <space>lv  build-and-view: starts the continuous build if it isn't running (zathura opens
--              after the first successful build), else shows the cursor position in zathura
--   <space>lk  stop compilation, <space>lc  clean aux files, <space>le  show errors
--   Ctrl+click in zathura: inverse search, jumps to that line in Neovim
--
-- Shell escape stays off (VimTeX's latexmk defaults); minted works via TeX Live's
-- restricted latexminted. Enable -shell-escape per trusted project only, e.g. in a
-- project-local latexmkrc, never globally.

-- Arch installs biber (and other TeX Perl tools) in /usr/bin/vendor_perl, which only login
-- shells put on PATH. Add the Perl dirs here so latexmk finds biber however Neovim was started.
-- PATH discovery is centralized in config.platform.

-- VimTeX reads these globals when it loads, so set them before vim.pack.add.
-- Wayland has no xdotool, so use the simple zathura variant (VimTeX's recommendation).
vim.g.vimtex_view_method = require('config.platform').viewer()
-- Don't pop the quickfix window open for warnings, only for errors.
vim.g.vimtex_quickfix_open_on_warning = 0

-- <space>lv is replaced below so that "view" also builds (saving alone never compiles).
vim.g.vimtex_mappings_disable = { n = { '<localleader>lv' } }

vim.pack.add { 'https://github.com/lervag/vimtex' }

-- <space>lv: if no continuous build is running, start one; VimTeX opens zathura by itself
-- after the first successful build (g:vimtex_view_automatic). Otherwise forward-search.
-- Without this, <space>lv just showed whatever stale PDF was already on disk.
vim.api.nvim_create_autocmd('FileType', {
  group = vim.api.nvim_create_augroup('custom-vimtex-view', { clear = true }),
  pattern = 'tex',
  callback = function(args)
    vim.keymap.set('n', '<localleader>lv', function()
      local running = vim.api.nvim_eval 'b:vimtex.compiler.is_running()'
      if running == true or running == 1 then
        vim.cmd 'VimtexView'
      else
        vim.cmd 'VimtexCompile'
      end
    end, { buffer = args.buf, desc = 'VimTeX: build (if needed) and view' })
  end,
})

require('which-key').add { { '<localleader>l', group = '[L]aTeX (VimTeX)', mode = { 'n', 'x' } } }
