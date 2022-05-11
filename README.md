# Installation of the configurations
## ZSH

To setup the zsh configuration, run the `setup_zsh_config.sh` script.
Existing .zshrc and .p10k.zsh are renamed with a .bak ending.
To make zsh the default shell, run:
```shell
chsh -s $(which zsh)
```
You must log out from your user session and log back in to see this change.
