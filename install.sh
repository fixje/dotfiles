#!/bin/sh
#
# bootstrap dotfiles independently of git

# get dir of this script
# thx to http://stackoverflow.com/questions/59895/getting-the-source-directory-of-a-bash-script-from-within
SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
    CDIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
    SOURCE="$(readlink "$SOURCE")"
    [[ $SOURCE != /* ]] && SOURCE="$CDIR/$SOURCE" # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
done
CDIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"

cd $CDIR

# get the newest version
git pull


# install terminfo
tic ${CDIR}/terminfo/mostlike.txt
tic ${CDIR}/terminfo/urxvt.txt

# link it
install -d ~/.config
ln -si ${CDIR}/awesome ${HOME}/.config/awesome
ln -si ${CDIR}/fluxbox ${HOME}/.fluxbox
ln -si ${CDIR}/htop ${HOME}/.config/htop
ln -si ${CDIR}/qjoypad3 ${HOME}/.qjoypad3
ln -si ${CDIR}/synergy ${HOME}/.config/synergy
ln -si ${CDIR}/vim ${HOME}/.vim


ln -si ${CDIR}/bashrc ${HOME}/.bashrc
ln -si ${CDIR}/zshrc ${HOME}/.zshrc
ln -si ${CDIR}/zsh ${HOME}/.zsh
ln -si ${CDIR}/gitconfig ${HOME}/.gitconfig
ln -si ${CDIR}/gvimrc ${HOME}/.gvimrc
ln -si ${CDIR}/inputrc ${HOME}/.inputrc
ln -si ${CDIR}/my.cnf ${HOME}/.my.cnf
ln -si ${CDIR}/screenrc ${HOME}/.screenrc
ln -si ${CDIR}/tmux.conf ${HOME}/.tmux.conf
ln -si ${CDIR}/vimperatorrc ${HOME}/.vimperatorrc
install -d ~/.vim/swap
ln -si ${CDIR}/vimrc ${HOME}/.vimrc
ln -si ${CDIR}/Xdefaults ${HOME}/.Xdefaults
ln -si ${CDIR}/Xmodmap ${HOME}/.Xmodmap

# not included: systemd stuff and xinitrc
