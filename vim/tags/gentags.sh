tp=${HOME}/.vim/tags

# glibc
ctags -L <(pacman -Ql glibc | grep /usr/include | awk '{print $2}') -f ${tp}/tags.c

# cpp
ctags --c++-kinds=+p --extra=+q -f ${tp}/tags.cpp -R /usr/include/c++/*

# python
cud=$(pwd)
cd $tp
rm tags 2> /dev/null
/usr/lib/python2.7/Tools/scripts/ptags.py $(pacman -Ql python2 | grep /usr/lib | grep -E ".*\.py$" | awk '{print $2}' | tr "\n" " ")
mv tags tags.py
cd $cud
