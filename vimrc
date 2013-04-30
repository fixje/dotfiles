"""""""""""""""""""""""""""""""""""""""""""""""""""""""
" .vimrc by fixje
" required plugins:
"    - Latex Suite
"""""""""""""""""""""""""""""""""""""""""""""""""""""""


"" General
set ff=unix
set encoding=utf-8
filetype on
filetype plugin on
filetype indent on
" set wrap
set viminfo+=!
let mapleader = ","

"" Colors
set background=dark
syntax on
" colorscheme solarized

"" Change the status line based on mode
if version >= 700
  au InsertEnter * hi StatusLine term=reverse ctermbg=5 gui=undercurl guisp=Magenta
  au InsertLeave * hi StatusLine term=reverse ctermfg=0 ctermbg=2 gui=bold,reverse
endif

"""""" User Interface
set autoindent
set backspace=2
set backupdir=~/.vim/swap
set cursorline              " hilight current line
set directory=~/.vim/swap   " Don't clutter my dirs up with swp and tmp files
set hidden                  " allow to switch buffers without saving
set laststatus=2            " always enable status bar
set linebreak               " 
set list                  " show tabs and spaces
set listchars=tab:>·,trail:·
set mouse=a                 " let's do everything with the mouse
set nu!                     " show line numbers
set numberwidth=4           " width of line number column
set nostartofline
set relativenumber          " relative line numbers from cursor
set ruler
set scrolloff=10
set showcmd
set showmatch
set textwidth=0
set wrap

"" Tabs and Spaces
set expandtab               " replace tabs by spaces
set tabstop=4               " 1 tab equals X spaces
set shiftwidth=4            " ...
set smarttab

"" Search settings
set incsearch               " search while typing
set hlsearch                " hilight matches when searching
set smartcase               " case insensitive search

"" Spell checking
set autoread

"" Turn on omnicomplete
set ofu=syntaxcomplete#Complete

""""" Commands
" F10 to quit without saving
:map <F10> :q!<CR>
map <C-s> <esc>:w<CR>
imap <C-s> <esc>:w<CR>
" Emacs-like beginning and end of line.
imap <c-e> <c-o>$
imap <c-a> <c-o>^
" paste in insert mode: <C-r> {register}| " | * where " is lat yank and * is
" clipboard

" ctrl+tab to switch buffer
map <C-tab> :bn<CR>
map <C-S-tab> :bp<CR>
map <F3> :ts<CR>
imap <C-Space> <C-x><C-o>

" move marked lines up and down
nnoremap <A-j> :m .+1<CR>==
nnoremap <A-k> :m .-2<CR>==
inoremap <A-j> <Esc>:m .+1<CR>==gi
inoremap <A-k> <Esc>:m .-2<CR>==gi
vnoremap <A-j> :m '>+1<CR>gv=gv
vnoremap <A-k> :m '<-2<CR>gv=gv

map <Leader>nh :nohlsearch<CR>
map <Leader>vre :sp ~/.vimrc<CR>
map <Leader>vrs :so $MYVIMRC<CR>

" insert comments with vC or C
:vmap C :s/^/#/<CR>   


""""" abbreviations
:iab TCP \ac{TCP}
:iab PIF \ac{PIF}
:iab ACK \ac{ACK}
:iab RTT \ac{RTT}


""""" LaTeX Suite
set grepprg=grep\ -nH\ $*
let g:tex_flavor = "latex"
set runtimepath=~/.vim,$VIM/vimfiles,$VIMRUNTIME,$VIM/vimfiles/after,~/.vim/after
let g:Tex_HotKeyMappings = 'itemize,center,enumerate,figure' 
let g:Tex_MultipleCompileFormats = 'pdf'
let g:Tex_DefaultTargetFormat='pdf'
let Tex_FoldedSections=""
let Tex_FoldedEnvironments=""
let Tex_FoldedMisc=""

