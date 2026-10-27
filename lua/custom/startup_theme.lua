-- Startup screen theme, ported from Dennis's startup.nvim fork (github.com/prcio/startup.nvim,
-- theme "evil" with the Berserk header, his quotes and the #ff8400 accent).
-- Passed straight to upstream startup.nvim's setup(); see lua/custom/plugins/startup.lua.

local berserk_symbol = {
  [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
  [[⠀⠀⠀⠀⠀⠀⣰⣾⠁⠀⢦⣾⣤⠆⠀⠻⣧⠀⠀⠀⠀⠀⠀]],
  [[⠀⠀⠀⠀⢠⣼⠏⠀⠀⠀⠀⣿⡇⠀⠀⠀⠈⢷⣄⠀⠀⠀⠀]],
  [[⠀⠀⢀⣸⣿⠃⠀⠀⠀⠀⠀⣿⡇⠀⠀⠀⠀⠀⢿⣧⡀⠀⠀]],
  [[⠀⢰⣾⣿⡁⠀⠀⠀⠀⠀⠀⣿⡇⠀⠀⠀⠀⠀⢀⣿⣿⠖⠀]],
  [[⠀⠀⠈⠻⣿⣦⣄⠀⠀⠀⠀⣿⡇⠀⠀⠀⢀⣴⣿⠟⠁⠀⠀]],
  [[⠀⠀⠀⠀⠈⠻⢿⣷⣄⡀⠀⣿⡇⠀⣠⣾⣿⠟⠁⠀⠀⠀⠀]],
  [[⠀⠀⠀⠀⠀⠀⠀⠙⢿⣿⣦⣿⣧⣾⣿⠟⠁⠀⠀⠀⠀⠀⠀]],
  [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⢙⣿⣿⣿⣿⡀⠀⠀⠀⠀⠀⠀⠀⠀]],
  [[⠀⠀⠀⠀⠀⠀⠀⢀⣴⣿⣿⣿⣿⣿⣿⣦⡀⠀⠀⠀⠀⠀⠀]],
  [[⠀⠀⠀⠀⠀⢀⣴⣿⣿⠟⠁⣻⣿⠈⠙⢿⣿⣦⡀⠀⠀⠀⠀]],
  [[⠀⠀⠀⢀⣴⣿⡿⠋⠀⠀⠀⣽⣿⠀⠀⠀⠙⢿⣿⣦⣄⠀⠀]],
  [[⠀⣠⣴⣿⡿⠋⠀⠀⠀⠀⠀⢼⣿⠀⠀⠀⠀⠀⠈⢻⣿⣷⣄]],
  [[⠈⠙⢿⣿⣦⣄⠀⠀⠀⠀⠀⢸⣿⠀⠀⠀⠀⠀⣠⣾⣿⠟⠁]],
  [[⠀⠀⠀⠙⢿⣿⣷⣄⠀⠀⠀⢸⣿⠀⠀⠀⣠⣾⣿⠟⠁⠀⠀]],
  [[⠀⠀⠀⠀⠀⠙⢻⣿⣷⡄⠀⢸⣿⠀⠀⣼⣿⣿⠃⠀⠀⠀⠀]],
  [[⠀⠀⠀⠀⠀⠀⠈⠻⢿⣿⣦⣸⣿⣠⣾⣿⠟⠁⠀⠀⠀⠀⠀]],
  [[⠀⠀⠀⠀⠀⠀⠀⠀⠈⠙⢿⣿⣿⣿⡿⠁⠀⠀⠀⠀⠀⠀⠀]],
  [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠙⠿⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
}

local quotes = {
  {
    "If you don't fail at least 90% of the time, you're not aiming high enough.",
    '',
    '- Alan Kay',
  },
  {
    'Perfection is achieved, not when there is nothing more to add, but when there is nothing left to take away.',
    '',
    '- Antoine de Saint-Exupéry',
  },
  {
    "If you don't make mistakes, you're not working on hard enough problems.",
    '',
    '- Frank Wilczek',
  },
  {
    'Easy things should be easy and hard things should be possible.',
    '',
    '- Larry Wall',
  },
  {
    'The first principle is that you must not fool yourself, and you are the easiest person to fool.',
    '',
    '- Richard Feynman',
  },
  {
    'What we observe is not nature itself, but nature exposed to our method of questioning.',
    '',
    '- Werner Heisenberg',
  },
  {
    'Mathematics is the language in which God has written the universe.',
    '',
    '- Galileo Galilei',
  },
  {
    'Pure mathematics is, in its way, the poetry of logical ideas.',
    '',
    '- Albert Einstein',
  },
  {
    'In science, we must be interested in things, not in persons.',
    '',
    '- Marie Curie',
  },
  {
    'Not only is the universe stranger than we think, it is stranger than we can think.',
    '',
    '- Werner Heisenberg',
  },
  {
    'I seem to have been only like a boy playing on the seashore... finding a smoother pebble or a prettier shell... while the great ocean of truth lay all undiscovered before me.',
    '',
    '- Isaac Newton',
  },
  {
    'Those who are not shocked when they first come across quantum theory cannot possibly have understood it.',
    '',
    '- Niels Bohr',
  },
  {
    'Philosophy is written in this grand book, the universe, which stands continually open to our gaze.',
    '',
    '- Galileo Galilei',
  },
  {
    'There is no law except the law that there is no law.',
    '',
    '- John Wheeler',
  },
  {
    'No one can escape the influence of a prevailing ideology.',
    '',
    '- Ludwig Boltzmann',
  },
  {
    'Mathematics knows no races or geographic boundaries; for mathematics, the cultural world is one country.',
    '',
    '- David Hilbert',
  },
  {
    'The true sign of intelligence is not knowledge but imagination.',
    '',
    '- Albert Einstein',
  },
  {
    'The scientist does not study nature because it is useful; he studies it because he delights in it, and he delights in it because it is beautiful.',
    '',
    '- Henri Poincaré',
  },
  {
    'Science is the poetry of reality.',
    '',
    '- Richard Dawkins',
  },
  {
    'Life is not only stranger than we imagine, it is stranger than we can imagine.',
    '',
    '- J.B.S. Haldane',
  },
}

local function quote()
  math.randomseed(os.time())
  return quotes[math.random(#quotes)]
end

local function plugin_count() return { ('Total plugins (vim.pack): %d'):format(#vim.pack.get()) } end

return {
  -- every line should be same width without escaped \
  header = {
    type = 'text',
    align = 'center',
    fold_section = false,
    title = 'Header',
    margin = 5,
    content = berserk_symbol,
    highlight = 'Statement',
    default_color = '',
    oldfiles_amount = 0,
  },
  header_2 = {
    type = 'text',
    oldfiles_directory = false,
    align = 'center',
    fold_section = false,
    title = 'Quote',
    margin = 5,
    content = quote,
    highlight = 'Constant',
    default_color = '',
    oldfiles_amount = 0,
  },
  -- name which will be displayed and command
  body = {
    type = 'mapping',
    align = 'center',
    fold_section = true,
    title = 'Basic Commands',
    margin = 5,
    content = {
      { ' Find File', 'Telescope find_files', '<leader>ff' },
      { '󰍉 Find Word', 'Telescope live_grep', '<leader>lg' },
      { ' Recent Files', 'Telescope oldfiles', '<leader>of' },
      { ' File Browser', 'Neotree reveal', '<leader>fb' },
      { ' Colorschemes', 'Telescope colorscheme', '<leader>cs' },
      { ' New File', "lua require'startup'.new_file()", '<leader>nf' },
    },
    highlight = 'String',
    default_color = '',
    oldfiles_amount = 0,
  },
  body_2 = {
    type = 'oldfiles',
    oldfiles_directory = true,
    align = 'center',
    fold_section = true,
    title = 'Oldfiles of Directory',
    margin = 5,
    content = {},
    highlight = 'String',
    default_color = '#FFFFFF',
    oldfiles_amount = 5,
  },
  footer = {
    type = 'oldfiles',
    oldfiles_directory = false,
    align = 'center',
    fold_section = true,
    title = 'Oldfiles',
    margin = 5,
    content = { 'startup.nvim' },
    highlight = 'String',
    default_color = '#FFFFFF',
    oldfiles_amount = 5,
  },
  clock = {
    type = 'text',
    content = function()
      local clock = ' ' .. os.date '%H:%M'
      local date = ' ' .. os.date '%d-%m-%y'
      return { clock, date }
    end,
    oldfiles_directory = false,
    align = 'center',
    fold_section = false,
    title = '',
    margin = 5,
    highlight = 'String',
    default_color = '#FFFFFF',
    oldfiles_amount = 10,
  },
  footer_2 = {
    type = 'text',
    content = plugin_count,
    oldfiles_directory = false,
    align = 'center',
    fold_section = false,
    title = '',
    margin = 5,
    highlight = 'String',
    default_color = '#FFFFFF',
    oldfiles_amount = 10,
  },
  options = {
    after = function() require('startup.utils').oldfiles_mappings() end,
    mapping_keys = true,
    cursor_column = 0.5,
    empty_lines_between_mappings = true,
    disable_statuslines = true,
    paddings = { 2, 2, 2, 2, 2, 2, 2 },
  },
  colors = {
    background = '#1f2227',
    folded_section = '#ff8400',
  },
  parts = { 'header', 'header_2', 'body', 'body_2', 'footer', 'clock', 'footer_2' },
}
