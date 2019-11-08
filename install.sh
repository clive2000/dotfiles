#!/bin/sh

# cp .config folder
cp -rv .config/ ~/
# cp .zshrc
cp -vf .zshrc ~/.zhsrc


# Activate changes
fc-cache --force
