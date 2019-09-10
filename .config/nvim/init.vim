"             _
"            (_)
"  _ ____   ___ _ __ ___
" | '_ \ \ / / | '_ ` _ \
" | | | \ V /| | | | | | |
" |_| |_|\_/ |_|_| |_| |_|

let mapleader =","

call plug#begin('~/.config/nvim/plugged')
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
Plug 'https://gitlab.com/jaenek/wal.vim'
Plug 'itchyny/lightline.vim'
Plug 'scrooloose/nerdtree'
Plug 'tikhomirov/vim-glsl'
Plug 'tpope/vim-fugitive'
Plug 'junegunn/goyo.vim'
Plug 'ervandew/supertab'
Plug 'vimwiki/vimwiki'
call plug#end()

" Basics:
set go=a
set mouse=a
set nohlsearch
set incsearch
set clipboard=unnamedplus
set nocompatible
filetype plugin on
syntax on
colorscheme wal
set encoding=utf-8
set number relativenumber
set ruler
set colorcolumn=80
set tabstop=4
set shiftwidth=4
set backspace=indent,eol,start
set laststatus=2
set noshowmode
set splitbelow splitright
set clipboard^=unnamed,unnamedplus

" Completion:
set tags+=~/.config/nvim/tags/go-gl
set tags+=~/.config/nvim/tags/go-sdl
set completeopt=menuone,menu,longest,preview

" Terminal Function:
let g:term_buf = 0
let g:term_win = 0
function! TermToggle(height)
  if win_gotoid(g:term_win)
    hide
  else
    botright new
    exec "resize " . a:height
    try
      exec "buffer " . g:term_buf
    catch
      call termopen($SHELL, {"detach": 0})
      let g:term_buf = bufnr("")
      set nonumber
      set norelativenumber
      set signcolumn=no
    endtry
    startinsert!
      let g:term_win = win_getid()
  endif
endfunction

"
" REMAPS:
"
" Easier macro playback @q
noremap Q @q

" Spell-check set to <leader>o, 'o' for 'orthography':
map <leader>o :setlocal spell! spelllang=en_us<CR>

" Check file in shellcheck:
map <leader>s :!w \| !clear && shellcheck %<CR>

" Shortcutting split navigation, saving a keypress:
map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l

" Replace all is aliased to S.
nnoremap S :%s//g<Left><Left>

" Compile source file.
map <leader>c :w! \| !fin <c-r>%<CR>

" Copy selected text to system clipboard (requires gvim/nvim/vim-x11 installed):
vnoremap <C-c> "+y
map <C-p> "+P

" Autoclose quotation
inoremap "" ""<left>
inoremap '' ''<left>
inoremap () ()<left>
inoremap [] []<left>
inoremap {<CR> {<CR>}<ESC>O

" Toggle terminal on/off (neovim)
nnoremap <leader>t :call TermToggle(12)<CR>
tnoremap <leader>t <C-\><C-n>:call TermToggle(12)<CR>

" Terminal go back to normal mode
tnoremap <Esc> <C-\><C-n>
tnoremap :q! <C-\><C-n>:q!<CR>

"
" AUTOCMDS:
"
" Close pmenu if cursormoved or left insert mode:
autocmd CursorMovedI,InsertLeave * if pumvisible() == 0|silent! pclose|endif

" Automatically deletes all trailing whitespace on save.
autocmd BufWritePre * %s/\s\+$//e

" Update shorcuts for bash and file manager:
autocmd BufWritePost ~/.config/.bmdirs,~/.config/.bmfiles !shortcuts

" Disables automatic commenting on newline:
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o

" Open NERDTree automatically when nvim starts up on opening a directory
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) &&
\ !exists("s:std_in") | exe 'NERDTree' argv()[0] | wincmd p | ene |
\ exe 'cd '.argv()[0] | endif

" Close vim if the only window left open is a NERDTree
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") &&
\ b:NERDTree.isTabTree()) | q | endif

" Goyo for Vimwiki
autocmd BufRead,BufNewFile *.wiki :Goyo 50%x60%

" Automatically generates htmls for Vimwiki
autocmd QuitPre *.wiki :VimwikiAll2HTML
autocmd QuitPre *.wiki :qa

" Apply template for .frag files
autocm BufNewFile *.frag 0r ~/.config/nvim/templates/skeleton.frag

"
" PLUGINS:
"
" Goyo:
map <leader>f :silent Goyo \| set linebreak<CR>

" NERDTree:
let g:NERDTreeDirArrowExpandable = '→'
let g:NERDTreeDirArrowCollapsible = '↓'
map <leader>v :NERDTreeToggle<CR>

" Netrw:
let g:netrw_browsex_viewer="url"

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
\   'mode': 'LightlineMode',
\   'readonly': 'LightlineReadonly',
\   'gitbranch': 'fugitive#head',
\   'filename': 'LightlineFilename',
\   'fileformat': 'LightlineFileformat',
\   'filetype': 'LightlineFiletype',
\   'lineinfo': 'LightlineLineinfo',
\ },
\ }

function! LightlineMode()
  return expand('%:t') =~ 'NERD_tree' ? '' : lightline#mode()
endfunction

function! LightlineReadonly()
  return expand('%:t') =~ 'NERD_tree' ? '' : &readonly ? 'RO' : ''
endfunction

function! LightlineFilename()
  let fname = expand('%:t')
  return fname =~ 'NERD_tree' ? 'NERD' : fname
endfunction

function! LightlineFileformat()
  return expand('%:t') =~ 'NERD_tree' ? '' : &fileformat
endfunction

function! LightlineFiletype()
  return expand('%:t') =~ 'NERD_tree' ? '' : &filetype
endfunction

function! LightlineLineinfo()
  return expand('%:t') =~ 'NERD_tree' ? '' : line('.').':'. col('.')
endfunction

" Vim-go:
let g:go_list_type = "quickfix"
map <C-n> :cnext<CR>
map <C-m> :cprevious<CR>
nnoremap <leader>a :cclose<CR>
autocmd FileType go nmap <leader>b  <Plug>(go-build)
autocmd FileType go nmap <leader>r  <Plug>(go-run)

" Vimwiki:
let g:vimwiki_list = [{'path': '~/sync/wiki/'}]
let g:vimwiki_autowriteall=1
