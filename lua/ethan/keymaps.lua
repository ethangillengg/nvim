local opts = { noremap = true, silent = true }
local map = function(mode, key, command)
  vim.api.nvim_set_keymap(
    mode,
    key,
    command,
    { noremap = true, silent = true }
  )
end

vim.g.mapleader = ' '

-- Quick nav splits
map('n', '<c-h>', '<c-w>h')
map('n', '<c-l>', '<c-w>l')
map('n', '<c-j>', '<c-w>j')
map('n', '<c-k>', '<c-w>k')

map('n', '<leader>w', ':wa<cr>')
map('n', '<leader>q', ':wqa<cr>')
map("n", "<Leader>v", ":edit ~/.config/nvim/lua/init.lua<CR>")

-- Navigate buffers
map('n', '<S-l>', ':bnext<cr>')
map('n', '<S-h>', ':bprevious<cr>')

-- Dont stop visual mode on indent
map('v', '<', '<gv')
map('v', '>', '>gv')


-- Move text with alt-j/k
map('n', '<A-j>', ':m .+1<CR>==')
map('n', '<A-k>', ':m .-2<CR>==')
map('i', '<A-j>', '<Esc>:m .+1<CR>==gi')
map('i', '<A-k>', '<Esc>:m .-2<CR>==gi')
map('v', '<A-j>', ":m '>+1<CR>gv-gv")
map('v', '<A-k>', ":m '<-2<CR>gv-gv")

-- Navigate buffers
map("n", "<S-l>", ":bnext<CR>")
map("n", "<S-h>", ":bprevious<CR>")

-- Don't overrite register on paste in visual mode
map('v', 'p', '"_dP')


-- Telescope mappings
local telescope, _ = pcall(require, "telescope")
if telescope then
  map('n', '<leader>c', ':Telescope colorscheme<CR>')
  map('n', '<leader>r', ':Telescope live_grep<CR>')
  map('n', '<c-h>', ':Telescope help_tags<CR>')
  map('n', '<leader>l', ':Telescope colorscheme<CR>')
  map('n', '<c-p>', ':Telescope find_files<CR>')
end

-- Neotree mappings
local neotree, _ = pcall(require, "neo-tree")
if neotree then
  map('n', '<leader>e', ':NeoTreeFloatToggle<cr>')
end
