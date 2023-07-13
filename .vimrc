"""""""""""""""""""""""""""""""""""""
" Pure VIM! keep it fast and standard
"""""""""""""""""""""""""""""""""""""
" theme is from: leviosa42/kanagawa-mini.vim

"""""""""""""""""""""""""""""""""""""
" Configurations
"""""""""""""""""""""""""""""""""""""
set nocompatible
syntax on
set nowrap
set encoding=UTF-8
set timeout
set updatetime=100
set timeoutlen=100
set cursorline
set termguicolors
set undofile
set ruler
set number
set smarttab
set expandtab
set tabstop=4
set shiftwidth=4
set nofoldenable
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
set guifont=JetBrainsMono_Nerd_Font:h11
set relativenumber
autocmd InsertEnter * :set norelativenumber
autocmd InsertLeave * :set relativenumber
" set spell spelllang=en_us

"""""""""""""""""""""""""""""""""""""
" Theme / Highlights
"""""""""""""""""""""""""""""""""""""
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
highlight CursorLine NONE
highlight CursorLineNr NONE
highlight CursorLineNr guifg=#FFA066

"""""""""""""""""""""""""""""""""""""
" Mappings
"""""""""""""""""""""""""""""""""""""
nnoremap <Tab> :bnext<CR>
nnoremap <S-Tab> :bprevious<CR>

"""""""""""""""""""""""""""""""""""""
" Other
"""""""""""""""""""""""""""""""""""""
" Use a line cursor within insert mode and a block cursor everywhere else.
let &t_SI = "\e[6 q"
let &t_EI = "\e[2 q"
