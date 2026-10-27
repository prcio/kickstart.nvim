local function gh(repo) return 'https://github.com/' .. repo end

vim.pack.add { { src = gh 'nvim-treesitter/nvim-treesitter', version = 'main' } }

local parsers = { 'bash', 'c', 'diff', 'html', 'latex', 'lua', 'luadoc', 'markdown', 'markdown_inline', 'query', 'vim', 'vimdoc' }
local auto_install = require('config.settings').auto_install
if auto_install then require('nvim-treesitter').install(parsers) end

local function treesitter_try_attach(buf, language)
  if not vim.api.nvim_buf_is_valid(buf) then return end

  if not vim.treesitter.language.add(language) then return end

  vim.treesitter.start(buf, language)

  local has_indent_query = vim.treesitter.query.get(language, 'indents') ~= nil

  if has_indent_query then vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()" end
end

local available_parsers = require('nvim-treesitter').get_available()
vim.api.nvim_create_autocmd('FileType', {
  callback = function(args)
    local buf, filetype = args.buf, args.match

    if filetype == 'tex' then return end

    local language = vim.treesitter.language.get_lang(filetype)
    if not language then return end

    local installed_parsers = require('nvim-treesitter').get_installed 'parsers'

    if vim.tbl_contains(installed_parsers, language) then
      treesitter_try_attach(buf, language)
    elseif auto_install and vim.tbl_contains(available_parsers, language) then
      require('nvim-treesitter').install(language):await(function() treesitter_try_attach(buf, language) end)
    else
      treesitter_try_attach(buf, language)
    end
  end,
})
