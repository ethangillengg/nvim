local profile = "ethan"

local require_lua = function(filename)
	require("" .. profile .. "/" .. filename)
end
require_lua("options")
require_lua("keymaps")
require_lua("plugins")
require_lua("treesitter")
require_lua("plugin_opts")
require_lua("lsp")

print(vim.fn.winwidth(0))
vim.g.sonokai_transparent_background = 0

vim.cmd([[colorscheme catppuccin]])
