#!/bin/bash

# Install Homebrew
which brew > /dev/null 2>&1
if [ $? -eq 1 ]; then
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
	brew update
fi

# Symlinks

BASEDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# git
ln -s ${BASEDIR}/.gitconfig ~/.gitconfig

# zsh
ln -s ${BASEDIR}/.zshrc ~/.zshrc

# Install brew bundles:

brew bundle --file ~/.dotfiles/Brewfile