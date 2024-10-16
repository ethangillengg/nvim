local options = {
	backup = false, -- creates a backup file
	clipboard = "unnamedplus", -- allows neovim to access the system clipboard
	-- cmdheight = 1, -- more space in the neovim command line for displaying messages
	completeopt = { "menuone", "noselect", "noinsert" }, -- mostly just for cmp
	conceallevel = 0,
	fileencoding = "utf-8", -- the encoding written to a file
	hlsearch = false, -- highlight all matches on previous search pattern
	ignorecase = true, -- ignore case in search patterns
	mouse = "a", -- allow the mouse to be used in neovim
	pumheight = 10, -- pop up menu height
	showmode = false, -- we don't need to see things like -- INSERT -- anymore
	showtabline = 0, -- always show tabs
	smartcase = true, -- smart case
	smartindent = true, -- make indenting smarter again
	splitbelow = true, -- force all horizontal splits to go below current window
	splitright = true, -- force all vertical splits to go to the right of current window
	termguicolors = true, -- set term gui colors (most terminals support this)
	timeoutlen = 1000, -- time to wait for a mapped sequence to complete (in milliseconds)
	undofile = true, -- enable persistent undo
	updatetime = 25, -- faster completion (4000ms default)
	swapfile = false, -- creates a swapfile
	writebackup = false, -- if a file is being edited by another program (or was written to file while editing with another program), it is not allowed to be edited
	expandtab = true, -- convert tabs to spaces
	shiftwidth = 2, -- the number of spaces inserted for each indentation
	tabstop = 2, -- insert 2 spaces for a tab
	number = true, -- set numbered lines
	-- relativenumber = true, -- set relative numbered lines
	numberwidth = 4, -- set number column width to 2 {default 4}
	signcolumn = "yes", -- always show the sign column, otherwise it would shift the text each time
	wrap = false, -- display lines as one long line
	-- wrapscan = false, -- dont wrap files when searching
	scrolloff = 8, -- is one of my fav
	sidescrolloff = 8,
	helpheight = 100, -- open larger help window
	guifont = "monospace:h17", -- the font used in graphical neovim applications
	cursorline = true,
	formatoptions = "jql",
	laststatus = 3, -- global statusline!!
	linebreak = true, -- words break line on wrap
	foldenable = false, -- disable folding on file open
}

for opt, val in pairs(options) do
	vim.opt[opt] = val
end

local is_wsl = vim.uv.os_uname()["release"]:lower():match("microsoft") and true or false
if is_wsl then
	-- this is the one recommended by the docs...
	-- but it is slow to paste
	-- vim.g.clipboard = {
	-- 	name = "WslClipboard",
	-- 	copy = {
	-- 		["+"] = "clip.exe",
	-- 		["*"] = "clip.exe",
	-- 	},
	-- 	paste = {
	-- 		["+"] = 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
	-- 		["*"] = 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
	-- 	},
	-- 	cache_enabled = 0,
	-- }

	vim.g.clipboard = {
		name = "win32yank-wsl",
		copy = {
			["+"] = "win32yank.exe -i --crlf",
			["*"] = "win32yank.exe -i --crlf",
		},
		paste = {
			["+"] = "win32yank.exe -o --crlf",
			["*"] = "win32yank.exe -o --crlf",
		},
		cache_enabled = 0,
	}
end

vim.g.markdown_folding = 1 -- enable markdown folding
vim.opt.shortmess:append("c")
vim.opt.diffopt:append("vertical") --vertical diff

vim.cmd("set whichwrap+=<,>,[,],h,l")
vim.cmd([[set iskeyword+=-]])
vim.cmd([[au FileType * set fo-=c fo-=r fo-=o]])

vim.cmd([[au BufRead,BufNewFile *.norg,COMMIT_EDITMSG setlocal spell]])
vim.cmd([[au BufRead,BufNewFile *.tex setlocal wrap | setlocal spell]])

vim.cmd([[
  augroup markdown
    autocmd FileType markdown setlocal wrap
    autocmd FileType markdown setlocal conceallevel=2
    autocmd FileType markdown setlocal spell
  augroup END
]])

-- Highlight on yank
vim.api.nvim_create_autocmd({ "TextYankPost" }, {
	callback = function()
		vim.highlight.on_yank({ higroup = "IncSearch", timeout = 125 })
	end,
})
