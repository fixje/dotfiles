"""""""""""""""""""""""""""""""""""""""""""""""""""""""
" .vimrc by fixje
" required plugins:
"    - NERDTree or CtrlP
"    - FuzzyFinder
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

" automatically reload vimrc when it's saved
" au BufWritePost .vimrc so ~/.vimrc

"" Colors
set t_Co=256
set background=dark
syntax on
colorscheme molokai
" highlight TODO and FIXME in every filetype
highlight Todo ctermbg=yellow guibg=yellow ctermfg=red guifg=red term=bold gui=bold
highlight Fixme ctermbg=red guibg=red ctermfg=yellow guifg=yellow term=bold gui=bold
match Todo /TODO:*/
match Fixme /FIXME:*/

"" Change the status line based on mode
if version >= 700
  au InsertEnter * hi StatusLine term=reverse ctermbg=5 gui=undercurl guisp=Magenta
  au InsertLeave * hi StatusLine term=reverse ctermfg=0 ctermbg=2 gui=bold,reverse
endif

"""""" User Interface
set autoindent
set autoread                " spell checking
set backspace=2
set nobackup
set nowritebackup
set cursorline              " hilight current line
set colorcolumn=160
highlight ColorColumn ctermbg=7  guibg=LightGray
set directory=~/.vim/swap   " Don't clutter my dirs up with swp and tmp files
set guioptions-=T           " Disallows gui toolbar
set guioptions-=m           " Hide menu bar
set hidden                  " allow to switch buffers without saving
set laststatus=2            " always enable status bar
set linebreak               " 
set vb                      " visual bell to prevent beep
set list                    " show tabs and spaces "nolist" to disable
set listchars=tab:>·,trail:·
set mouse=a                 " let's do everything with the mouse
set nu!                     " show line numbers
set numberwidth=4           " width of line number column
set nostartofline
set relativenumber          " relative line numbers from cursor
set ruler
set scrolloff=10
set showbreak=↪
set showcmd
set showmatch
set textwidth=0
set wildmenu                " menu for command line auto-completion
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


"" Turn on omnicomplete
set ofu=syntaxcomplete#Complete

"" Page scroll with cursor in the middle
noremap <C-u> <C-u>zz
noremap <C-d> <C-d>zz

""""" Keyboard Commands
imap <C-s> <esc>:w<CR>
map <C-s> <esc>:w<CR>
noremap YY :qa!<CR>
" Emacs-like beginning and end of line.
imap <c-e> <c-o>$
imap <c-a> <c-o>^
" paste in insert mode: <C-r> {register}| " | * where " is lat yank and * is
" clipboard

" mappings for FuzzyFinder
nnoremap <C-f> :FufBuffer<CR>

" move marked lines up and down
nnoremap <A-j> :m .+1<CR>==
nnoremap <A-k> :m .-2<CR>==
inoremap <A-j> <Esc>:m .+1<CR>==gi
inoremap <A-k> <Esc>:m .-2<CR>==gi
vnoremap <A-j> :m '>+1<CR>gv=gv
vnoremap <A-k> :m '<-2<CR>gv=gv
" same for 7-bit terminal
"" bad idea as it maps Esc!
"nnoremap j :m .+1<CR>==
"inoremap j <Esc>:m .+1<CR>==gi
"vnoremap j :m '>+1<CR>gv=gv
"inoremap k <Esc>:m .-2<CR>==gi
"nnoremap k :m .-2<CR>==
"vnoremap k :m '<-2<CR>gv=gv

"" Leader Commands
map <Leader>nh :nohlsearch<CR>
map <Leader>cd :lcd %:h<CR>
map <Leader>pp :set paste<CR>
map <Leader>np :set nopaste<CR>
map <Leader>mnt :set noexpandtab nolist<CR>
map <Leader>mt :set expandtab list<CR>

" CtrlP buffer and file explorer
let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlP'
"" Go to nearest VCS root
let g:ctrlp_working_path_mode = 'ra'
let g:ctrlp_root_markers = ['pom.xml', '.p4ignore']

"" help function
if !has('python')
  finish
endif

function! LeaderHelp()
python << endpython
import re
import os
reg = re.compile("^(i|v|)?(no)?(re)?map.*<[Ll]eader>.*$")
with open(os.environ["HOME"] + "/.vimrc") as rc:
    for l in rc:
        if reg.match(l):
            print l
endpython
endfunction
map <Leader>h :call LeaderHelp()<CR>
