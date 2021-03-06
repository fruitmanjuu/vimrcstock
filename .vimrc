
set nocompatible
set cursorline
set cursorcolumn

set incsearch
set ttyfast
set showtabline=2

set fenc=utf-8
set nobomb
set nobackup
set noswapfile
set showcmd
set hidden

set backspace=indent,eol,start

"setting indent
set autoindent
set smartindent
set breakindent

"status line ever indicate
set laststatus=2
set autowrite

"setting copy & paste
set clipboard=unnamed,autoselect

"tab & other settings
set shiftwidth=4
set tabstop=4
set noexpandtab
set number
set title
set background=dark

"color terminal::
set t_Co=256

"color scheme setting::
colorscheme molokai
syntax enable


"use multibyte character setting
set ambiwidth=double


"dein Scripts-----------------------------
if &compatible
  set nocompatible               
endif

" Required:
set runtimepath+=/home/kotonoha/.cache/dein/repos/github.com/Shougo/dein.vim

" Required:
if dein#load_state('/home/kotonoha/.cache/dein')
  call dein#begin('/home/kotonoha/.cache/dein')

  " Let dein manage dein
  " Required:
  call dein#add('/home/kotonoha/.cache/dein/repos/github.com/Shougo/dein.vim')

  " Add or remove your plugins here:
  	"web関係
    call dein#add('itchyny/lightline.vim')
    call dein#add('othree/html5.vim')
	call dein#add('hail2u/vim-css3-syntax')
	call dein#add('othree/yajs.vim')
	call dein#add('mattn/emmet-vim')
	"vimの拡張関係
	call dein#add('scrooloose/nerdtree')
	call dein#add('lordm/vim-browser-reload-linux')
	call dein#add('tyru/open-browser.vim')
	call dein#add('Shougo/neocomplete.vim')
	call dein#add('Shougo/neosnippet.vim')



  " Required:
  call dein#end()
  call dein#save_state()
endif

" Required:
filetype plugin indent on
syntax on

" If you want to install not installed plugins on startup.
if dein#check_install()
  call dein#install()
endif

"End dein Scripts-------------------------

"NERDTree settings
"
autocmd vimenter * if !argc() | NERDTree | endif

autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

nnoremap <silent><C-e> :NERDTreeToggle<CR>


"open-browser.vim settings
let g:netrw_nogx = 1 " disable netrw's gx mapping.
nmap gx <Plug>(openbrowser-smart-search)
vmap gx <Plug>(openbrowser-smart-search)


"neocomplete settings (github/Shougo)

"Note: This option must be set in .vimrc(_vimrc).  NOT IN .gvimrc(_gvimrc)!
" Disable AutoComplPop.
let g:acp_enableAtStartup = 0
" Use neocomplete.
let g:neocomplete#enable_at_startup = 1
" Use smartcase.
let g:neocomplete#enable_smart_case = 1
" Set minimum syntax keyword length.
let g:neocomplete#sources#syntax#min_keyword_length = 3

" Define dictionary.
let g:neocomplete#sources#dictionary#dictionaries = {
    \ 'default' : '',
    \ 'vimshell' : $HOME.'/.vimshell_hist',
    \ 'scheme' : $HOME.'/.gosh_completions'
        \ }

" Define keyword.
if !exists('g:neocomplete#keyword_patterns')
    let g:neocomplete#keyword_patterns = {}
endif
let g:neocomplete#keyword_patterns['default'] = '\h\w*'

" Plugin key-mappings.
inoremap <expr><C-g>     neocomplete#undo_completion()
inoremap <expr><C-l>     neocomplete#complete_common_string()

" Recommended key-mappings.
" <CR>: close popup and save indent.
inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
function! s:my_cr_function()
  return (pumvisible() ? "\<C-y>" : "" ) . "\<CR>"
  " For no inserting <CR> key.
  "return pumvisible() ? "\<C-y>" : "\<CR>"
endfunction
" <TAB>: completion.
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
" <C-h>, <BS>: close popup and delete backword char.
inoremap <expr><C-h> neocomplete#smart_close_popup()."\<C-h>"
inoremap <expr><BS> neocomplete#smart_close_popup()."\<C-h>"
" Close popup by <Space>.
"inoremap <expr><Space> pumvisible() ? "\<C-y>" : "\<Space>"

" AutoComplPop like behavior.
"let g:neocomplete#enable_auto_select = 1

" Shell like behavior(not recommended).
"set completeopt+=longest
"let g:neocomplete#enable_auto_select = 1
"let g:neocomplete#disable_auto_complete = 1
"inoremap <expr><TAB>  pumvisible() ? "\<Down>" : "\<C-x>\<C-u>"

" Enable omni completion.
autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags

" Enable heavy omni completion.
if !exists('g:neocomplete#sources#omni#input_patterns')
  let g:neocomplete#sources#omni#input_patterns = {}
endif
"let g:neocomplete#sources#omni#input_patterns.php = '[^. \t]->\h\w*\|\h\w*::'
"let g:neocomplete#sources#omni#input_patterns.c = '[^.[:digit:] *\t]\%(\.\|->\)'
"let g:neocomplete#sources#omni#input_patterns.cpp = '[^.[:digit:] *\t]\%(\.\|->\)\|\h\w*::'

" For perlomni.vim setting.
" https://github.com/c9s/perlomni.vim
let g:neocomplete#sources#omni#input_patterns.perl = '\h\w*->\h\w*\|\h\w*::'
