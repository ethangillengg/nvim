local profile = "ethan"

local profile_require = function(filename)
	require("" .. profile .. "/" .. filename)
end

profile_require("options")
profile_require("keymaps")
--[[ profile_require("treesitter") ]]

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup("ethan.plugins")
vim.cmd([[colorscheme tokyonight]])
