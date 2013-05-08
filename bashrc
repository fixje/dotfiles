################################################################################
#
# Author: Markus Fuchs <mail att mfuchs d0tt org>
# depends mainly on: lynx, dircolors, lesspipe, bc,
#                    vim
#
################################################################################

## these are some color codes
# regular colors
#local K="\[\033[0;30m\]"    # black
#local R="\[\033[0;31m\]"    # red
#local G="\[\033[0;32m\]"    # green
#local Y="\[\033[0;33m\]"    # yellow
#local B="\[\033[0;34m\]"    # blue
#local M="\[\033[0;35m\]"    # magenta
#local C="\[\033[0;36m\]"    # cyan
#local W="\[\033[0;37m\]"    # white

# emphasized (bolded) colors
#local EMK="\[\033[1;30m\]"
#local EMR="\[\033[1;31m\]"
#local EMG="\[\033[1;32m\]"
#local EMY="\[\033[1;33m\]"
#local EMB="\[\033[1;34m\]"
#local EMM="\[\033[1;35m\]"
#local EMC="\[\033[1;36m\]"
#local EMW="\[\033[1;37m\]"

# If not running interactively, don't do anything:
[ -z "$PS1" ] && return

## History settings
# don't put duplicate entries or those beginning with
# a space in history
export HISTCONTROL=ignoreboth
# we want a big history
export HISTSIZE=10000
# ignore some lines
export HISTIGNORE=l:history*:ls:ll:la:tt:ttl:tta:tts
# time stamps
export HISTTIMEFORMAT="%F %H:%M "
#save multi line cmds in one history entry
shopt -s cmdhist
# disable C-s C-q aka xon/xoff
stty -ixon

#############################################################

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

# set a fancy prompt (non-color, unless we know we "want" color)
# red user@host for root and green user@host else
case "$TERM" in
*xterm*|*rxvt*|linux|*screen*)
    # if we are on a remote host change hostname color
    if [ ! -z "$SSH_CLIENT" ]; 
    then 
        MYHOSTCOLOR='\[\033[01;33m\]'
    fi

    if [ $UID -eq 0 ]
    then
        PS1="\[\033[01;36m\]------------------------------------------------------------------------\n\[\033[01;31m\]\u[${MYHOSTCOLOR}\h\[\033[01;31m\]]\[\033[01;34m\] \w \$\[\033[00m\] "
    else
        PS1="\[\033[01;36m\]------------------------------------------------------------------------\n\[\033[01;32m\]\u[${MYHOSTCOLOR}\h\[\033[01;32m\]]\[\033[01;34m\] \w \$\[\033[00m\] "
    fi
    ;;
*)
    PS1='\u@\h \w \$ '
    ;;
esac


# If this is an xterm set the title to user@host:dir
case "$TERM" in
    xterm*|rxvt*)
        PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME}: ${PWD}\007"'
        ;;
    *)
        ;;
esac

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

#############################################################

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
alias lx='ls -lXB'
alias lll='ls -l --group-directories-first | less'

# trick: keep all functions and aliases using sudo
alias sudo='sudo '

# some little helpers
alias j='jobs -l'
alias whichE='type -a'
alias ..='cd ..'
alias svi='sudo vim'

# automatically create parent folders
alias mkdir='mkdir -p'

# mkdir and cd to dir
mkcd () { mkdir -p $1 && cd $1 ; }

# share current dir via http:8000
alias webshare='python2 -m SimpleHTTPServer'

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
    cp $1 ${1}.bak_$(date +%Y%m%d)
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

# a few calc funtions
calc() { python -c "from math import *; print $1"; }
dec2bin () { echo "ibase=10; obase=2; $1" | bc ;}
bin2dec () { echo "ibase=2; obase=10; $1" | bc ;}
dec2hex () { echo "ibase=10; obase=16; $1" | bc ;}
hex2dec () { python2 -c "print int('$1', 16)" ;}
hex2bin () { dec2bin $(hex2dec $1) ;}

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

# wake up xbox and connect
ssh-xbox () {
    nc -z -w3 xboxkl.no-ip.org 333
    if [ $? -eq 1 ]
    then
        echo "Waking up XBOX"
        wakeonlan -i xboxkl.no-ip.org -f ~/.xbox.wol
        sleep 50
    fi
    for i in $(seq 1 5)
    do
        nc -z -w3 xboxkl.no-ip.org 333
        if [ $? -eq 1 ]
        then
            sleep 10
            continue
        else 
            ssh xbox
            break
        fi
        echo "Connection failed!"
    done
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

# pronounce with merriam-webster
pronounce(){ wget -qO- $(wget -qO- "http://www.m-w.com/dictionary/$@" | grep 'return au' | sed -r "s|.*return au\('([^']*)', '([^'])[^']*'\).*|http://cougar.eb.com/soundc11/\2/\1|") | aplay -q; }

#############################################################

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

#############################################################

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

#############################################################

## Nifty features
# enable lesspipe for syntax highlighting in less
if [ -f /usr/bin/lesspipe.sh ]
then
    eval `lesspipe.sh`
fi

#############################################################

## Environment Variables
# personal variable settings
export EDITOR='vim'

#############################################################
#############################################################

if [ -f /usr/bin/pacman ]
then
    alias pacs="$PACMAN -Ss"
    alias pacup="sudo $PACMAN -Syu"
    alias pacins="sudo $PACMAN -S"
    alias pacrm="sudo $PACMAN -Rsu"
    alias aurs="yaourt -Ss"
    alias aurup="sudo yaourt --aur -Syu"
    alias aurins="yaourt -S"

    # completion for pacman
    complete -cf $PACMAN
fi

#############################################################
#############################################################

## Debian specific stuff
if [ -f /usr/bin/aptitude ]
then
    alias pacs='aptitude search'
    alias pacup='sudo -s aptitude update && aptitude full-upgrade'
    alias pacrm='sudo aptitude remove'
    alias pacins='sudo aptitude install'
fi

#############################################################
#############################################################
#############################################################

## Machine specific stuff
. ~/.bashrc_local

#EOF
