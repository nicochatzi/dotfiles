{
  pkgs,
  full ? false,
  ...
}: let
  config = ''
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
    set lcs+=trail:.
    set guifont=JetBrainsMono_Nerd_Font:h11
    set relativenumber
    autocmd InsertEnter * :set norelativenumber
    autocmd InsertLeave * :set relativenumber
    set spell spelllang=en_us

    colorscheme gruvbox
    highlight CursorLine NONE
    highlight CursorLineNr NONE
    highlight CursorLineNr guifg=#FFA066
    highlight SpellBad NONE
    highlight SpellBad cterm=underline guisp=#C34043
    highlight SpellCap NONE
    highlight SpellCap cterm=underline guisp=#DCA561
    highlight SpellRare NONE
    highlight SpellRare cterm=underline guisp=#DCA561
    highlight SpellLocal NONE
    highlight SpellLocal cterm=underline guisp=#DCA561

    nnoremap <Tab> :bnext<CR>
    nnoremap <S-Tab> :bprevious<CR>

    " Use a line cursor within insert mode and a block cursor everywhere else.
    let &t_SI = "\e[6 q"
    let &t_EI = "\e[2 q"

    if str2nr(system('~/.scripts/is-light-mode; echo $?')) == 0
      set background=light
    else
      set background=dark
    endif
  '';

  vimFull = pkgs.vim-full.customize {
    name = "vim";
    vimrcConfig = {
      customRC = config;
      packages.myVimPackage = with pkgs.vimPlugins; {
        start = [gruvbox];
        opt = [];
      };
    };
  };

  vimRegular = pkgs.vim.override {
    vimrcConfig = {
      customRC = config;
    };
  };
in
  if full
  then vimFull
  else vimRegular
