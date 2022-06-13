local opts = { noremap = true, silent = true }
local keymap = function(mode, key, command)
  vim.api.nvim_set_keymap(
    mode,
    key,
    command,
    {noremap = true, silent = true}
  )
end

vim.g.mapleader = ' '

keymap('n', '<c-h>', '<c-w>h')
keymap('n', '<BS>', '<c-w>l')
keymap('n', '<c-j>', '<c-w>j')
keymap('n', '<c-k>', '<c-w>k')

keymap('n', '<leader>w', ':wa<cr>')
keymap('n', '<leader>q', ':wqa<cr>')

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

-- Don't overrite register on paste in visual mode
keymap('v', 'p', '"_dP')

-- only if telescope exists
local status_ok, _ = pcall(require, "telescope")
if status_ok then
  -- Telescope mappings
  keymap('n', '<leader>ff', ':Telescope find_files<cr>')
  keymap('n', '<leader>fw', ':Telescope live_grep<cr>')
  keymap('n', '<c-p>', ':Telescope find_files<cr>')
end

-- Neotree mappings
local ok, _ = pcall(require, "neo-tree")
if ok then
  keymap('n', '<leader>e', ':NeoTreeFloatToggle<cr>')
end


-- Navigate buffers
keymap("n", "<S-l>", ":bnext<CR>")
keymap("n", "<S-h>", ":bprevious<CR>")

