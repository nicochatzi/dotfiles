set nocompatible
syntax on
set nowrap
set encoding=UTF-8

"""""""""""""""""""""""""""""""""""""
" Vundle Plugins
"""""""""""""""""""""""""""""""""""""
filetype off " Disable file type for vundle (required)
" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'gmarik/Vundle.vim'
Plugin 'nvim-lua/plenary.nvim'
Plugin 'neoclide/coc.nvim', {'branch': 'master'}
Plugin 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plugin 'junegunn/fzf.vim'
Plugin 'preservim/nerdtree' " File tree
Plugin 'Xuyuanp/nerdtree-git-plugin' "  Nerdtree Git file status
Plugin 'ryanoasis/vim-devicons'  " Filetype icons support (requires patched font)
Plugin 'tomtom/tcomment_vim' " (gc) comment/uncomment
Plugin 'vim-airline/vim-airline' " Lean & mean status/tabline
Plugin 'vim-airline/vim-airline-themes' " Airline themes
Plugin 'tpope/vim-fugitive' " Git integration
Plugin 'rbong/vim-flog' " :Flog git branch viewer
Plugin 'airblade/vim-gitgutter' " Git status indicator
Plugin 'ctrlpvim/ctrlp.vim' " Fuzzy file, buffer, mru, tag, ... finder for Vim
Plugin 'Yggdroot/indentLine' "vertical lines at each indentation
Plugin 'pangloss/vim-javascript' " JavaScript support
Plugin 'maxmellon/vim-jsx-pretty' " JS and JSX syntax
Plugin 'peitalin/vim-jsx-typescript' " TSX syntax
Plugin 'jparise/vim-graphql' " GraphQL syntax
Plugin 'moll/vim-node'
Plugin 'Quramy/tsuquyomi'
Plugin 'terryma/vim-multiple-cursors' " VSCode style multi-cursors
Plugin 'Raimondi/delimitMate' " auto-closing braces
Plugin 'tpope/vim-surround' " (ys) delete, change and insert surroundings
Plugin 'vim-scripts/ReplaceWithRegister' " (gr)
Plugin 'Chiel92/vim-autoformat' " Requires: python3 -m pip install pynvim
Plugin 'sheerun/vim-polyglot'
Plugin 'sainnhe/sonokai' " Monokai Pro style theme
Plugin 'rebelot/kanagawa.nvim' "colorscheme
Plugin 'luochen1990/rainbow' " Bracket highlighting
Plugin 'NoahTheDuke/vim-just' " justfile support
Plugin 'kergoth/vim-bitbake' " BitBake support
Plugin 'iamcco/markdown-preview.nvim' " post installation, run :call mkdp#util#install()
call vundle#end()
filetype plugin indent on " (required)

"""""""""""""""""""""""""""""""""""""
" Conquer of Completion
"""""""""""""""""""""""""""""""""""""
let g:coc_global_extensions = [
            \ 'coc-fzf-preview',
            \ 'coc-clangd',
            \ 'coc-cmake',
            \ 'coc-rust-analyzer',
            \ 'coc-tsserver',
            \ 'coc-jedi',
            \ 'coc-markdownlint',
            \ 'coc-json',
            \ 'coc-sh',
            \ 'coc-zig',
            \ 'coc-spell-checker',
            \ ]
if isdirectory('./node_modules') && isdirectory('./node_modules/prettier')
    let g:coc_global_extensions += ['coc-prettier']
endif
if isdirectory('./node_modules') && isdirectory('./node_modules/eslint')
    let g:coc_global_extensions += ['coc-eslint']
endif

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
set laststatus=2
set showtabline=2
set guioptions-=e
set backspace=indent,eol,start " OSX stupid backspace fix
set completeopt=menu,menuone,preview,noselect,noinsert " configure as-you-type completions
set list
set lcs+=space:.
set spell spelllang=en_us

let g:sonokai_better_performance = 1
let g:sonokai_transparent_background=2
let g:NERDTreeGitStatusUseNerdFonts = 1
let g:NERDTreeShowHidden=1
let g:webdevicons_enable_nerdtree = 1
let g:webdevicons_enable = 1
let g:rainbow_active = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#buffer_nr_show = 1
let g:airline#extensions#tabline#formatter = 'unique_tail'
let g:airline_theme='sonokai'
let g:airline_powerline_fonts = 1
let g:ctrlp_map = '<leader>p'
let g:ctrlp_cmd = 'CtrlP'
let g:ctrlp_working_path_mode = 'ra'
let g:ctrlp_root_markers = ['Cargo.toml', 'package.json', 'Pipfile', 'CMakeLists.txt']
let g:rust_cargo_use_clippy = 1
let g:tsuquyomi_completion_detail = 1
let g:python3_host_prog="/usr/local/bin/python3"
let g:gitgutter_preview_win_floating = 1
let g:yats_host_keyword = 1
let g:vim_markdown_folding_disabled = 1
let g:vim_markdown_conceal = 0
let g:vim_markdown_conceal_code_blocks = 0
" https://github.com/luochen1990/rainbow/issues/77
let g:rainbow_conf = {
            \ 'guifgs': [
            \       'peachpuff2',
            \       'aquamarine3',
            \       'lightcoral',
            \       'darkseagreen2',
            \       'plum1'
            \   ],
            \   'separately': {
            \       'cmake': 0,
            \   }
            \}
"colorscheme kanagawa-dragon
colorscheme sonokai

"""""""""""""""""""""""""""""""""""""
" Mappings
"""""""""""""""""""""""""""""""""""""
nnoremap <Tab> :bnext<CR>
nnoremap <S-Tab> :bprevious<CR>
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)
nmap <leader>a  <Plug>(coc-codeaction)
nmap <leader>r  <Plug>(coc-rename)
nmap <leader>q  <Plug>(coc-fix-current)
nmap <Leader>f :Autoformat<CR>
nmap <leader>s :Rg<CR>
" <leader>p is mapped by CtrlP plugin

"""""""""""""""""""""""""""""""""""""
" Automatic Commands
"""""""""""""""""""""""""""""""""""""
" Format on save
" au BufWrite * :Autoformat
" Exit Vim if NERDTree is the only window left.
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType")
            \ && b:NERDTreeType == "primary") | q | endif
autocmd BufNewFile,BufRead *.tsx,*.jsx set filetype=typescriptreact
autocmd FileType yaml,typescript.tsx,javascript.jsx,javascript,typescript
            \ let g:indent_guides_guide_size = 2
"autocmd BufNewFile *.rs :CocCommand rust-analyzer.upgrade

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
