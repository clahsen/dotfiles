export ZSH="$HOME/.oh-my-zsh"

if [[ ! -d ~/.oh-my-zsh ]] ; then
    echo "Setting up the zsh configuration"
    git clone https://github.com/ohmyzsh/ohmyzsh.git $ZSH
fi
# install powerlevel10k theme for oh-my-zsh
if [[ ! -d $PWD/custom/themes/powerlevel10k ]] ; then
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git $PWD/custom/themes/powerlevel10k
fi
# upgrade to custom git plugin
if [[ ! -d $PWD/custom/plugins/git ]] ; then
    git clone https://github.com/davidde/git.git $PWD/custom/plugins/git
fi
# create the links to the config files
if [[ ! -r $PWD/.zshrc ]] ; then
    ln -s $PWD/.zshrc ~/
else
    mv ~/.zshrc ~/.zshrc.bak
    ln -s $PWD/.zshrc ~/
fi
if [[ ! -r $PWD/.p10k.zsh ]] ; then
    ln -s $PWD/.p10k.zsh ~/
else
    mv ~/.p10k.zsh ~/.p10k.zsh.bak
    ln -s $PWD/.p10k.zsh ~/
fi

