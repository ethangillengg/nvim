local profile = 'ethan'


local require_lua = function(filename)
  require('' .. profile .. '/' .. filename)
end

require_lua('options')
require_lua('keymaps')
require_lua('plugins')
require_lua('plugin_opts')

vim.cmd[[colorscheme blue-moon]]
