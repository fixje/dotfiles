#!/bin/sh
#
# bootstrap dotfiles independently of git

# get the newest version
git pull

CDIR=`pwd`

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
ln -si ${CDIR}/screenrc ${HOME}/.screenrc
ln -si ${CDIR}/tmux.conf ${HOME}/.tmux.conf
ln -si ${CDIR}/vimperatorrc ${HOME}/.vimperatorrc
ln -si ${CDIR}/vimrc ${HOME}/.vimrc
ln -si ${CDIR}/Xdefaults ${HOME}/.Xdefaults
ln -si ${CDIR}/Xmodmap ${HOME}/.Xmodmap

# not included: systemd stuff and xinitrc
