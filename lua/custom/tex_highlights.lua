-- Fog colors for LaTeX (VimTeX syntax groups), plus selective conceal.
--
-- The black-metal "bathory" scheme maps nearly every TeX group to a grey, so commands,
-- arguments and prose blend while whole math zones turn bright orange. This layer uses the
-- muted Fog hues for structure instead. It only touches tex* groups, plus Conceal and
-- MatchParen inside tex windows (via winhighlight), so other filetypes keep their look.
--
--   math            cyan            $, \[ \], \begin/\end   accent
--   math commands   bright cyan     environment names       magenta
--   commands        blue            \ref \eqref \cite       green
--   braces, ops     fg1             section titles          fg0 bold
--   comments        lifted grey, italic (~3.6:1 on bg0)
--
-- <leader>tc toggles conceal (alpha -> α) in the current window.
-- Remove: delete the require line in lua/custom/plugins/vimtex.lua.

local M = {}

local p = require 'custom.palette'
local bright_cyan = '#8ab3b0' -- palette.toml [ansi_bright].cyan
local comment = '#6e6b67' -- between bright black and fg1: quiet but readable

local function apply()
  local groups = {
    -- commands and structure
    [p.blue] = { 'texCmd', 'texCmdPart', 'texCmdClass', 'texCmdPackage', 'texCmdItem', 'texCmdStyleBold', 'texCmdStyleItal', 'texCmdStyleBoldItal' },
    [p.accent] = {
      'texCmdEnv', 'texCmdMathEnv', 'texMathEnvBgnEnd',
      'texMathDelimZone', 'texMathDelimZoneTI', 'texMathDelimZoneTD', 'texMathDelimZoneLI', 'texMathDelimZoneLD',
    },
    [p.magenta] = { 'texEnvArgName', 'texMathEnvArgName' },
    [p.green] = {
      'texCmdRef', 'texCmdRefEq', 'texCmdCRef', 'texCmdCite', 'texCmdLabel', 'texCmdRefConcealed',
      'texRefArg', 'texRefConcealedArg', 'texRefEqConcealedArg', 'texCiteArg', 'texLabelArg',
    },
    -- math
    [p.cyan] = {
      'texMathZone', 'texMathZoneTI', 'texMathZoneTD', 'texMathZoneLI', 'texMathZoneLD', 'texMathZoneEnv',
      'texMathZoneEnvStarred', 'texMathZoneEnsured', 'texMathZoneX', 'texMathZoneXX',
      'texMathArg', 'texMathGroup', 'texMathSuper', 'texMathSub', 'texMathSuperSub',
    },
    [bright_cyan] = { 'texMathCmd', 'texCmdGreek', 'texMathSymbol', 'texMathCmdText' },
    -- quiet punctuation
    [p.fg1] = { 'texDelim', 'texMathDelim', 'texMathOper', 'texTabularChar', 'texRefConcealedDelim', 'texRefEqConcealedDelim' },
    -- plain arguments read as text
    [p.fg0] = { 'texArg', 'texFileArg', 'texFilesArg', 'texOpt', 'texOptArg' },
  }
  for fg, names in pairs(groups) do
    for _, name in ipairs(names) do
      vim.api.nvim_set_hl(0, name, { fg = fg })
    end
  end
  vim.api.nvim_set_hl(0, 'texPartArgTitle', { fg = p.fg0, bold = true })
  vim.api.nvim_set_hl(0, 'texComment', { fg = comment, italic = true })
  vim.api.nvim_set_hl(0, 'texCommentTodo', { fg = p.yellow, italic = true, bold = true })
  -- Window-local replacements, only mapped in tex windows below.
  vim.api.nvim_set_hl(0, 'FogTexConceal', { fg = bright_cyan })
  vim.api.nvim_set_hl(0, 'FogTexMatchParen', { fg = p.accent, bg = p.bg2, bold = true })
end

local TEX_WINHL = 'Conceal:FogTexConceal,MatchParen:FogTexMatchParen'

-- winhighlight belongs to the window, so set it for tex buffers and undo it (only if we set
-- it) when another buffer shows in that window.
local function sync_window()
  if vim.bo.filetype == 'tex' then
    vim.wo.winhighlight = TEX_WINHL
  elseif vim.wo.winhighlight == TEX_WINHL then
    vim.wo.winhighlight = ''
  end
end

function M.setup()
  -- Conceal only what reads better as a glyph; keep sections, styles and $ visible.
  -- VimTeX reads this when it loads, so this runs before vim.pack.add.
  vim.g.vimtex_syntax_conceal = {
    accents = 1,
    ligatures = 1,
    cites = 0,
    fancy = 0,
    spacing = 0,
    greek = 1,
    math_bounds = 0,
    math_delimiters = 1,
    math_fracs = 0,
    math_super_sub = 0,
    math_symbols = 1,
    sections = 0,
    styles = 0,
  }

  apply()
  local group = vim.api.nvim_create_augroup('custom-tex-highlights', { clear = true })
  vim.api.nvim_create_autocmd('ColorScheme', { group = group, callback = apply })
  vim.api.nvim_create_autocmd({ 'BufWinEnter', 'FileType' }, { group = group, callback = sync_window })
  vim.api.nvim_create_autocmd('FileType', {
    group = group,
    pattern = 'tex',
    callback = function(args)
      -- concealcursor='' shows the cursor line raw in every mode, so editing stays literal.
      vim.opt_local.conceallevel = 2
      vim.opt_local.concealcursor = ''
      vim.keymap.set('n', '<leader>tc', function()
        vim.wo.conceallevel = vim.wo.conceallevel == 0 and 2 or 0
      end, { buffer = args.buf, desc = '[T]oggle LaTeX [c]onceal' })
    end,
  })
end

return M
