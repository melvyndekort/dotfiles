" Plugin configuration
if empty(glob('~/.local/share/nvim/site/autoload/plug.vim'))
  silent !curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.local/share/nvim/site/plugged')

Plug 'tpope/vim-sensible'
Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }
Plug 'itchyny/lightline.vim'
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-fugitive'
Plug 'dracula/vim', { 'as': 'dracula' }
Plug 'junegunn/fzf.vim'

call plug#end()

set noshowmode
set background=dark
set showmatch
set hlsearch
set wrap
set ls=2
set softtabstop=2
set tabstop=2
set shiftwidth=2
set expandtab
set cindent
set nolist
set pastetoggle=<F9>
set number relativenumber
set nu rnu

let mapleader = '\'

nnoremap <C-N> :next<CR>
nnoremap <C-P> :prev<CR>

nnoremap <C-Y> :NERDTreeToggle<CR>

nnoremap <leader>g    :GFiles<CR>
nnoremap <leader>f    :Files<CR>
nnoremap <leader><CR> :Buffers<CR>
nnoremap <leader>l    :Lines<CR>
nnoremap <leader>h    :History<CR>

nnoremap <leader>w    :set wrap!<CR>

nnoremap Y y$

inoremap <C-k> <Up>
inoremap <C-j> <Down>
inoremap <C-h> <Left>
inoremap <C-l> <Right>

nnoremap <Tab>   >>
nnoremap <S-Tab> <<
vnoremap <Tab>   >><Esc>gv
vnoremap <S-Tab> <<<Esc>gv

" lightline config
let g:lightline = {
      \ 'colorscheme': 'wombat',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'gitbranch', 'readonly', 'filename', 'modified' ] ]
      \ },
      \ 'component': {
      \   'lineinfo': "%{line('.') . '/' . line('$')} : %-2v"
      \ },
      \ 'component_function': {
      \   'gitbranch': 'fugitive#head'
      \ },
      \ }

