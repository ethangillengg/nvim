local profile = 'ethan'

local require_lua = function(filename)
  require('' .. profile .. '/' .. filename)
end
require_lua('options')
require_lua('keymaps')
require_lua('plugins')
require_lua('plugin_opts')
require_lua('lsp')

vim.g.sonokai_transparent_background = 1
vim.cmd[[colorscheme sonokai]]
