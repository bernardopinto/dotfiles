
## Setup bootstrap with install script

1. Install Apple's Command Line Tools, which are prerequisites for Git and Homebrew.

```zsh
xcode-select --install
```

2. Clone repo into new hidden directory.

```zsh
mkdir ~/.dotfiles && cd ~/.dotfiles
```

```zsh
# Use SSH (if set up)...
git clone git@github.com:bernardopinto/dotfiles.git .

# ...or use HTTPS and switch remotes later.
git clone https://github.com/bernardopinto/dotfiles.git .
```

3. Run the install script

```zsh
cd ~/.dotfiles/install.sh
chmod 777 ./install.sh
./install.sh
```

## Private Git identity

The shared `.gitconfig` loads your personal identity from `~/.gitconfig.local`,
which stays outside this repository. After installing the dotfiles, configure it:

```zsh
git config --file ~/.gitconfig.local user.name "Your Name"
git config --file ~/.gitconfig.local user.email "you@example.com"
```

The existing configuration in `~/Repos/work/.gitconfig` overrides this identity
for work repositories. Git requires an explicitly configured identity before
committing, so it won't guess your name or email from your system account.
Commit author names and emails are still recorded in Git history; use a private
or noreply email if you don't want your personal email in published commits.
Removing identity settings does not erase them from earlier repository history.

## Steps to bootstrap a new Mac

1. Install Apple's Command Line Tools, which are prerequisites for Git and Homebrew.

```zsh
xcode-select --install
```


2. Clone repo into new hidden directory.

```zsh
mkdir ~/.dotfiles && cd ~/.dotfiles
```

```zsh
# Use SSH (if set up)...
git clone git@github.com:bernardopinto/dotfiles.git .

# ...or use HTTPS and switch remotes later.
git clone https://github.com/bernardopinto/dotfiles.git .
```


3. Create symlinks in the Home directory to the real files in the repo.

```zsh
# There are better and less manual ways to do this;
# investigate install scripts and bootstrapping tools.

ln -s ~/.dotfiles/.zshrc ~/.zshrc
ln -s ~/.dotfiles/.gitconfig ~/.gitconfig
ln -sfn ~/.dotfiles/nvim ~/.config/nvim
mkdir -p ~/.config/tmux
ln -s ~/.dotfiles/tmux/tmux.conf ~/.config/tmux/tmux.conf
```


4. Install Homebrew, followed by the software listed in the Brewfile.

```zsh
# These could also be in an install script.

# Install Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Then pass in the Brewfile location...
brew bundle dump --file ~/.dotfiles/Brewfile

# ...or move to the directory first.
cd ~/.dotfiles && brew bundle
```


5. Install the tmux and Neovim plugins.

```zsh
git clone https://github.com/tmux-plugins/tpm ~/.config/tmux/plugins/tpm
nvim --headless "+Lazy! restore" +qa
```

Then start tmux and press `prefix + I` to install the tmux plugins. Mason installs the language servers the first time Neovim starts.
