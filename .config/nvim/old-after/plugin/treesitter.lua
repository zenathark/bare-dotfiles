local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>pf', builtin.find_files, {})
vim.keymap.set('n', '<leader>bf', builtin.buffers, {})
vim.keymap.set('n', '<C-p>', builtin.git_files, {})
vim.keymap.set('n', '<leader>ps', function()
  builtin.grep_string({ search = vim.fn.input("Grep > ") })
end)

local pickers = require 'telescope.pickers'
local finders = require 'telescope.finders'
local conf = require('telescope.config').values

local colors = function(opts)
  opts = opts or {}
  local git_command = {'fd', '--type', 'f', '--color', 'never', '', '.', 'kepler_common', 'kepler_webview'}
  pickers.new(opts, {
    prompt_title = "Vega Combined Repos",
    finder = finders.new_oneshot_job(
      git_command,
      opts
    ),
    previewer = conf.file_previewer(opts),
    sorter = conf.file_sorter(opts),
  }):find()
end

vim.keymap.set('n', '<leader>vf', colors, {})
