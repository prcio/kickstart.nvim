-- LaTeX insert snippets, shared by typed triggers (blink.cmp completion menu) and the
-- <space>li… keymaps in custom/plugins/vimtex.lua. Tab / Shift-Tab jump between fields;
-- each field starts with placeholder text selected, so typing replaces it.
--
--   key  trigger  inserts                                   needs (preamble)
--   f    fig      figure + \includegraphics + caption/label  graphicx
--   s    subfig   two side-by-side subfigures                graphicx, subcaption
--   t    tab      table + tabular with booktabs rules         booktabs
--   e    eq       equation + label
--   a    ali      align (unnumbered: change to align*)        amsmath
--   i    item     itemize
--   n    enum     enumerate
--   b    beg      any environment (\end name follows \begin)
local ls = require 'luasnip'
local s, i = ls.snippet, ls.insert_node
local fmta = require('luasnip.extras.fmt').fmta
local rep = require('luasnip.extras').rep

local M = {}

local function snip(trig, desc, body, nodes) return s({ trig = trig, desc = desc }, fmta(body, nodes)) end

-- Ordered so the which-key menu and the header table above read the same way.
M.defs = {
  {
    key = 'f',
    name = 'figure',
    snip = snip(
      'fig',
      'figure with \\includegraphics',
      [[
\begin{figure}[<>]
  \centering
  \includegraphics[width=<>\linewidth]{<>}
  \caption{<>}
  \label{fig:<>}
\end{figure}<>]],
      { i(5, 'htbp'), i(2, '0.8'), i(1, 'path/to/image'), i(3, 'Caption'), i(4, 'label'), i(0) }
    ),
  },
  {
    key = 's',
    name = 'subfigures',
    snip = snip(
      'subfig',
      'figure with two subfigures',
      [[
\begin{figure}[htbp]
  \centering
  \begin{subfigure}{0.48\linewidth}
    \centering
    \includegraphics[width=\linewidth]{<>}
    \caption{<>}
    \label{fig:<>}
  \end{subfigure}
  \hfill
  \begin{subfigure}{0.48\linewidth}
    \centering
    \includegraphics[width=\linewidth]{<>}
    \caption{<>}
    \label{fig:<>}
  \end{subfigure}
  \caption{<>}
  \label{fig:<>}
\end{figure}<>]],
      {
        i(1, 'path/to/left'),
        i(2, 'Left caption'),
        i(3, 'left'),
        i(4, 'path/to/right'),
        i(5, 'Right caption'),
        i(6, 'right'),
        i(7, 'Caption'),
        i(8, 'label'),
        i(0),
      }
    ),
  },
  {
    key = 't',
    name = 'table',
    snip = snip(
      'tab',
      'table + tabular (booktabs)',
      [[
\begin{table}[htbp]
  \centering
  \caption{<>}
  \label{tab:<>}
  \begin{tabular}{<>}
    \toprule
    <> \\
    \midrule
    <> \\
    \bottomrule
  \end{tabular}
\end{table}<>]],
      { i(4, 'Caption'), i(5, 'label'), i(1, 'lcc'), i(2, 'A & B & C'), i(3, '1 & 2 & 3'), i(0) }
    ),
  },
  {
    key = 'e',
    name = 'equation',
    snip = snip(
      'eq',
      'numbered equation with label',
      [[
\begin{equation}
  <>
  \label{eq:<>}
\end{equation}<>]],
      { i(1), i(2, 'label'), i(0) }
    ),
  },
  {
    key = 'a',
    name = 'align',
    snip = snip(
      'ali',
      'align environment',
      [[
\begin{align}
  <> &= <>
\end{align}<>]],
      { i(1, 'a'), i(2, 'b'), i(0) }
    ),
  },
  {
    key = 'i',
    name = 'itemize',
    snip = snip('item', 'itemize list', '\\begin{itemize}\n  \\item <>\n\\end{itemize}<>', { i(1), i(0) }),
  },
  {
    key = 'n',
    name = 'enumerate',
    snip = snip('enum', 'enumerate list', '\\begin{enumerate}\n  \\item <>\n\\end{enumerate}<>', { i(1), i(0) }),
  },
  {
    key = 'b',
    name = 'any environment',
    snip = snip('beg', '\\begin{…} … \\end{…}', '\\begin{<>}\n  <>\n\\end{<>}<>', { i(1, 'env'), i(2), rep(1), i(0) }),
  },
}

function M.snippets()
  local list = {}
  for _, d in ipairs(M.defs) do
    list[#list + 1] = d.snip
  end
  return list
end

-- Normal-mode insert: expand on the current line if it is blank, else on a new line below
-- with the same indentation. snip_expand copies the snippet, so reuse is safe.
function M.insert(sn)
  local row = vim.api.nvim_win_get_cursor(0)[1]
  local line = vim.api.nvim_get_current_line()
  if line:match '%S' then
    line = line:match '^%s*'
    vim.api.nvim_buf_set_lines(0, row, row, false, { line })
    row = row + 1
  end
  ls.snip_expand(sn, { pos = { row - 1, #line } })
end

return M
