set nocompatible
syntax on set nowrap
set encoding=UTF-8

" keep vim stupid fast by using 0 plugins!
" theme:
" $ mkdir -p ~/.vim/colors
" $ cd ~/.vim/colors
" $ curl https://raw.githubusercontent.com/leviosa42/kanagawa-mini.vim/master/colors/kanagawa-mini.vim -o kanagawa-mini.vim

"""""""""""""""""""""""""""""""""""""
" Configurations
"""""""""""""""""""""""""""""""""""""
set termguicolors
set ruler
set number
set relativenumber
autocmd InsertEnter * :set norelativenumber
autocmd InsertLeave * :set relativenumber
set shiftwidth=4
set ts=4 sw=4
set smarttab
set expandtab
set guifont=JetBrainsMono_Nerd_Font:h11
set ignorecase              " case insensitive searching
set smartcase               " case-sensitive if expresson contains a capital letter
set hlsearch                " highlight search results
set incsearch               " set incremental search, like modern browsers
set autoindent              " automatically set indent of new line
set smartindent
set laststatus=0
set showtabline=0
set guioptions-=e
set backspace=indent,eol,start " OSX stupid backspace fix
set completeopt=menu,menuone,preview,noselect,noinsert " configure as-you-type completions
set list
set lcs+=space:.
" set spell spelllang=en_us

let g:kanagawa_mini = {
    \ 'undercurl': v:true,
    \ 'commentStyle': 'italic',
    \ 'functionStyle': 'NONE',
    \ 'keywordStyle': 'italic',
    \ 'statementStyle': 'bold',
    \ 'typeStyle': 'NONE',
    \ 'specialReturn': v:true,
    \ 'specialExeption': v:true,
    \ 'transparent': v:true,
    \ 'terminalColors': v:true,
    \ 'theme': 'default'
    \ }
colorscheme kanagawa-mini
" colorscheme sonokai

"""""""""""""""""""""""""""""""""""""
" Mappings
"""""""""""""""""""""""""""""""""""""
nnoremap <Tab> :bnext<CR>
nnoremap <S-Tab> :bprevious<CR>

" Use a line cursor within insert mode and a block cursor everywhere else.
"
" Reference chart of values:
"   Ps = 0  -> blinking block.
"   Ps = 1  -> blinking block (default).
"   Ps = 2  -> steady block.
"   Ps = 3  -> blinking underline.
"   Ps = 4  -> steady underline.
"   Ps = 5  -> blinking bar (xterm).
"   Ps = 6  -> steady bar (xterm).
let &t_SI = "\e[6 q"
let &t_EI = "\e[2 q"
