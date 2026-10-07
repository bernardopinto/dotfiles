# Dotfiles

macOS configuration for Zsh, Git, Neovim, and tmux.

## Install

Install Apple’s Command Line Tools if needed, and wait for installation to finish:

```sh
xcode-select --install
```

Clone the repository and run the installer:

```sh
git clone https://github.com/bernardopinto/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
bash install.sh
```

The installer:

- Installs Homebrew if missing, or updates its package metadata.
- Links the Git, Zsh, Neovim, and tmux configurations to this repository, backing up existing files or directories with a `.bak` suffix and replacing existing symlinks.
- Prompts for your Git author name and email when `~/.gitconfig.local` is missing. Existing identity files are preserved.
- Installs packages from [Brewfile](Brewfile), including zsh-autosuggestions and zoxide, and may upgrade installed packages.
- Downloads the tmux plugin manager if missing and restores Neovim plugins to the versions in `nvim/lazy-lock.json`.

If Homebrew is newly installed, follow its printed PATH setup instructions. Open a new terminal after installation to load the Zsh configuration. Start tmux and press `Ctrl-b`, then `I`, to install its plugins.

## Git identity

Your name and email stay in `~/.gitconfig.local`, outside the repository. To change them:

```sh
git config --file ~/.gitconfig.local user.name "Your Name"
git config --file ~/.gitconfig.local user.email "you@example.com"
```

For repositories under `~/Repos/work/`, `~/Repos/work/.gitconfig` can override that identity. Git still records author details in commits; use a noreply email if you want to keep your personal email private.
