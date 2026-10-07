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

link() {
	local src="$1" dest="$2"
	if [ -e "$dest" ] && [ ! -L "$dest" ]; then
		mv "$dest" "$dest.bak"
	fi
	ln -sfn "$src" "$dest"
}

mkdir -p ~/.config/tmux

# git
link "${BASEDIR}/.gitconfig" ~/.gitconfig

# Keep personal Git identity outside the dotfiles repository.
if [ ! -e "$HOME/.gitconfig.local" ]; then
	git_name=""
	git_email=""
	while [[ ! "$git_name" =~ [^[:space:]] ]]; do
		read -r -p "Git author name: " git_name || exit 1
	done
	while [[ ! "$git_email" =~ [^[:space:]] ]]; do
		read -r -p "Git email: " git_email || exit 1
	done
	git config --file "$HOME/.gitconfig.local" user.name "$git_name" || exit 1
	git config --file "$HOME/.gitconfig.local" user.email "$git_email" || exit 1
fi

# zsh
link "${BASEDIR}/.zshrc" ~/.zshrc

# neovim
link "${BASEDIR}/nvim" ~/.config/nvim

# tmux
link "${BASEDIR}/tmux/tmux.conf" ~/.config/tmux/tmux.conf

# Install brew bundles:

brew bundle --file "${BASEDIR}/Brewfile"

# tmux plugin manager
if [ ! -d ~/.config/tmux/plugins/tpm ]; then
	git clone https://github.com/tmux-plugins/tpm ~/.config/tmux/plugins/tpm
fi

# neovim plugins at the versions pinned in lazy-lock.json
nvim --headless "+Lazy! restore" +qa
