let mapleader = " "

"" Colors
" highlight TODO and FIXME in every filetype
highlight Todo ctermbg=yellow guibg=yellow ctermfg=red guifg=red term=bold gui=bold
highlight Fixme ctermbg=red guibg=red ctermfg=yellow guifg=yellow term=bold gui=bold
match Todo /TODO:*/
match Fixme /FIXME:*/
highlight Task ctermfg=DarkYellow guifg=DarkYellow
match Task /^\s*- \[ \].*/

"
" """""" User Interface
set backspace=2
highlight ColorColumn ctermbg=7  guibg=LightGray
set listchars=tab:>·,trail:·

set guifont=Hack

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

" move marked lines up and down
nnoremap <A-j> :m .+1<CR>==
nnoremap <A-k> :m .-2<CR>==
inoremap <A-j> <Esc>:m .+1<CR>==gi
inoremap <A-k> <Esc>:m .-2<CR>==gi
vnoremap <A-j> :m '>+1<CR>gv=gv
vnoremap <A-k> :m '<-2<CR>gv=gv

"" Leader Commands
map <Leader>nh :nohlsearch<CR>
map <Leader>cd :lcd %:h<CR>
map <Leader>pp :set paste<CR>
map <Leader>np :set nopaste<CR>
map <Leader>tt :set noexpandtab nolist<CR>
map <Leader>nt :set expandtab list<CR>

" git diff
nmap <Leader>gd :new<CR>:read !git diff<CR>:set syntax=diff buftype=nofile bufhidden=delete noswapfile<CR>gg

let g:vim_markdown_folding_disabled = 1

let g:airline_powerline_fonts = 1
