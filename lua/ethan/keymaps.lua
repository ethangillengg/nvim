local map = function(mode, key, command)
	vim.keymap.set(mode, key, command, { noremap = true, silent = true })
end
vim.g.mapleader = " "

-- Quick nav splits
map("n", "<c-w>h", ":split<cr>")
map("n", "<c-w><c-h>", ":split<cr>")
map("n", "<c-h>", "<c-w>h<cr>")
map("n", "<c-l>", "<c-w>l<cr>")
map("n", "<c-j>", "<c-w>j<cr>")
map("n", "<c-k>", "<c-w>k<cr>")

map("n", "K", "")

map("t", "<c-h>", "<c-\\><c-o><c-w>h<cr>")
map("t", "<c-l>", "<c-\\><c-o><c-w>l<cr>")
map("t", "<c-j>", "<c-\\><c-o><c-w>j<cr>")
map("t", "<c-k>", "<c-\\><c-o><c-w>k<cr>")

map("n", "<leader>w", ":wa<cr>")
map("n", "<leader>q", ":wqa<cr>")
map("n", "<Leader>v", ":edit ~/.config/nvim/lua/init.lua<CR>")

-- Navigate buffers
map("n", "<S-l>", ":bnext<cr>")
map("n", "<S-h>", ":bprevious<cr>")

-- Toggle options
map("n", "<c-t>", ":set wrap!<cr>")

-- Dont stop visual mode on indent
map("v", "<", "<gv")
map("v", ">", ">gv")

-- Move text with alt-j/k
map("n", "<A-j>", ":m .+1<CR>==")
map("n", "<A-k>", ":m .-2<CR>==")
map("i", "<A-j>", "<Esc>:m .+1<CR>==gi")
map("i", "<A-k>", "<Esc>:m .-2<CR>==gi")
map("v", "<A-j>", ":m '>+1<CR>gv-gv")
map("v", "<A-k>", ":m '<-2<CR>gv-gv")

-- Navigate buffers
map("n", "<S-l>", ":bnext<CR>")
map("n", "<S-h>", ":bprevious<CR>")

-- Don't overrite register on paste in visual mode
map("v", "p", '"_dP')

-- Telescope mappings
local ok, telescope = pcall(require, "telescope.builtin")
if ok then
	map("n", "<c-p>", telescope.fd)
	map("n", "<leader>c", telescope.colorscheme)
	map("n", "<leader>r", telescope.live_grep)
	map("n", "<leader>t", telescope.builtin)
	map("n", "<leader>h", telescope.help_tags)
end

-- Lazy mappings
map("n", "<leader>l", ":Lazy<CR>")

-- Gitsigns mappings
local ok_1, gitsigns = pcall(require, "gitsigns")
if ok_1 then
	map("n", "<leader>g", gitsigns.diffthis)
	map("n", "<c-g>", function()
		gitsigns.next_hunk()
		vim.schedule(function()
			gitsigns.preview_hunk_inline()
		end)
	end)
end

-- Mason mappings
local mason, _ = pcall(require, "mason")
if mason then
	map("n", "<leader>m", ":Mason<cr>")
end

-- Lf + lazygit mappings
map("n", "<leader>e", ":Lf<cr>")
map("n", "<leader>d", ":Gitui<cr>")
