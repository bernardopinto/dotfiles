#!/bin/bash

# Install Homebrew
which brew > /dev/null 2>&1
if [ $? -eq 1 ]; then
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
	brew update
fi

# A fresh Homebrew install isn't on PATH yet; stop until the user sets it up.
if ! command -v brew > /dev/null 2>&1; then
	brew_bin=/opt/homebrew/bin/brew
	[ -x "$brew_bin" ] || brew_bin=/usr/local/bin/brew
	echo "Homebrew is not on your PATH. Run the following, then re-run this script:" >&2
	echo >&2
	echo "  echo 'eval \"\$(${brew_bin} shellenv zsh)\"' >> ~/.zprofile" >&2
	echo "  eval \"\$(${brew_bin} shellenv zsh)\"" >&2
	exit 1
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
# ~/.zshrc stays a local file that sources the shared config, so installers
# that append to it (e.g. sdkman) don't modify this repository.
zshrc_source="source \"${BASEDIR}/.zshrc\""
if ! grep -qxF "$zshrc_source" ~/.zshrc 2>/dev/null; then
	{ echo "$zshrc_source"; cat ~/.zshrc 2>/dev/null; } > ~/.zshrc.tmp && mv ~/.zshrc.tmp ~/.zshrc
fi

# neovim
link "${BASEDIR}/nvim" ~/.config/nvim

# tmux
link "${BASEDIR}/tmux/tmux.conf" ~/.config/tmux/tmux.conf

# starship
link "${BASEDIR}/starship.toml" ~/.config/starship.toml

# Install brew bundles:

brew bundle --file "${BASEDIR}/Brewfile"

# Node.js LTS via fnm (needed by Mason's pyright and typescript-tools.nvim);
# the first installed version becomes fnm's default.
fnm install --lts

# tmux plugin manager
if [ ! -d ~/.config/tmux/plugins/tpm ]; then
	git clone https://github.com/tmux-plugins/tpm ~/.config/tmux/plugins/tpm
fi

# neovim plugins at the versions pinned in lazy-lock.json
nvim --headless "+Lazy! restore" +qa
