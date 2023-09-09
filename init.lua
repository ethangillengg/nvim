local profile = "ethan"

local profile_require = function(filename)
	require("" .. profile .. "/" .. filename)
end

profile_require("options")
profile_require("mappings")
profile_require("setup-plugins")

vim.cmd("colorscheme gruvbox")
