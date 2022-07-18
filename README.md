
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
