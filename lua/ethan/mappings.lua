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
map("n", "<c-j>", "<c-w>j<cr>")
map("n", "<c-k>", "<c-w>k<cr>")

map("n", "K", "")

map("t", "<c-h>", "<c-\\><c-o><c-w>h<cr>")
map("t", "<c-l>", "<c-\\><c-o><c-w>l<cr>")
map("t", "<c-j>", "<c-\\><c-o><c-w>j<cr>")
map("t", "<c-k>", "<c-\\><c-o><c-w>k<cr>")

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

-- Lazy mappings
map("n", "<leader>li", ":LspInfo<CR>")
map("n", "<leader>lr", ":LspRestart<CR>")
