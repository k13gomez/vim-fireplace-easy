" color settings
let macvim_skip_colorscheme=1
set background=dark
colorscheme slate
set guifont=Monaco:h14

" This is standard pathogen and Vim setup
set nocompatible
filetype off

" set the runtime path to include Vundle and initialize
set number
set ruler
set expandtab
set tabstop=4
set rtp+=~/.vim/bundle/Vundle.vim

let g:vundle_default_git_proto = 'git'

call vundle#begin()

Plugin 'VundleVim/Vundle.vim.git'
Plugin 'tpope/vim-classpath.git'
Plugin 'tpope/vim-leiningen.git'
Plugin 'tpope/vim-projectionist.git'
Plugin 'tpope/vim-dispatch.git'
Plugin 'tpope/vim-fireplace.git'
Plugin 'tpope/vim-fugitive.git'
Plugin 'tpope/vim-dotenv.git'
Plugin 'rainbow_parentheses.vim'
Plugin 'paredit.vim'
"Plugin 'bhurlow/vim-parinfer'
Plugin 'eraserhd/parinfer-rust'
Plugin 'guns/vim-clojure-static'
Plugin 'jrdoane/vim-clojure-highlight'

Plugin 'Shougo/deoplete.nvim'
Plugin 'roxma/nvim-yarp'
Plugin 'roxma/vim-hug-neovim-rpc'

Plugin 'scrooloose/nerdtree'
Plugin 'indentjava.vim'
Plugin 'mhinz/vim-startify.git'
Plugin 'hashivim/vim-terraform'
Bundle 'jistr/vim-nerdtree-tabs'
Bundle 'pangloss/vim-javascript.git'
Plugin 'mxw/vim-jsx.git'

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
set tabstop=4
set shiftwidth=4
set expandtab

" Paredit
let g:paredit_mode = 0

" Rainbow Parentheses
let g:rbpt_colorpairs = [
    \ ['brown',       'RoyalBlue3'],
    \ ['green',       'SeaGreen3'],
    \ ['darkgray',    'DarkOrchid3'],
    \ ['darkgreen',   'firebrick3'],
    \ ['darkcyan',    'RoyalBlue3'],
    \ ['darkred',     'SeaGreen3'],
    \ ['brown',       'firebrick3'],
    \ ['gray',        'RoyalBlue3'],
    \ ['darkmagenta', 'DarkOrchid3'],
    \ ['green',       'firebrick3'],
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

" Utility functions
function! DoPrettyXML()
  " save the filetype so we can restore it later
  let l:origft = &ft
  set ft=
  " delete the xml header if it exists. This will
  " permit us to surround the document with fake tags
  " without creating invalid xml.
  1s/<?xml .*?>//e
  " insert fake tags around the entire document.
  " This will permit us to pretty-format excerpts of
  " XML that may contain multiple top-level elements.
  0put ='<PrettyXML>'
  $put ='</PrettyXML>'
  silent %!xmllint --format -
  " xmllint will insert an <?xml?> header. it's easy enough to delete
  " if you don't want it.
  " delete the fake tags
  2d
  $d
  " restore the 'normal' indentation, which is one extra level
  " too deep due to the extra tags we wrapped around the document.
  silent %<
  " back to home
  1
  " restore the filetype
  exe "set ft=" . l:origft
endfunction
command! PrettyXML call DoPrettyXML()

function! Guid()
python3 << EOF
import uuid, vim
vim.command("normal i" + str(uuid.uuid4()) )
EOF
endfunction

function! DateTimeNow()
python3 << EOF
import time, vim
now = time.time()
mlsec = repr(now).split('.')[1][:3]
vim.command("normal i" + time.strftime("%Y-%m-%dT%H:%M:%S.{}%z".format(mlsec), time.localtime(now)))
EOF
endfunction

" Alternate mappings

" key mappings
set backspace=indent,eol,start
let mapleader=","
nnoremap <Leader>te :tabedit<CR>
nnoremap <Leader>tt :NERDTreeTabsToggle<CR>
nnoremap <Leader>ff :NERDTreeFocusToggle<CR>
nnoremap <Leader>guid :call Guid()<CR>
nnoremap <Leader>now :call DateTimeNow()<CR>
nnoremap <Leader>ll :set number<CR>
nnoremap <Leader>nl :set nonumber<CR>
nnoremap <Leader>pp :set paste<CR>
nnoremap <Leader>np :set nopaste<CR>
nnoremap <Leader>par :call PareditToggle()<CR>

au Filetype clojure nmap <Leader>env :verbose Dotenv export-env<CR>
au Filetype clojure nmap <Leader>repl :Console<CR>
au Filetype clojure nmap <Leader>fig :Eval (user/start)<CR>
au Filetype clojure nmap <Leader>pig :Piggieback (figwheel-sidecar.repl-api/repl-env)<CR>
au Filetype clojure nmap <Leader>cljs :Eval (user/cljs)<CR>
au Filetype clojure nmap <Leader>gif :Eval (user/stop)<CR>
au Filetype clojure nmap <Leader>aa :A<CR>
au Filetype clojure nmap <Leader>ee :%Eval<CR>
au Filetype clojure nmap <Leader>er :Eval<CR>
au Filetype clojure nmap <Leader>ss :ClojureHighlightReferences<CR>
au Filetype clojure nmap <Leader>rr :Require<CR>
au Filetype clojure nmap <Leader>rem :Eval (remove-ns (ns-name *ns*))<CR>
au Filetype clojure nmap <Leader>ra :Require!<CR>

" java configuration
autocmd Filetype java set makeprg=javac\ %
autocmd Filetype java set errorformat=%A%f:%l:\ %m,%-Z%p^,%-C%.%#

" javascript configurration
autocmd FileType javascript set tabstop=2|set shiftwidth=2|set expandtab

" cljs configuration
autocmd BufRead,BufNewFile *.cljs setlocal filetype=clojure

" autocomplete configuration
autocmd CompleteDone * pclose

" autocomplete changes
let g:SuperTabCrMapping = 0
let g:acp_enableAtStartup = 0

" Clojure Syntax and Formatting
let g:clojure_fuzzy_indent = 1
let g:clojure_fuzzy_indent_patterns = ['^with.*', '^def', '^let', '^fdef', '?', '^future', '^try', '^catch', '^finally', '^bound.*fn']
let g:clojure_fuzzy_indent_blacklist = [] "['-fn$', '\v^with-%(meta|out-str|loading-context)$']
let g:clojure_special_indent_words = 'deftype,defrecord,reify,proxy,extend-type,extend-protocol,letfn'
let g:clojure_align_subforms = 1
let g:clojure_align_multiline_strings = 1
let g:clojure_maxlines = 0

" Terraform config
let g:terraform_align=1
let g:terraform_fmt_on_save=1
let g:terraform_fold_sections=0
let g:terraform_remap_spacebar=0

" autocomplete
let g:deoplete#enable_at_startup = 1

" Commenting blocks of code.
autocmd FileType c,cs,cpp,java,scala        let b:comment_leader = '//'
autocmd FileType clojure                    let b:comment_leader = ';'
autocmd FileType sh,ruby,python             let b:comment_leader = '#'
autocmd FileType conf,fstab                 let b:comment_leader = '#'
autocmd FileType terraform                  let b:comment_leader = '#'
autocmd FileType make,yaml                  let b:comment_leader = '#'
autocmd FileType tex                        let b:comment_leader = '%'
autocmd FileType mail                       let b:comment_leader = '>'
autocmd FileType vim                        let b:comment_leader = '"'
noremap <silent> ,cc :<C-B>silent <C-E>s/^/<C-R>=escape(b:comment_leader,'\/')<CR>/<CR>:nohlsearch<CR>
noremap <silent> ,cu :<C-B>silent <C-E>s/^\V<C-R>=escape(b:comment_leader,'\/')<CR>//e<CR>:nohlsearch<CR>

" status bar colors
au InsertEnter * hi statusline guifg=black guibg=#d7afff ctermfg=black ctermbg=magenta
au InsertLeave * hi statusline guifg=black guibg=#8fbfdc ctermfg=black ctermbg=cyan
hi statusline guifg=black guibg=#8fbfdc ctermfg=black ctermbg=cyan

" Status line
" default: set statusline=%f\ %h%w%m%r\ %=%(%l,%c%V\ %=\ %P%)

" Status Line Custom
let g:currentmode={
    \ 'n'  : 'Normal',
    \ 'no' : 'Normal·Operator Pending',
    \ 'v'  : 'Visual',
    \ 'V'  : 'V·Line',
    \ '^V' : 'V·Block',
    \ 's'  : 'Select',
    \ 'S'  : 'S·Line',
    \ '^S' : 'S·Block',
    \ 'i'  : 'Insert',
    \ 'R'  : 'Replace',
    \ 'Rv' : 'V·Replace',
    \ 'c'  : 'Command',
    \ 'cv' : 'Vim Ex',
    \ 'ce' : 'Ex',
    \ 'r'  : 'Prompt',
    \ 'rm' : 'More',
    \ 'r?' : 'Confirm',
    \ '!'  : 'Shell',
    \ 't'  : 'Terminal'
    \}

set laststatus=2
set noshowmode
set statusline=
set statusline+=%0*\ %n\                                 " Buffer number
set statusline+=%1*\ %<%F%m%r%h%w\                       " File path, modified, readonly, helpfile, preview
set statusline+=%3*│                                     " Separator
set statusline+=%2*\ %Y\                                 " FileType
set statusline+=%3*│                                     " Separator
set statusline+=%2*\ %{''.(&fenc!=''?&fenc:&enc).''}     " Encoding
set statusline+=\ (%{&ff})                               " FileFormat (dos/unix..)
set statusline+=\ %{FugitiveStatusline()}                " git status
set statusline+=%=                                       " Right Side
set statusline+=%2*\ Col:\ %02v\                         " Column number
set statusline+=%3*│                                     " Separator
set statusline+=%1*\ Line:\ %02l/%L\ (%3p%%)\            " Line number / total lines, percentage of document
set statusline+=\ [%b][0x%B]\                            " ASCII and byte code under cursor
set statusline+=%0*\ %{toupper(g:currentmode[mode()])}\  " The current mode

" command-t config 
let g:CommandTWildIgnore=&wildignore . ",*/bower_components,*/target,*/node_modules"

hi User1 ctermfg=007 ctermbg=239 guibg=#4e4e4e guifg=#adadad
hi User2 ctermfg=007 ctermbg=236 guibg=#303030 guifg=#adadad
hi User3 ctermfg=236 ctermbg=236 guibg=#303030 guifg=#303030
hi User4 ctermfg=239 ctermbg=239 guibg=#4e4e4e guifg=#4e4e4e

" cursor custom
let &t_SI.="\e[5 q"
let &t_SR.="\e[4 q"
let &t_EI.="\e[1 q"
" exit insert mode with ctrl-c 
imap <C-c> <Esc>

" copy paste from system clipboard
set clipboard=unnamed
vmap ç "*y
vmap ≈ "*d
nmap √ :set paste<CR>"*p:set nopaste<CR>
imap √ <ESC>√
