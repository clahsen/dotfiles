#!/usr/bin/bash

# create the links to the config files
if [[ ! -r ~/.vim ]] ; then
    ln -s $PWD/.vim ~/
else
    mv ~/.vim ~/.vim.bak
    ln -s $PWD/.vim ~/
fi
if [[ ! -r ~/.vimrc ]] ; then
    ln -s $PWD/.vimrc ~/
else
    mv ~/.vimrc ~/.vimrc.bak
    ln -s $PWD/.vimrc ~/
fi
