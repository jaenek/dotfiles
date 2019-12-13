"             _
"            (_)
"  _ ____   ___ _ __ ___
" | '_ \ \ / / | '_ ` _ \
" | | | \ V /| | | | | | |
" |_| |_|\_/ |_|_| |_| |_|

let mapleader =","

call plug#begin('~/.config/nvim/plugged')
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
Plug 'https://gitlab.com/jaenek/wal.vim'
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
set nofixendofline

" Completion:
set tags+=~/.config/nvim/tags/go-gl
set tags+=~/.config/nvim/tags/go-sdl
set completeopt=menuone,menu,longest,preview

" Terminal Function:
let g:term1_buf = 0
let g:term2_buf = 0
let g:term_win = 0
function! TermToggle(height,file)
	if win_gotoid(g:term_win)
		hide
	else
		botright new
		exec "resize " . a:height
		try
			if a:file !=# ""
				exec "buffer " . g:term1_buf
			else
				exec "buffer " . g:term2_buf
			endif
		catch
			if a:file !=# ""
				call termopen($SHELL . " fin " . a:file, {"detach": 0})
				let g:term1_buf = bufnr("")
			else
				call termopen($SHELL, {"detach": 0})
				let g:term2_buf = bufnr("")
			endif
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

" Toggle terminal on/off (neovim)
nmap <leader>t :call TermToggle(12, '')<CR>
tmap <leader>t <C-\><C-n>:call TermToggle(12, '')<CR>

" Compile source file.
nmap <leader>c :w! \| :call TermToggle(12,fnameescape(expand('%:p')))<CR>
tmap <leader>c <C-\><C-n>:q<CR>

" Terminal go back to normal mode
tmap <Esc> <C-\><C-n>
tmap :q <C-\><C-n>:q!<CR>

" Navigating with guides
inoremap <leader><leader> <Esc>/<++><Enter>"_c4l
vnoremap <leader><leader> <Esc>/<++><Enter>"_c4l
map <leader><leader> <Esc>/<++><Enter>"_c4l

" Save file as sudo on files that require root permission
cnoremap w!! execute 'silent! write !sudo tee % >/dev/null' <bar> edit!

" LaTex/RMarkdown:
map <leader>sr <Esc>o"$\\stackrel{\\hbox{\\(<++>\\)}}{\\hbox{\\([<++>]\\)}}$",<Esc>0

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
autocmd StdinReadPre * let s:std_in=1

" Goyo for Vimwiki
autocmd BufRead,BufNewFile *.wiki :Goyo 70%x80%

" Automatically generates htmls for Vimwiki
autocmd QuitPre *.wiki :VimwikiAll2HTML
autocmd QuitPre *.wiki :qa

" Apply templates for files
autocmd BufNewFile *.frag 0r ~/.config/nvim/templates/skeleton.frag
autocmd BufNewFile *.rmd 0r ~/.config/nvim/templates/skeleton.rmd

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

" Fzf:
let g:fzf_action = {
\ 'ctrl-t': 'tab split',
\ 'ctrl-x': 'split',
\ 'ctrl-v': 'vsplit' }

command! -nargs=? -bang -complete=dir Files
\ call fzf#vim#files(<q-args>, <bang>0 ? fzf#vim#with_preview('up:60%') : {}, <bang>0)

nnoremap <leader>o :Files<CR>
nnoremap <leader>O :Files!<CR>

autocmd! FileType fzf
autocmd  FileType fzf set laststatus=0 noshowmode noruler
  \| autocmd BufLeave <buffer> set laststatus=2 showmode ruler
