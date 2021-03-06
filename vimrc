"""""""""""""""""""""""""""""""""""""""""""""""""""""""
" .vimrc by fixje
" required plugins:
"    - Latex Suite
"    - You Complete Me
"    - python-mode
"    - vim-ipython
"    - ultisnips
"    - NERDCommenter
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
" colorscheme desertEx
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
set colorcolumn=80
highlight ColorColumn ctermbg=7  guibg=LightGray
set directory=~/.vim/swap   " Don't clutter my dirs up with swp and tmp files
set guioptions-=T           " Disallows gui toolbar
set guioptions-=m           " Hide menu bar
set hidden                  " allow to switch buffers without saving
set laststatus=2            " always enable status bar
set linebreak               " 
set list                    " show tabs and spaces
set vb                      " visual bell to prevent beep
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

"" Let's learn it the hard way
noremap <Left> <nop>
noremap <Right> <nop>
noremap <Down> <nop>
noremap <Up> <nop>

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

" move around in windows easier
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

"" Leader Commands
map <Leader>nh :nohlsearch<CR>
map <Leader>vre :sp ~/.vimrc<CR>:set bufhidden=delete<CR>
map <Leader>cd :lcd %:h<CR>
map <Leader>pp :set paste<CR>
map <Leader>np :set nopaste<CR>
map <Leader>mnt :set noexpandtab nolist<CR>
map <Leader>mt :set expandtab list<CR>

" quickfix window
map <Leader>fc :cclose<CR>
map <Leader>fo :copen<CR>
map <Leader>fn :cn<CR>
map <Leader>fp :cp<CR>
map <Leader>ff :<C-u>exe "cc" . v:count1<CR>

" tags
map <Leader>tt :exe ":ptag ".expand("<cword>")<CR>
map <Leader>ts :exe ":tag ".expand("<cword>")<CR>
map <Leader>tb :pop<CR>

" close preview window
map <Leader>pc :pc<CR>

" delete current buffer
map <Leader>bd :bd<CR>

" git diff
nmap <Leader>gd :new<CR>:read !git diff<CR>:set syntax=diff buftype=nofile bufhidden=delete noswapfile<CR>gg

""""" Plugin Settings
"" LaTeX Suite
set grepprg=grep\ -nH\ $*
let g:tex_flavor = "latex"
set runtimepath=~/.vim,$VIM/vimfiles,$VIMRUNTIME,$VIM/vimfiles/after,~/.vim/after
let g:Tex_HotKeyMappings = 'itemize,center,enumerate,figure' 
let g:Tex_MultipleCompileFormats = 'pdf'
let g:Tex_DefaultTargetFormat='pdf'
let Tex_FoldedSections=""
let Tex_FoldedEnvironments=""
let Tex_FoldedMisc=""

"" NERDCommenter
" just as a reminder:
" Comment: <Leader>cc
" Uncomment: <Leader>cu
" Toggle: <Leader>c<Space>

"" python-mode
" function cannot be too complex ;)
let g:pymode_lint_mccabe_complexity = 100
" disable folding in python-mode
let g:python_folding = 0
let g:pymode_folding = 0
" disable error window
let g:pymode_lint_cwindow = 0
" Skip errors and warnings
" " E.g. "E501,W002", "E2,W" (Skip all Warnings and Errors startswith E2) and
" etc
" let g:pymode_lint_ignore = ""

"" Ultisnips
let g:UltiSnipsExpandTrigger="<C-tab>"
let g:UltiSnipsListSnippets="<C-s-tab>"
" HACK for terminal (in tmux set-option -g xterm-keys on)
imap [27;5;9~ <C-tab>
smap [27;5;9~ <C-tab>
nmap [27;5;9~ <C-tab>
xmap [27;5;9~ <C-tab>

"" YouCompleteMe
let g:ycm_confirm_extra_conf = 0
let g:ycm_key_list_previous_completion=['<Up>']

"" vim-vimux
map <Leader>vl :VimuxRunLastCommand<CR>
map <Leader>vp :VimuxPromptPane<CR>
map <Leader>vi :call VimuxRunCommand("ipython2")<CR>
" send C-c Up <CR> to terminal (to restart application)
function! RestartVimux()
    " C-c ArrowUp <CR>
    :call VimuxRunCommand("OA")
endfunction
map <Leader>vr :call RestartVimux()<CR>
vmap <silent> <C-x> :python run_tmux_python_chunk()<CR>
map <Leader>vx :python run_tmux_python_buffer(True)<CR>

" reload firefox current tab
map <Leader>r :silent execute "!/home/fixje/hacks/firefox-remote-reload.sh &> /dev/null &"<CR> :redraw!<CR>
au BufWritePost *.html silent execute "!/home/fixje/hacks/firefox-remote-reload.sh &> /dev/null &"


"" help function
if !has('python')
  finish
endif

function! LeaderHelp()
python << endpython
import re
reg = re.compile("^(i|v|)?(no)?(re)?map.*<[Ll]eader>.*$")
with open(".vimrc") as rc:
    for l in rc:
        if reg.match(l):
            print l
endpython
endfunction
map <Leader>h :call LeaderHelp()
