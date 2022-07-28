local opts = { noremap = true, silent = true }
local keymap = function(mode, key, command)
  vim.api.nvim_set_keymap(
    mode,
    key,
    command,
    { noremap = true, silent = true }
  )
end

vim.g.mapleader = ' '

-- Quick nav splits
keymap('n', '<c-h>', '<c-w>h')
keymap('n', '<c-l>', '<c-w>l')
keymap('n', '<c-j>', '<c-w>j')
keymap('n', '<c-k>', '<c-w>k')

keymap('n', '<leader>w', ':wa<cr>')
keymap('n', '<leader>q', ':wqa<cr>')
keymap("n", "<Leader>v", ":edit ~/.config/nvim/lua/init.lua<CR>")

-- Navigate buffers
keymap('n', '<S-l>', ':bnext<cr>')
keymap('n', '<S-h>', ':bprevious<cr>')

-- Dont stop visual mode on indent
keymap('v', '<', '<gv')
keymap('v', '>', '>gv')


-- Move text with alt-j/k
keymap('n', '<A-j>', ':m .+1<CR>==')
keymap('n', '<A-k>', ':m .-2<CR>==')
keymap('i', '<A-j>', '<Esc>:m .+1<CR>==gi')
keymap('i', '<A-k>', '<Esc>:m .-2<CR>==gi')
keymap('v', '<A-j>', ":m '>+1<CR>gv-gv")
keymap('v', '<A-k>', ":m '<-2<CR>gv-gv")

-- Navigate buffers
keymap("n", "<S-l>", ":bnext<CR>")
keymap("n", "<S-h>", ":bprevious<CR>")

-- Don't overrite register on paste in visual mode
keymap('v', 'p', '"_dP')

-- only if telescope exists
local ok, _ = pcall(require, "telescope")
if ok then
  -- Telescope mappings
  keymap('n', '<leader>f', ':Telescope find_files<cr>')
  keymap('n', '<leader>r', ':Telescope live_grep<cr>')
  keymap('n', '<c-p>', ':Telescope find_files<cr>')
end

-- Neotree mappings
local ok, _ = pcall(require, "neo-tree")
if ok then
  keymap('n', '<leader>e', ':NeoTreeFloatToggle<cr>')
end

-- Floaterm mappings
-- local ok, _ = pcall(require, "floaterm")
if ok then
  keymap('n', '<leader>d', ':FloatermNew --height=0.9 --width=0.9 --autoclose=1 lazygit<cr>')
end
