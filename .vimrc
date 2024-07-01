" Some basics
set nocompatible
filetype off
syntax enable
set encoding=utf-8
set t_Co=256                " Deal with colors
set number relativenumber
set nobackup
set noswapfile
set cursorline
set showmatch               " Highight matching braces
set noerrorbells            " Disable annoying beeping
set visualbell              " Use a visual bell to notify us
set wildmenu                " Enable autocompletion in command mode
set colorcolumn=80          " Highlight 80 character limit
set scrolloff=999           " Keep the cursor centered in the screen

" Copy/paste between vim and other programs
set clipboard+=unnamedplus
set mouse=r

" Indentation
set expandtab               " Expand tabs to the proper type and size
set tabstop=4 shiftwidth=4  " One tab == four spaces
set softtabstop=4
set autoindent              " Use indentation of previous line

" Search settings
set incsearch
set hlsearch                " Highlight results
set ignorecase smartcase    " Be smart about case sensitivity when searching

" vim-plug for managing plugins
call plug#begin('~/.vim/plugged')
Plug 'itchyny/lightline.vim'
Plug 'morhetz/gruvbox'
Plug 'vimwiki/vimwiki'
Plug 'ap/vim-css-color'     " Preview colours
Plug 'tpope/vim-surround'	" Change surrounding marks
Plug 'tpope/vim-commentary'
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && yarn install' }
call plug#end()

filetype plugin indent on   " Required

" Lightline statusbar config
set laststatus=2            " Always show statusline
set noshowmode              " Prevent non-normal modes showing in lightline and below lightline
let g:lightline = { 'colorscheme': 'jellybeans' }

" Colorscheme config
set background=dark         " Setting dark mode
let g:gruvbox_italic=1
let g:gruvbox_contrast_dark='hard'
autocmd vimenter * ++nested colorscheme gruvbox

" 24-bit (true-color) mode
let &t_8f = "\<Esc>[38:2:%lu:%lu:%lum"
let &t_8b = "\<Esc>[48:2:%lu:%lu:%lum"
if (has("termguicolors"))
    set termguicolors
endif

" vimwiki config
let g:vimwiki_list = [{'path': '~/Documents/vimwiki/',
                      \ 'syntax': 'markdown', 'ext': '.md'}]

" markdown-preview config
let g:mkdp_refresh_slow = 1 " Refresh markdown on save

" Set leader key to SPACE instead of '\'
let mapleader=" "

" Set splits to open below and on the right side
set splitbelow splitright

" Make navigating around splits easier: CTRL + hjkl
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" No help information needed when using the file explorer
let g:netrw_banner = 0

" Shortcutting the file explorer
map <Leader>ve :Vexplore<CR>
map <Leader>he :Sexplore<CR>

" Open terminal inside Vim
map <Leader>tb :vert term bash<CR>
map <Leader>tz :vert term zsh<CR>

" Exit terminal mode
tnoremap <Esc> <C-\><C-n>:q!<CR>

" Change 2 split windows from vert to horiz and vice versa
map <Leader>r <C-w>t<C-w>H
map <Leader>R <C-w>t<C-w>K

" Make adjusing split sizes a bit more friendly
noremap <silent> <C-Left> :vertical resize +3<CR>
noremap <silent> <C-Right> :vertical resize -3<CR>
noremap <silent> <C-Up> :resize +3<CR>
noremap <silent> <C-Down> :resize -3<CR>

" vim doesn't recognise CTRL key when running inside alacritty
if (&term == "alacritty")
    set term=xterm-256color
endif

" Automatically deletes all trailing whitespace and newlines at end of file on save
autocmd BufWritePre * %s/\s\+$//e
autocmd BufWritePre * %s/\n\+\%$//e

" Coding styles
augroup FixHeaderFiles
    autocmd! BufRead,BufNewFile *.h set filetype=c
augroup END
autocmd FileType c set noexpandtab tabstop=8 softtabstop=8 shiftwidth=8
autocmd FileType html,xml,css,ruby,yaml set tabstop=2 softtabstop=2 shiftwidth=2
