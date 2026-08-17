" .vimrc - plugin-free port of my Neovim options/keybinds (init.lua + lua/kickstart/options.lua)
" Works in both regular Vim and Neovim.

let mapleader = " "
let maplocalleader = " "

" [[ Options ]]
set number                  " Make line numbers default
set relativenumber
set tabstop=2               " insert 2 spaces for a tab
set mouse=a
set mousemodel=extend       " disable mouse right-click popup
set noshowmode               " Don't show the mode, since it's already in the status line
set nowrap
set breakindent             " Enable break indent
set undofile                 " Save undo history
set noswapfile
set nowritebackup
" Case-insensitive searching UNLESS \C or one or more capital letters in the search term
set ignorecase
set smartcase
set signcolumn=yes          " Keep signcolumn on by default
set updatetime=500           " Decrease update time
set timeoutlen=250           " Decrease mapped sequence wait time
" Configure how new splits should be opened
set splitright
set splitbelow
if has('nvim')
  set inccommand=split       " Preview substitutions live, as you type! (Neovim only)
endif
set cursorline               " Show which line your cursor is on
set scrolloff=10             " Minimal number of screen lines to keep above and below the cursor
set hlsearch
if has('clipboard')
  set clipboard=unnamedplus  " Sync clipboard between OS and Vim
endif

" [[ Basic Keymaps ]]

" Set highlight on search, but clear on pressing <Esc> in normal mode
nnoremap <Esc> <cmd>nohlsearch<CR>

" Quick save mappings
nnoremap <leader>w :wa<CR>
nnoremap <leader>q :wqa<CR>

" Multiline on single wrapped
nnoremap j gj
nnoremap k gk
nnoremap <M-l> <Nop>
nnoremap <M-h> <Nop>

" Dont stop visual mode on indent
vnoremap < <gv
vnoremap > >gv
vnoremap <C-,> <gv
vnoremap <C-.> >gv

nnoremap <C-,> <<
nnoremap <C-.> >>

" Quickfix list navigation
nnoremap <C-j> <cmd>cnext<CR>
nnoremap <C-k> <cmd>cprev<CR>

" Exit terminal mode with a shortcut that is a bit easier to discover than <C-\><C-n>
tnoremap <Esc><Esc> <C-\><C-n>

" Toggle options
nnoremap <leader>tw <cmd>set wrap!<CR>
