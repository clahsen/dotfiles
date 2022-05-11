#!/usr/bin/bash
export ZSH="$HOME/.oh-my-zsh"

EXT_PLUGINS=(
    davidde/git
    zsh-users/zsh-syntax-highlighting
    zsh-users/zsh-autosuggestions
)

if [[ ! -d ~/.oh-my-zsh ]] ; then
    echo "Get oh-my-zsh"
    git clone https://github.com/ohmyzsh/ohmyzsh.git $ZSH
fi

# install powerlevel10k theme for oh-my-zsh
if [[ ! -d $ZSH/custom/themes/powerlevel10k ]] ; then
    echo  "Install powerlevel10k theme"
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git $ZSH/custom/themes/powerlevel10k
fi

# install external oh-my-zsh plugins
for PLUG in ${EXT_PLUGINS[@]} ; do
    readarray -d "/" -t PLUG_NAME <<< "$PLUG"
    PLUG_NAME=${PLUG_NAME[1]}
    if [[ ! -d $ZSH/custom/plugins/$PLUG_NAME ]] ; then
        echo "Installling external pluging $PLUG"
        git clone https://github.com/$PLUG.git $ZSH/custom/plugins/$PLUG_NAME
    fi
done

# create the links to the config files
if [[ ! -r ~/.zshrc ]] ; then
    ln -s $PWD/.zshrc ~/
else
    mv ~/.zshrc ~/.zshrc.bak
    ln -s $PWD/.zshrc ~/
fi
if [[ ! -r ~/.p10k.zsh ]] ; then
    ln -s $PWD/.p10k.zsh ~/
else
    mv ~/.p10k.zsh ~/.p10k.zsh.bak
    ln -s $PWD/.p10k.zsh ~/
fi

