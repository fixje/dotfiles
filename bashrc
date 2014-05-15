################################################################################
#
# Author: Markus Fuchs <mail att mfuchs d0tt org>
#
# Thou shalt never forget this:
#   $ foo bar 1234| oO(Damn forgot bazz!) =>
#   <C-u> =>  $ | => $ bazz|<CR> $| <C-y> =>
#   $ foo bar 1234|
#
################################################################################

# If not running interactively, don't do anything:
[ -z "$PS1" ] && return

## History settings
# don't put duplicate entries or those beginning with
# a space in history
export HISTCONTROL=ignoreboth
# load these lines from the history file
export HISTSIZE=10000
# history file may grow to infinity
export HISTFILESIZE=""
# ignore some lines
export HISTIGNORE=l:history*:ls:ll:la:tt:ttl:tta:tts
# time stamps
export HISTTIMEFORMAT="%F %H:%M "
#save multi line cmds in one history entry
shopt -s cmdhist
# disable C-s C-q aka xon/xoff
stty -ixon

###############################################################################

## Window settings and prompt
# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# treat input like "/path/to/go" like "cd /path/to/go/"
shopt -s autocd
# correct misspelled words in cd and dirs
shopt -s cdspell
shopt -s dirspell
# enable advanced pattern matching
#shopt -s extglob
#shopt -s globstar

### set a fancy prompt
# if we are on a remote host change hostname color
if [ ! -z "$SSH_CLIENT" ]; 
then 
    MYHOST='\[\033[01;33m\][\h]'
else
    MYHOST='[\h]'
fi
## timer for all commands run
function timer_start {
  timer=${timer:-$SECONDS}
}
function timer_stop {
  timer_show=$(($SECONDS - $timer))
  echo -ne "\033[01;36m------------------------------------------------------------\033[01;30m-[last: ${timer_show}s]->\n"
  unset timer
}

trap 'timer_start' DEBUG
PROMPT_COMMAND=timer_stop

# red user@host for root and green user@host else
if [ $UID -eq 0 ]
then
    PS1="\[\033[01;31m\]\u[${MYHOST}\[\033[01;31m\]]\[\033[01;34m\] \w \$\[\033[00m\] "
else
    PS1="\[\033[01;32m\]\u${MYHOST}\[\033[01;32m\]\[\033[01;34m\] \w \$\[\033[00m\] "
fi

###############################################################################

# set xterm title
function xtitle()      # Adds some text in the terminal frame.
{
    case "$TERM" in
        *term | rxvt*)
            echo -n -e "\033]0;$*\007"
            ;;
        *)  
            ;;
    esac
}

# aliases that use xtitle
alias top='xtitle top for ${USER}@${HOSTNAME} && top'
alias htop='xtitle htop for ${USER}@${HOSTNAME} && htop'
alias iotop='xtitle iotop for ${USER}@${HOSTNAME} && iotop'
alias iftop='xtitle iftop on $HOSTNAME && sudo iftop'

###############################################################################
###############################################################################

## Aliases and self-defined functions
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

# some more ls aliases
alias ll='ls -l --group-directories-first'
alias la='ls -A'
alias l='ls -CF --group-directories-first'
alias lll='ls -l --group-directories-first | less'

# trick: keep all functions and aliases using sudo
alias sudo='sudo '

# some little helpers
alias j='jobs -l'
alias which_='type -a'
alias ..='cd ..'
alias svi='sudoedit'
alias pd="pushd"
alias pod="popd"
alias open="kde-open"

# automatically create parent folders
alias mkdir='mkdir -p'

# mkdir and cd to dir
mkcd () { mkdir -p $1 && cd $1 ; }

# share current dir via http:8000
alias webshare='python2 -m SimpleHTTPServer'

# gvim one session
alias g='gvim --remote-silent'

# git aliases
alias gd='git diff'
alias gdt='git difftool'
alias ga='git add'
alias gst='git status'
alias gca='git commit -a -m'
alias gcm='git commit -m'

# netstat
alias ns='netstat -panut'

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

# google search and open in browser
function gg () {
    url=$(echo http://google.com/search?q=$(echo "$@" | sed s/\ /+/g))
    if [[ "$DISPLAY" = "" ]]; then
        $BROWSER "$url"
    else
        firefox "$url"
    fi
}

# view man pages in vim
function vman {
  /usr/bin/man $* | /usr/bin/col -bp | /usr/bin/iconv -c | \
  /usr/bin/vim -R -c "set ft=man nomod nolist so=999 ts=8 wrap\
  titlestring=man\ $1" -c "let @f = 'ggVGgqgg'" -
}

# simple portscan with nc
function portscan () {
    nc -w1 -z $1 $2
    if [ ! $? -eq 0 ]; then echo closed; else echo open; fi
}

###############################################################################

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

###############################################################################

## Completion
# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profiles
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion.d ]; then
    . /etc/bash_completion
fi

# don't complete empty lines
shopt -s no_empty_cmd_completion

# add completition for various applications
complete -cf sudo
complete -cf man

###############################################################################

## Nifty features
# enable lesspipe for syntax highlighting in less
if [ -f /usr/bin/lesspipe.sh ]
then
    eval `lesspipe.sh`
fi

###############################################################################

## Environment Variables
export EDITOR='vim'

###############################################################################
###############################################################################

if [ -f /usr/bin/pacman ]
then
    alias pacs="pacman -Ss"
    alias pacup="sudo pacman -Syu"
    alias pacins="sudo pacman -S"
    alias pacrm="sudo pacman -Rs"
    alias aurs="yaourt -Ss"
    alias aurup="sudo yaourt --aur -Syu"
    alias aurins="yaourt -S"

    # completion for pacman
    complete -cf pacman
fi

###############################################################################
###############################################################################

## Debian specific stuff
if [ -f /usr/bin/aptitude ]
then
    alias pacs='aptitude search'
    alias pacup='sudo -s aptitude update && aptitude full-upgrade'
    alias pacrm='sudo aptitude remove'
    alias pacins='sudo aptitude install'
fi

###############################################################################
###############################################################################
## Machine specific stuff
if [ -f ~/.bashrc_local ]
then
. ~/.bashrc_local
fi
