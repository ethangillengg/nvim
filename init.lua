local profile = 'swarm'

local require_lua = function(filename)
  require('' .. profile .. '/' .. filename)
end

require_lua('options')
require_lua('keymaps')

-- vim.cmd "colorscheme tokyonight"

require_lua('plugins')
require_lua('cmp')
require_lua('lsp')
require_lua('treesitter')
require_lua('autopairs')
require_lua('comment')
require_lua('gitsigns')
require_lua('neotree')
require_lua('lualine')
require_lua('floaterm')
require('telescope').setup{  defaults = { file_ignore_patterns = { "node_modules" }} }
-- require_lua('bufferline')

vim.cmd "colorscheme catppuccin"
