#!/bin/sh

# cp .config folder
cp -rv .config/ ~/


# Activate changes
fc-cache --force
