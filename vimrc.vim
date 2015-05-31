" This is standard pathogen and Vim setup
set nocompatible
filetype off

" set the runtime path to include Vundle and initialize
set number
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'tpope/vim-classpath.git'
Plugin 'tpope/vim-leiningen.git'
Plugin 'tpope/vim-projectionist.git'
Plugin 'tpope/vim-dispatch.git'
Plugin 'tpope/vim-fireplace.git'
Plugin 'rainbow_parentheses.vim'
Plugin 'guns/vim-clojure-static'
Plugin 'scrooloose/nerdtree'
Bundle 'jistr/vim-nerdtree-tabs'

call vundle#end()
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just
" :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to
" auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line

call pathogen#infect() 
syntax on
filetype plugin indent on

" Paredit
" let g:paredit_mode = 0

" Rainbow Parentheses
let g:rbpt_colorpairs = [
    \ ['brown',       'RoyalBlue3'],
    \ ['Darkblue',    'SeaGreen3'],
    \ ['darkgray',    'DarkOrchid3'],
    \ ['darkgreen',   'firebrick3'],
    \ ['darkcyan',    'RoyalBlue3'],
    \ ['darkred',     'SeaGreen3'],
    \ ['brown',       'firebrick3'],
    \ ['gray',        'RoyalBlue3'],
    \ ['darkmagenta', 'DarkOrchid3'],
    \ ['Darkblue',    'firebrick3'],
    \ ['darkgreen',   'RoyalBlue3'],
    \ ['darkcyan',    'SeaGreen3'],
    \ ['darkred',     'DarkOrchid3'],
    \ ['red',         'firebrick3'],
    \ ]

let g:rbpt_max = 14

let g:rbpt_loadcmd_toggle = 0

au VimEnter * RainbowParenthesesToggle
au Syntax * RainbowParenthesesLoadRound
au Syntax * RainbowParenthesesLoadSquare
au Syntax * RainbowParenthesesLoadBraces

" key mappings
let mapleader=","
nnoremap <Leader>tt :NERDTreeTabsToggle<CR>
nnoremap <Leader>ff :NERDTreeFocusToggle<CR>
nnoremap <Leader>repl :Console<CR>
nnoremap <Leader>aa :A<CR>
nnoremap <Leader>ee :%Eval<CR>
