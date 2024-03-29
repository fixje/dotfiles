###############################################################################
#
# zshrc by fixje <web-code att mfuchs d0tt org>
#
###############################################################################

# If not running interactively, don't do anything:
[ -z "$PS1" ] && return

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

# support colors in less
export LESS_TERMCAP_mb=$'\E[01;31m'
export LESS_TERMCAP_md=$'\E[01;31m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;44;33m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;32m'

# colored manpages
alias man="TERMINFO=~/.terminfo/ LESS=C TERM=mostlike PAGER=less man"

autoload -U colors
colors

if [ -d ~/.zsh ]
then
    source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
    source ~/.zsh/git_prompt.zsh

    ## Custom scripts
    fpath=(~/.zsh $fpath) 
fi

## Completion
#unsetopt ALWAYS_LAST_PROMPT            # show menu above prompt

autoload -U compinit
compinit
setopt COMPLETE_IN_WORD

# start menu completion only if it could find no unambiguous initial string
zstyle ':completion:*:correct:*'       insert-unambiguous true
zstyle ':completion:*:corrections'     format $'%{\e[0;31m%}%d (errors: %e)%{\e[0m%}'
zstyle ':completion:*:correct:*'       original true

# activate color-completion
zstyle ':completion:*:default'         list-colors ${(s.:.)LS_COLORS}

# format on completion
zstyle ':completion:*:descriptions'    format $'%{\e[0;31m%}completing %B%d%b%{\e[0m%}'

# insert all expansions for expand completer
zstyle ':completion:*:expand:*'        tag-order all-expansions
zstyle ':completion:*:history-words'   list false

# activate menu
zstyle ':completion:*:history-words'   menu yes

# ignore duplicate entries
zstyle ':completion:*:history-words'   remove-all-dups yes
zstyle ':completion:*:history-words'   stop yes

# match uppercase from lowercase
zstyle ':completion:*'                 matcher-list 'm:{a-z}={A-Z}'

# separate matches into groups
zstyle ':completion:*:matches'         group 'yes'
zstyle ':completion:*'                 group-name ''

if [[ "$NOMENU" -eq 0 ]] ; then
    # if there are more than 3 options allow selecting from a menu
    zstyle ':completion:*'               menu select=3
else
    # don't use any menus at all
    setopt no_auto_menu
fi

zstyle ':completion:*:messages'        format '%d'
zstyle ':completion:*:options'         auto-description '%d'

# describe options in full
zstyle ':completion:*:options'         description 'yes'

# on processes completion complete all user processes
zstyle ':completion:*:processes'       command 'ps -au$USER'

# offer indexes before parameters in subscripts
zstyle ':completion:*:*:-subscript-:*' tag-order indexes parameters

# provide verbose completion information
zstyle ':completion:*'                 verbose true

# recent (as of Dec 2007) zsh versions are able to provide descriptions
# for commands (read: 1st word in the line) that it will list for the user
# to choose from. The following disables that, because it's not exactly fast.
zstyle ':completion:*:-command-:*:'    verbose false

# set format for warnings
zstyle ':completion:*:warnings'        format $'%{\e[0;31m%}No matches for:%{\e[0m%} %d'

# define files to ignore for zcompile
zstyle ':completion:*:*:zcompile:*'    ignored-patterns '(*~|*.zwc)'
zstyle ':completion:correct:'          prompt 'correct to: %e'

# Ignore completion functions for commands you don't have:
zstyle ':completion::(^approximate*):*:functions' ignored-patterns '_*'

# Provide more processes in completion of programs like killall:
zstyle ':completion:*:processes-names' command 'ps c -u ${USER} -o command | uniq'

# complete manual by their section
zstyle ':completion:*:manuals'    separate-sections true
zstyle ':completion:*:manuals.*'  insert-sections   true
zstyle ':completion:*:man:*'      menu yes select

# Search path for sudo completion
zstyle ':completion:*:sudo:*' command-path /usr/local/sbin \
                                           /usr/local/bin  \
                                           /usr/sbin       \
                                           /usr/bin        \
                                           /sbin           \
                                           /bin            \
                                           /usr/X11R6/bin

# provide .. as a completion
zstyle ':completion:*' special-dirs ..

# use generic completion system for programs not yet defined; (_gnu_generic works
# with commands that provide a --help option with "standard" gnu-like output.)
for compcom in cp deborphan df feh fetchipac gpasswd head hnb ipacsum mv \
               pal stow tail uname ; do
    [[ -z ${_comps[$compcom]} ]] && compdef _gnu_generic ${compcom}
done; unset compcom


# complete words from tmux pane(s) {{{1
# Source: http://blog.plenz.com/2012-01/zsh-complete-words-from-tmux-pane.html
_tmux_old=$(tmux capture-pane -J &>/dev/null; echo $?)
_tmux_pane_words() {
    local expl
    local -a w
    if [[ -z "$TMUX_PANE" ]]; then
        _message "not running inside tmux!"
        return 1
    fi
    if [ $_tmux_old -eq 0 ]
    then
        # capture current pane first
        w=( ${(u)=$(tmux capture-pane -J -p)} )
        for i in $(tmux list-panes -F '#P'); do
            # skip current pane (handled above)
            [[ "$TMUX_PANE" = "$i" ]] && continue
            w+=( ${(u)=$(tmux capture-pane -J -p -t $i)} )
        done
    else
        w=( ${(u)=$(tmux capture-pane \; show-buffer \; delete-buffer)} )
    fi
    _wanted values expl 'words from current tmux pane' compadd -a w
}

zle -C tmux-pane-words-prefix complete-word _generic
zle -C tmux-pane-words-anywhere complete-word _generic
bindkey '^X^t' tmux-pane-words-prefix
bindkey '^X^X' tmux-pane-words-anywhere
zstyle ':completion:tmux-pane-words-(prefix|anywhere):*' completer _tmux_pane_words
zstyle ':completion:tmux-pane-words-(prefix|anywhere):*' ignore-line current
# display the (interactive) menu on first execution of the hotkey
zstyle ':completion:tmux-pane-words-(prefix|anywhere):*' menu yes select #interactive
zstyle ':completion:tmux-pane-words-anywhere:*' matcher-list 'b:=* m:{A-Za-z}={a-zA-Z}'
# }}}


## History 
HISTFILE=~/.zsh_history
HISTSIZE=100000                     # loaded in shell
SAVEHIST=2147483647                 # 'infinite' history file
setopt HIST_IGNORE_DUPS             # no duplicated in history
setopt HIST_IGNORE_SPACE            # cmds with space at beginning => no hist
setopt EXTENDED_HISTORY             # timestamps in history
setopt SHARE_HISTORY                # share history among sessions
setopt APPEND_HISTORY


## Dirstack
alias d='dirs -v'
setopt AUTO_PUSHD                   # make cd push the old directory onto the 
                                    # directory stack.
setopt PUSHD_IGNORE_DUPS            # don't push the same dir twice.
DIRSTACKSIZE=${DIRSTACKSIZE:-15}
DIRSTACKFILE=${DIRSTACKFILE:-${ZDOTDIR:-${HOME}}/.zsh_dirs}

if [[ -f ${DIRSTACKFILE} ]] && [[ ${#dirstack[*]} -eq 0 ]] ; then
    dirstack=( ${(f)"$(< $DIRSTACKFILE)"} )
    # "cd -" won't work after login by just setting $OLDPWD, so
    [[ -d $dirstack[1] ]] && cd $dirstack[1] && cd $OLDPWD
fi

chpwd() {
    if (( $DIRSTACKSIZE <= 0 )) || [[ -z $DIRSTACKFILE ]]; then return; fi
    switch_environment_profiles
    local -ax my_stack
    my_stack=( ${PWD} ${dirstack} )
    print -l ${(u)my_stack} >! ${DIRSTACKFILE}
    sort -u $DIRSTACKFILE -o $DIRSTACKFILE
}

#
## Misc
# disable C-s C-q aka xon/xoff
stty -ixon

path=("$HOME/bin" $path)

bindkey -e                          # emacs key bindings
setopt autocd beep extendedglob
setopt noglobdots                   # * shouldn't match dotfiles. ever.
unsetopt notify                     # no immediate notify of bg jobs
setopt longlistjobs                 # display PID when suspending processes

setopt NO_BEEP                      # avoid "beep"ing

# automatically remove duplicates from these arrays
typeset -U path cdpath fpath manpath

export PATH
export EDITOR=vim

# if we don't set $SHELL then aterm, rxvt,.. will use /bin/sh or /bin/bash :-/
if [[ -z "$SHELL" ]] ; then
  SHELL="$(which zsh)"
  if [[ -x "$SHELL" ]] ; then
    export SHELL
  fi
fi

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

# setup keys accordingly
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

# wildcards in history search
bindkey "^R" history-incremental-pattern-search-backward
bindkey "^S" history-incremental-pattern-search-forward

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
    export RPROMPT="$(git_prompt_string) %F{cyan}${timer_show}s %{$reset_color%}%(?.☻.☹)"
    unset timer
  fi
}

function hostColor() {
    # print yellow if ssh session, green otherwise
    if [ -n "$SSH_CLIENT" ] || [ -n "$SSH_TTY" ]; then
      echo -n "yellow"
      return
    # many other tests omitted
    else
      case $(ps -o comm= -p $PPID) in
        sshd|*/sshd) echo -n "yellow"
                     return
      esac
    fi
    echo -n "green"
}

PROMPT="%{$fg_bold[grey]%}-------------------------------------------------------------------------------->
%(!.%{$fg_bold[red]%}.%{$fg_bold[green]%})%n%{$reset_color%}[%{$fg_bold[$(hostColor)]%}%m%{$reset_color%}] %{$fg_no_bold[blue]%}%~ %(!.#.$)%{$reset_color%} "


## Aliases
alias ll='ls -l --group-directories-first'
alias la='ls -A'
alias l='ls -CF --group-directories-first'
alias lll='ls -l --group-directories-first | less'
alias sudo='sudo '              # keep all functions and aliases using sudo
alias j='jobs -l'
alias ..='cd ..'
alias mkdir='mkdir -p'          # automatically create parent folders
alias webshare='python3 -m http.server' # share current dir via http:8000
alias g='grep -R'
alias ns='netstat -panut'       # netstat
alias tma='tmux list-sessions && tmux attach || tmux'
alias certinfo='openssl x509 -text -noout -in'

# git aliases
alias gd='git diff'
alias ga='git add'
alias gst='git status -sb'
alias gnm='git branch --no-merged master'
alias gm='git branch --merged master'

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

# run command in docker container with matching name
dexec () {
    cnt=$(docker ps --format "{{.Names}}" | grep $1 | wc -l)

    if [[ $cnt -lt 1 ]]
    then
        echo "No matching container"
        return
    elif [[ $cnt -gt 1 ]]
    then
        echo "Multiple matches"
        docker ps --format "{{.Names}}" | grep $1
        return
    else
        docker exec -it $(docker ps --format "{{.Names}}" | grep $1) $2
    fi
}


# Usage: simple-extract <file>
# Using option -d deletes the original archive file.
#f5# Smart archive extractor
simple-extract() {
    emulate -L zsh
    setopt extended_glob noclobber
    local DELETE_ORIGINAL DECOMP_CMD USES_STDIN USES_STDOUT GZTARGET WGET_CMD
    local RC=0
    zparseopts -D -E "d=DELETE_ORIGINAL"
    for ARCHIVE in "${@}"; do
        case $ARCHIVE in
            *(tar.bz2|tbz2|tbz))
                DECOMP_CMD="tar -xvjf -"
                USES_STDIN=true
                USES_STDOUT=false
                ;;
            *(tar.gz|tgz))
                DECOMP_CMD="tar -xvzf -"
                USES_STDIN=true
                USES_STDOUT=false
                ;;
            *(tar.xz|txz|tar.lzma))
                DECOMP_CMD="tar -xvJf -"
                USES_STDIN=true
                USES_STDOUT=false
                ;;
            *tar)
                DECOMP_CMD="tar -xvf -"
                USES_STDIN=true
                USES_STDOUT=false
                ;;
            *rar)
                DECOMP_CMD="unrar x"
                USES_STDIN=false
                USES_STDOUT=false
                ;;
            *lzh)
                DECOMP_CMD="lha x"
                USES_STDIN=false
                USES_STDOUT=false
                ;;
            *7z)
                DECOMP_CMD="7z x"
                USES_STDIN=false
                USES_STDOUT=false
                ;;
            *(zip|jar))
                DECOMP_CMD="unzip"
                USES_STDIN=false
                USES_STDOUT=false
                ;;
            *deb)
                DECOMP_CMD="ar -x"
                USES_STDIN=false
                USES_STDOUT=false
                ;;
            *bz2)
                DECOMP_CMD="bzip2 -d -c -"
                USES_STDIN=true
                USES_STDOUT=true
                ;;
            *(gz|Z))
                DECOMP_CMD="gzip -d -c -"
                USES_STDIN=true
                USES_STDOUT=true
                ;;
            *(xz|lzma))
                DECOMP_CMD="xz -d -c -"
                USES_STDIN=true
                USES_STDOUT=true
                ;;
            *)
                print "ERROR: '$ARCHIVE' has unrecognized archive type." >&2
                RC=$((RC+1))
                continue
                ;;
        esac

        GZTARGET="${ARCHIVE:t:r}"
        if [[ -f $ARCHIVE ]] ; then

            print "Extracting '$ARCHIVE' ..."
            if $USES_STDIN; then
                if $USES_STDOUT; then
                    ${=DECOMP_CMD} < "$ARCHIVE" > $GZTARGET
                else
                    ${=DECOMP_CMD} < "$ARCHIVE"
                fi
            else
                if $USES_STDOUT; then
                    ${=DECOMP_CMD} "$ARCHIVE" > $GZTARGET
                else
                    ${=DECOMP_CMD} "$ARCHIVE"
                fi
            fi
            [[ $? -eq 0 && -n "$DELETE_ORIGINAL" ]] && rm -f "$ARCHIVE"

        elif [[ "$ARCHIVE" == (#s)(https|http|ftp)://* ]] ; then
            WGET_CMD="curl -L -k -s -o -"
            #WGET_CMD="wget -q -O - --no-check-certificate"
            print "Downloading and Extracting '$ARCHIVE' ..."
            if $USES_STDIN; then
                if $USES_STDOUT; then
                    ${=WGET_CMD} "$ARCHIVE" | ${=DECOMP_CMD} > $GZTARGET
                    RC=$((RC+$?))
                else
                    ${=WGET_CMD} "$ARCHIVE" | ${=DECOMP_CMD}
                    RC=$((RC+$?))
                fi
            else
                if $USES_STDOUT; then
                    ${=DECOMP_CMD} =(${=WGET_CMD} "$ARCHIVE") > $GZTARGET
                else
                    ${=DECOMP_CMD} =(${=WGET_CMD} "$ARCHIVE")
                fi
            fi

        else
            print "ERROR: '$ARCHIVE' is neither a valid file nor a supported URI." >&2
            RC=$((RC+8))
        fi
    done
    return $RC
}
__archive_or_uri()
{
    _alternative \
        'files:Archives:_files -g "*.(#l)(tar.bz2|tbz2|tbz|tar.gz|tgz|tar.xz|txz|tar.lzma|tar|rar|lzh|7z|zip|jar|deb|bz2|gz|Z|xz|lzma)"' \
        '_urls:Remote Archives:_urls'
}

_simple_extract()
{
    _arguments \
        '-d[delete original archivefile after extraction]' \
        '*:Archive Or Uri:__archive_or_uri'
}
compdef _simple_extract simple-extract
alias extract=simple-extract

# functions concerning network stuff
geoip () { lynx --dump "http://www.geoiptool.com/?IP=$1" | egrep --color 'City:|IP Address:|Country:' ;}
geoip2 () { curl http://api.db-ip.com/v2/free/$1 ; }
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
    alias pacrm="sudo pacman -Rds"
    alias aurs="yaourt -Ss"
    alias aurup="sudo yaourt --aur -Syu"
    alias aurins="yaourt -S"
fi

## Set shell environment by directory
# This will set the environment variable EMAIL to different values, depending
# on the directory in which you are.
#
# Additionally its possible to have hook functions associated to a profile.
# Just define functions similar to the following:
#
# Thx Patrick
# https://github.com/aptituz/zsh/blob/master/directory-based-environment-configuration
#
# function chpwd_profile_PROFILE() {
# print "This is a hook for the PROFILE profile
# }
# Use like this:
# ENV_DEFAULT=(
#     "EMAIL"             "my@primary.mail"
#     "GIT_AUTHOR_EMAIL"  "my@primary.mail"
# )
# ENV_AWESOME=(
#     "EMAIL"             "my@other.mail"
#     "GIT_AUTHOR_EMAIL"  "my@other.mail"
# )
# zstyle ':chpwd:profiles:/path/to/awesome*' profile awesome
#
function detect_env_profile {
    local profile
    zstyle -s ":chpwd:profiles:${PWD}" profile profile || profile='default'
    profile=${(U)profile}
    if [ "$profile" != "$ENV_PROFILE" ]; then
        print "Switching to profile: $profile"
    fi
    ENV_PROFILE="$profile"
}

function switch_environment_profiles {
    detect_env_profile
    config_key="ENV_$ENV_PROFILE"
    for key value in ${(kvP)config_key}; do
        export $key=$value
    done
    # Taken from grml zshrc, allow chpwd_profile_functions()
    if (( ${+functions[chpwd_profile_$ENV_PROFILE]} )) ; then
        chpwd_profile_${ENV_PROFILE}
    fi
}

if [ -f ~/.zsh_private ];
then
    source ~/.zsh_private
fi

### Start ssh-agent
if hash ssh-agent &>/dev/null
then
    if ! pgrep -u "$USER" ssh-agent > /dev/null; then
        ssh-agent > ~/.ssh-agent-thing
    fi
    if [[ "$SSH_AGENT_PID" == "" ]]; then
        eval "$(<~/.ssh-agent-thing)"
    fi
fi

# Attach tmux session (if any) when connection through SSH
[[ $SSH_CONNECTION ]] && [[ $(tmux list-sessions 2>/dev/null) ]] && [[ ! $TMUX ]] && [[ "$TERM" != "screen" ]] && tmux attach

## Convenience for systems with kubectl
if hash kubectl &>/dev/null
then
    source <(kubectl completion zsh)
    alias k=kubectl
fi

# Node Version Manager
if [[ -f /usr/share/nvm/init-nvm.sh ]]
then
    source /usr/share/nvm/init-nvm.sh
fi

# fzf on Arch
if [[ -f /usr/share/fzf/key-bindings.zsh ]]
then
    source /usr/share/fzf/key-bindings.zsh
fi
if [[ -f /usr/share/fzf/completion.zsh ]]
then
    source /usr/share/fzf/completion.zsh
    if [ ! -z "$TMUX" ]; then export FZF_TMUX=1; fi
fi
