"""""""""""""""""""""""""""""""""""""""""""""""""""""""
" .vimrc by fixje
" last modified 2010/03/03
"""""""""""""""""""""""""""""""""""""""""""""""""""""""

:set ff=unix

"" General
filetype on
filetype plugin on
filetype indent on
set autoindent
set textwidth=0
" set wrap
set viminfo+=!
colorscheme ron

" delete some buttons from gvim Toolbar
" needed for R plugin
aunmenu ToolBar.Drucken
aunmenu ToolBar.FindNext
aunmenu ToolBar.FindPrev
aunmenu ToolBar.FindHelp
aunmenu ToolBar.Replace
aunmenu ToolBar.Hilfe
aunmenu ToolBar.LoadSesn
aunmenu ToolBar.SaveSesn
aunmenu ToolBar.RunScript
aunmenu ToolBar.-sep3-
aunmenu ToolBar.-sep5-
aunmenu ToolBar.-sep6-
"" favourite terminal emulator
"let g:vimrplugin_term = 'urxvt'
let g:vimrplugin_map_r = 1


"" Colors
set background=dark
syntax on

"" User Interface
set ruler
" set number
set backspace=2
set mouse=a
set laststatus=2

set encoding=utf-8
set noexpandtab
set softtabstop=8
set smarttab

"" Folding
" set foldenable
" set foldmethod=indent
" set foldlevel=100
" set foldopen-=search
" set foldopen-=undo
"

" Spell checking
set autoread
command Abc !aspell -c %

" search on typing
:set incsearch
" highlight search matches
:set hlsearch
" case insensitive search when not needed
:set smartcase

" F10 to quit without saving
:map <F10> :q!<CR>
" ctrl+tab to switch tab in gvim
:map <C-tab> :tabn<CR>
" ctrl-n to change tab in vim
": map <C-n> :bn!<CR>

" use F Keys for copy-paste- buffers
":vmap <F1> "ay
":map <F5> "ap
":vmap <F2> "by
":map <F6> "bp
":vmap <F3> "cy
":map <F7> "cp
":vmap <F4> "dy
":map <F8> "dp

" insert comments with vC or C
:vmap C :s/^/#/<CR>   

" LaTeX Suite
set grepprg=grep\ -nH\ $*
let g:tex_flavor = "latex"
set runtimepath=~/.vim,$VIM/vimfiles,$VIMRUNTIME,$VIM/vimfiles/after,~/.vim/after
let g:Tex_HotKeyMappings = 'itemize,center,enumerate,figure' 
