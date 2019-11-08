#!/bin/sh

# cp .config folder
cp -rv .config/ ~/
# cp .zshrc
cp -vf .zshrc ~/.zshrc


# Activate changes
fc-cache --force
