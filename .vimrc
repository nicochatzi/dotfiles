" configuration
""""""""""""""""""""""""""""""""
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
set tabstop=2
set shiftwidth=2
set smarttab
set expandtab
set autoindent              " automatically set indent of new line
set smartindent
set nofoldenable
set ignorecase              " case insensitive searching
set smartcase               " case-sensitive if expresson contains a capital letter
set hlsearch                " highlight search results
set incsearch               " set incremental search, like modern browsers
set laststatus=0
set showtabline=0
set guioptions-=e
set backspace=indent,eol,start " OSX stupid backspace fix
set completeopt=menu,menuone,preview,noselect,noinsert " configure as-you-type completions
set list
set lcs+=trail:.
set guifont=JetBrainsMono_Nerd_Font:h11
set relativenumber
autocmd InsertEnter * :set norelativenumber
autocmd InsertLeave * :set relativenumber
set spell spelllang=en_us
let &spellfile=expand('~/.config/nvim/spell/en.utf-8.add')

" theming
""""""""""""""""""""""""""""""""
" download theme if not present
let theme_path = expand('~/.vim/colors/gruvbox.vim')
let theme_url = 'https://raw.githubusercontent.com/morhetz/gruvbox/040138616bec342d5ea94d4db296f8ddca17007a/colors/gruvbox.vim'
if !filereadable(theme_path)
    execute '!curl -fLo ' . theme_path . ' --create-dirs ' . theme_url
endif

colorscheme gruvbox

if str2nr(system('~/.scripts/is-light-mode; echo $?')) == 0
  set background=light
else
  set background=dark
endif

hi Normal guibg=NONE ctermbg=NONE

" Use a line cursor within insert mode and a block cursor everywhere else.
let &t_SI = "\e[6 q"
let &t_EI = "\e[2 q"
