"             _
"            (_)
"  _ ____   ___ _ __ ___
" | '_ \ \ / / | '_ ` _ \
" | | | \ V /| | | | | | |
" |_| |_|\_/ |_|_| |_| |_|

let mapleader =","

call plug#begin('~/.config/nvim/plugged')
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'https://gitlab.com/jaenek/wal.vim'
Plug 'ludovicchabant/vim-gutentags'
Plug 'itchyny/lightline.vim'
Plug 'tikhomirov/vim-glsl'
Plug 'tpope/vim-fugitive'
Plug 'junegunn/goyo.vim'
Plug 'ervandew/supertab'
Plug 'vimwiki/vimwiki'
Plug 'junegunn/fzf.vim'
call plug#end()

" Basics:
set go=a
set mouse=a
set nohlsearch
set incsearch
set clipboard^=unnamed,unnamedplus
set nocompatible
set encoding=utf-8
set number relativenumber
set ruler
set tabstop=4
set shiftwidth=4
set backspace=indent,eol,start
set laststatus=2
set noshowmode
set splitbelow splitright
set nofixendofline
set nowrap
filetype plugin on
syntax on
colorscheme wal
call matchadd('ColorColumn', '\%81v')

" Completion:
set completeopt=menuone,menu,longest,preview

"
" REMAPS:
"
" Easier macro playback @q
map <leader>q @q

" Check file in shellcheck:
map <leader>s :w! \| :!clear && shellcheck %<CR>

" Spell-check:
map <leader>S :setlocal spell! spelllang=en_us<CR>

" Shortcutting split navigation, saving a keypress:
map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l

" Replace all is aliased to S.
nnoremap S :%s//g<Left><Left>

" Autoclose quotation
inoremap "" ""<left>
inoremap '' ''<left>
inoremap () ()<left>
inoremap [] []<left>
inoremap {<CR> {<CR>}<ESC>O

" Compile source file.
nmap <leader>c :w! \| :make \| cw<CR><C-k>

" QuickFix navigation
nmap <leader>j :cn<CR>
nmap <leader>k :cp<CR>

" Navigating with guides
inoremap <leader><leader> <Esc>/<++><Enter>"_c4l
vnoremap <leader><leader> <Esc>/<++><Enter>"_c4l
map <leader><leader> <Esc>/<++><Enter>"_c4l

" Save file as sudo on files that require root permission
cnoremap w!! execute 'silent! write !sudo tee % >/dev/null' <bar> edit!

" AUTOCMDS:
"
" Close pmenu if cursormoved or left insert mode:
autocmd CursorMovedI,InsertLeave * if pumvisible() == 0|silent! pclose|endif

" Automatically deletes all trailing whitespace on save.
autocmd BufWritePre * %s/\s\+$//e

" Update shorcuts for bash and file manager:
autocmd BufWritePost ~/.config/directories,~/.config/files !shortcuts

" Disables automatic commenting on newline:
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o
autocmd StdinReadPre * let s:std_in=1

" Goyo for Vimwiki
autocmd BufRead,BufNewFile *.wiki :Goyo 70%x80%

" Automatically generates htmls for Vimwiki
autocmd QuitPre *.wiki :VimwikiAll2HTML
autocmd QuitPre *.wiki :qa

" Apply templates for files
autocmd BufNewFile *.frag 0r ~/.config/nvim/templates/skeleton.frag

" PLUGINS:
"
" Goyo:
nnoremap <leader>g :silent Goyo \| set linebreak<CR>

" Netrw:
let g:netrw_browsex_viewer="cabl"

" Lightline:
let g:lightline = {
\ 'colorscheme': 'wal',
\ 'active': {
\ 'left': [ [ 'mode', 'paste' ],
\           [ 'gitbranch', 'readonly', 'filename' ] ],
\ 'right': [ [ 'lineinfo'],
\            [ 'fileformat', 'filetype' ] ],
\ },
\ 'component_function': {
\   'readonly': 'LightlineReadonly',
\   'gitbranch': 'fugitive#head',
\ },
\ }

function! LightlineReadonly()
  return expand('%:t') =~ &readonly ? 'RO' : ''
endfunction

" Vimwiki:
let g:vimwiki_list = [{'path': '~/sync/wiki/'}]
let g:vimwiki_autowriteall=1

" Fzf:
let g:fzf_action = {
\ 'ctrl-t': 'tab split',
\ 'ctrl-s': 'split',
\ 'ctrl-v': 'vsplit' }

command! -nargs=? -bang -complete=dir Files
\ call fzf#vim#files(<q-args>, <bang>0 ? fzf#vim#with_preview('up:60%') : {}, <bang>0)

nnoremap <leader>o :Files<CR>
nnoremap <leader>O :Files!<CR>

autocmd! FileType fzf
autocmd  FileType fzf set laststatus=0 noshowmode noruler
  \| autocmd BufLeave <buffer> set laststatus=2 showmode ruler
