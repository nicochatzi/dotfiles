set nocompatible
syntax on
set nowrap
set encoding=UTF-8

"""" START Vundle Configuration

" Disable file type for vundle
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'gmarik/Vundle.vim'
Plugin 'neoclide/coc.nvim', {'branch': 'release'}
Plugin 'dense-analysis/ale' " Async Linter Engine
Plugin 'preservim/nerdtree' " File tree
Plugin 'Xuyuanp/nerdtree-git-plugin' "  Nerdtree Git file status
Plugin 'tiagofumo/vim-nerdtree-syntax-highlight' " enable colors for filetype
Plugin 'ryanoasis/vim-devicons'  " Filetype icons support (requires patched font)
Plugin 'scrooloose/nerdtree-project-plugin'
Plugin 'PhilRunninger/nerdtree-visual-selection'
"Plugin 'tomtom/tcomment_vim' " comment/uncomment command with support to embbeded types
Plugin 'vim-airline/vim-airline' " Lean & mean status/tabline
Plugin 'vim-airline/vim-airline-themes' " Airline themes
Plugin 'tpope/vim-fugitive' " Git integration
Plugin 'rbong/vim-flog' " git branch viewer
Plugin 'airblade/vim-gitgutter' " Git status indicator
Plugin 'ctrlpvim/ctrlp.vim' " Fuzzy file, buffer, mru, tag, ... finder for Vim
Plugin 'Yggdroot/indentLine'
Plugin 'pangloss/vim-javascript'    " JavaScript support
Plugin 'leafgarland/typescript-vim' " TypeScript syntax
"Plugin 'HerringtonDarkholme/yats.vim' " TypeScript syntax - rainbow breaks
Plugin 'maxmellon/vim-jsx-pretty'   " JS and JSX syntax
Plugin 'styled-components/vim-styled-components'
Plugin 'jparise/vim-graphql'        " GraphQL syntax
Plugin 'moll/vim-node'
"Plugin 'Quramy/tsuquyomi'
Plugin 'Raimondi/delimitMate' " auto-closing braces
Plugin 'tpope/vim-surround' " (ys) delete, change and insert surroundings
Plugin 'vim-scripts/ReplaceWithRegister' " (gr)
" Requires: python3 -m pip install pynvim
Plugin 'Chiel92/vim-autoformat'
"Plugin 'sheerun/vim-polyglot'
" Colors
Plugin 'sainnhe/sonokai' " Theme
Plugin 'luochen1990/rainbow' " Bracket highlighting
Plugin 'etdev/vim-hexcolor' " highlights hex and rgb color codes in css files

call vundle#end()            " required

let g:coc_global_extensions = [
            \ 'coc-tsserver',
            \ 'coc-rust-analyzer',
            \ 'coc-python',
            \ ]

" Add CoC Prettier if prettier is installed
if isdirectory('./node_modules') && isdirectory('./node_modules/prettier')
    let g:coc_global_extensions += ['coc-prettier']
endif

" Add CoC ESLint if ESLint is installed
if isdirectory('./node_modules') && isdirectory('./node_modules/eslint')
    let g:coc_global_extensions += ['coc-eslint']
endif

nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
nmap <leader>ac  <Plug>(coc-codeaction)
nmap <leader>qf  <Plug>(coc-fix-current)

" OSX stupid backspace fix
set backspace=indent,eol,start

let g:autofmt_autosave = 1
" a basic set up for LanguageClient-Neovim

" << LSP >> {{{

let g:LanguageClient_autoStart = 0
nnoremap <leader>lcs :LanguageClientStart<CR>

" if you want it to turn on automatically
" let g:LanguageClient_autoStart = 1

let g:LanguageClient_serverCommands = {
            \ 'python': ['pyls'],
            \ 'rust': ['rustup', 'run', 'nightly', 'rust-analyzer'],
            \ 'javascript': ['javascript-typescript-stdio'],
            \ 'go': ['go-langserver']
            \ }

noremap <silent> H :call LanguageClient_textDocument_hover()<CR>
noremap <silent> Z :call LanguageClient_textDocument_definition()<CR>
noremap <silent> R :call LanguageClient_textDocument_rename()<CR>
noremap <silent> S :call LanugageClient_textDocument_documentSymbol()<CR>
" }}}

nnoremap <Tab> :bnext<CR>
nnoremap <S-Tab> :bprevious<CR>

let g:ale_linters = {
            \ 'rust': ['analyzer'],
            \ 'typescript': ['tsserver'],
            \ }
let g:ale_fixers = { 'rust': ['rustfmt', 'trim_whitespace', 'remove_trailing_lines'] }
let g:ale_rust_analyzer_config = {
            \ 'diagnostics': { 'disabled': ['unresolved-import'] },
            \ 'cargo': { 'loadOutDirsFromCheck': v:true },
            \ 'procMacro': { 'enable': v:true },
            \ 'checkOnSave': { 'command': 'clippy', 'enable': v:true }
            \ }

" Optional, configure as-you-type completions
set completeopt=menu,menuone,preview,noselect,noinsert
let g:ale_completion_enabled = 1

filetype plugin indent on    " required
"""" END Vundle Configuration

"""""""""""""""""""""""""""""""""""""
" Configuration Section
"""""""""""""""""""""""""""""""""""""
set termguicolors

colorscheme sonokai

" Show linenumbers
set number
set ruler
set relativenumber

" Set Proper Tabs
set tabstop=4
set shiftwidth=4
set smarttab
set expandtab
set guifont=JetBrainsMono_Nerd_Font:h11
set ignorecase              " case insensitive searching
set smartcase               " case-sensitive if expresson contains a capital letter
set hlsearch                " highlight search results
set incsearch               " set incremental search, like modern browsers
"set cursorline              " highligt current line
set autoindent              " automatically set indent of new line
set smartindent
set laststatus=2
set showtabline=2
set guioptions-=e
"set spell spelllang=en_us

let g:NERDTreeDirArrowExpandable = '▸'
let g:NERDTreeDirArrowCollapsible = '▾'
"let g:NERDTreeDirArrowExpandable = '⸠'
"let g:NERDTreeDirArrowCollapsible = '꜖'
let g:NERDTreeGitStatusUseNerdFonts = 1
let g:webdevicons_enable_nerdtree = 1
let g:webdevicons_enable = 1
let g:rainbow_active = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#buffer_nr_show = 1
let g:airline#extensions#tabline#formatter = 'unique_tail'
let g:airline_theme='angr'
let g:airline_powerline_fonts = 1
let g:formatdef_rustfmt = '"rustfmt"'
let g:formatters_rust = ['rustfmt']
let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlP'
"let g:ctrlp_working_path_mode = 'ra'
let g:ctrlp_root_markers = ['Cargo.toml', 'package.json', 'Pipfile']
let g:rustfmt_autosave = 1
let g:rust_cargo_use_clippy = 1
let g:tsuquyomi_completion_detail = 1
let g:python3_host_prog="/Users/nicochatzi/.pyenv/versions/3.8.9/bin/python3"
let g:gitgutter_preview_win_floating = 1
"let g:yats_host_keyword = 1

" Format on save
"au BufWrite * :Autoformat
nmap <Leader>f :Autoformat<CR>

" Exit Vim if NERDTree is the only window left.
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif

" Typescript
autocmd FileType typescript setlocal formatprg=prettier\ --parser\ typescript

