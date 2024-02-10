local map = function(mode, key, command)
	vim.keymap.set(mode, key, command, { noremap = true, silent = true })
end
vim.g.mapleader = " "
vim.g.maplocalleader = ","

-- Quick nav splits
map("n", "<c-w>h", ":split<cr>")
map("n", "<c-w><c-h>", ":split<cr>")
map("n", "<c-h>", "<c-w>h<cr>")
map("n", "<c-l>", "<c-w>l<cr>")

map("n", "K", "")

-- move between wrapped lines
map("n", "j", "gj")
map("n", "k", "gk")

-- Quick save mappings
map("n", "<leader>w", ":wa<cr>")
map("n", "<leader>q", ":wqa<cr>")

-- Center while paging
map("n", "<c-d>", "<c-d>zz")
map("n", "<c-u>", "<c-u>zz")
-- Navigate buffers
map("n", "<tab>", ":bnext<cr>")
map("n", "<S-tab>", ":bprevious<cr>")

-- Toggle options
map("n", "<c-t>", ":set wrap!<cr>")

-- Dont stop visual mode on indent
map("v", "<", "<gv")
map("v", ">", ">gv")

-- Navigate buffers
map("n", "<S-l>", ":bnext<CR>")
map("n", "<S-h>", ":bprevious<CR>")

-- Don't overrite register on paste in visual mode
map("v", "p", '"_dP')

-- Lazy mappings
map("n", "<leader>li", ":LspInfo<CR>")
map("n", "<leader>lr", ":LspRestart<CR>")
map("n", "<leader>ll", ":Lazy<CR>")
