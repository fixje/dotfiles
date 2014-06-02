###############################################################################
#
# zshrc by fixje <web-code att mfuchs d0tt org>
#
###############################################################################

## Load colors
# enable color support of ls and also add handy aliases
if [ "$TERM" != "dumb" ]; then
    if [ -f /bin/dircolors ]
    then
        eval "`dircolors -b`"
    fi

    # only on Linux
    if [ "$(uname -s)" = "Linux" ]
    then
        alias ls='ls --color=always -h'
        alias grep='grep --color'
    fi
fi
# colored manpages
alias man="TERMINFO=~/.terminfo/ LESS=C TERM=mostlike PAGER=less man"

autoload -U colors
colors


## Completion
zstyle ':completion:*' completer _expand _complete _ignored _approximate
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' completions 1
zstyle ':completion:*' glob 1
zstyle ':completion:*' max-errors 2
zstyle ':completion:*' substitute 1
zstyle :compinstall filename '/home/fixje/.zshrc'

#unsetopt ALWAYS_LAST_PROMPT            # show menu above prompt

autoload -U compinit
compinit


## History 
HISTFILE=~/.zsh_history
HISTSIZE=1000                       # loaded in shell
SAVEHIST=2147483647                 # 'infinite' history file
setopt HIST_IGNORE_DUPS             # no duplicated in history
setopt HIST_IGNORE_SPACE            # cmds with space at beginning => no hist
setopt EXTENDED_HISTORY             # timestamps in history
setopt appendhistory 


## Misc
# disable C-s C-q aka xon/xoff
stty -ixon
EDITOR=vim

setopt autocd beep extendedglob
unsetopt notify                     # no immediate notify of bg jobs
bindkey -e                          # emacs key bindings

## Keyboard input
# create a zkbd compatible hash;
# to add other keys to this hash, see: man 5 terminfo
typeset -A key

key[Home]=${terminfo[khome]}

key[End]=${terminfo[kend]}
key[Insert]=${terminfo[kich1]}
key[Delete]=${terminfo[kdch1]}
key[Up]=${terminfo[kcuu1]}
key[Down]=${terminfo[kcud1]}
key[Left]=${terminfo[kcub1]}
key[Right]=${terminfo[kcuf1]}
key[PageUp]=${terminfo[kpp]}
key[PageDown]=${terminfo[knp]}
key[F1]=${terminfo[kf1]}
key[F2]=${terminfo[kf2]}
key[F3]=${terminfo[kf3]}

# setup key accordingly
[[ -n "${key[Home]}"     ]]  && bindkey  "${key[Home]}"     beginning-of-line
[[ -n "${key[End]}"      ]]  && bindkey  "${key[End]}"      end-of-line
[[ -n "${key[Insert]}"   ]]  && bindkey  "${key[Insert]}"   overwrite-mode
[[ -n "${key[Delete]}"   ]]  && bindkey  "${key[Delete]}"   delete-char
[[ -n "${key[Up]}"       ]]  && bindkey  "${key[Up]}"       up-line-or-history
[[ -n "${key[Down]}"     ]]  && bindkey  "${key[Down]}"     down-line-or-history
[[ -n "${key[Left]}"     ]]  && bindkey  "${key[Left]}"     backward-char
[[ -n "${key[Right]}"    ]]  && bindkey  "${key[Right]}"    forward-char
[[ -n "${key[PageUp]}"   ]]  && bindkey  "${key[PageUp]}"    history-beginning-search-backward
[[ -n "${key[PageDown]}" ]]  && bindkey  "${key[PageDown]}"  history-beginning-search-forward
[[ -n "${key[F1]}" ]]  && bindkey -s "${key[F1]}"   "sudo -s\n"
[[ -n "${key[F2]}" ]]  && bindkey -s "${key[F2]}"   "| less\n"
[[ -n "${key[F3]}" ]]  && bindkey -s "${key[F3]}"   "dmesg\n"

# Finally, make sure the terminal is in application mode, when zle is
# active. Only then are the values from $terminfo valid.
if (( ${+terminfo[smkx]} )) && (( ${+terminfo[rmkx]} )); then
    function zle-line-init () {
        printf '%s' "${terminfo[smkx]}"
    }
    function zle-line-finish () {
        printf '%s' "${terminfo[rmkx]}"
    }
    zle -N zle-line-init
    zle -N zle-line-finish
fi


## Prompt
function preexec() {
  timer=${timer:-$SECONDS}
}

function precmd() {
  if [ $timer ]; then
    timer_show=$(($SECONDS - $timer))
    export RPROMPT="%F{cyan}${timer_show}s %{$reset_color%}%(?.☻.☹)"
    unset timer
  fi
}

PROMPT="%{$fg_bold[grey]%}--------------------------------------------------------------------->
%(!.%{$fg_bold[red]%}.%{$fg_bold[green]%})%n%{$reset_color%}[%{$fg_bold[green]%}%m%{$reset_color%}] %{$fg_no_bold[blue]%}%~ %(!.#.$)%{$reset_color%} "


## Aliases
alias ll='ls -l --group-directories-first'
alias la='ls -A'
alias l='ls -CF --group-directories-first'
alias lll='ls -l --group-directories-first | less'
alias sudo='sudo '              # keep all functions and aliases using sudo
alias j='jobs -l'
alias ..='cd ..'
alias svi='sudoedit'
alias open="kde-open"
alias mkdir='mkdir -p'          # automatically create parent folders
alias webshare='python2 -m SimpleHTTPServer' # share current dir via http:8000
alias g='gvim --remote-silent'  # gvim one session
alias ns='netstat -panut'       # netstat

# git aliases
alias gd='git diff'
alias gdt='git difftool'
alias ga='git add'
alias gst='git status'
alias gca='git commit -a -m'
alias gcm='git commit -m'

# mkdir and cd to dir
mkcd () { mkdir -p $1 && cd $1 ; }

# abbreviation for find
f () { find . -iname "*$1*" ; }

# alterntive for reset
function c() { echo -ne "\033c"; }

# abbreviation for "ps aux | grep" with colors
psgrep () {
    ps aux | grep -v grep | grep --color $1
}

# create a backup file
bak () {
    cp -a $1 ${1}.bak_$(date +%Y%m%d)
}

# extract various archive types 
extract () {
   if [ -f $1 ] ; then
       case $1 in
           *.tar.bz2)   tar xvjf $1    ;;
           *.tar.gz)    tar xvzf $1    ;;
           *.bz2)       bunzip2 $1     ;;
           *.rar)       unrar x $1     ;;
           *.gz)        gunzip $1      ;;
           *.tar)       tar xvf $1     ;;
           *.tbz2)      tar xvjf $1    ;;
           *.tgz)       tar xvzf $1    ;;
           *.zip)       unzip $1       ;;
           *.Z)         uncompress $1  ;;
           *.7z)        7z x $1        ;;
           *.tar.xz)    tar Jxvf $1    ;;
           *)           echo "don't know how to extract '$1'..." ;;
       esac
   else
       echo "'$1' is not a valid file!"
   fi
}

# functions concerning network stuff
geoip () { lynx --dump "http://www.geoiptool.com/?IP=$1" | egrep --color 'City:|IP Address:|Country:' ;}
myip() {  lynx --dump http://checkip.dyndns.org | sed -e 's/Current IP Address://' -e 's/ //g' ;}
# download files of specific type from a website; usage: wgetall pdf http://example.org
wgetall () { wget -r -l1 -nd -Nc -A.$@ $@; }
# test is site is down just for me
isup() { curl -s http://www.isup.me/$1 | grep -o -E "http://$1</a></span>.*$" | sed -s "s/<\/a><\/span>//g" ; }

# ssh tunnel for synergy server
# usage: ssh-synergy user@host
ssh-synergy () {
    if [[ $(echo $1 | grep '@') != "" ]]
    then
        SUSER=$(echo $1 | cut -d '@' -f1)
        SHOST=$(echo $1 | cut -d '@' -f2)
        ssh -f -N -L 24800:${SHOST}:24800 $1 -l $SUSER && synergyc -f localhost
    else
        ssh -f -N -L 24800:${1}:24800 $1 && synergyc -f localhost
    fi
}

# simple portscan with nc
function portscan () {
    nc -w1 -z $1 $2
    if [ ! $? -eq 0 ]; then echo closed; else echo open; fi
}


## Run automatically in background
soffice () { command soffice "$@" 1> /dev/null & }
firefox () { command firefox "$@" 1> /dev/null & }
xpdf () { command xpdf "$@" 1> /dev/null & }
okular () { command okular "$@" 1> /dev/null & }
HandBrake () { command ghb "$@" 1> /dev/null & } 
chrome () { command google-chrome "$@" 1> /dev/null & }
gqview () { command gqview "$@" 1> /dev/null & }
gwenview () { command gwenview "$@" 1> /dev/null & }
gitk () { command gitk "$@" 1> /dev/null & }


## Pacman aliases
if [ -f /usr/bin/pacman ]
then
    alias pacs="pacman -Ss"
    alias pacup="sudo pacman -Syu"
    alias pacins="sudo pacman -S"
    alias pacrm="sudo pacman -Rs"
    alias aurs="yaourt -Ss"
    alias aurup="sudo yaourt --aur -Syu"
    alias aurins="yaourt -S"
fi
