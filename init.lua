local profile = 'ethan'

local require_lua = function(filename)
  require('' .. profile .. '/' .. filename)
end
require_lua('options')
require_lua('keymaps')
require_lua('plugins')
vim.cmd[[colorscheme blue-moon]]
require_lua('plugin_opts')
require_lua('lsp')

