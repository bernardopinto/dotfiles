# Initialize native Zsh completion.
autoload -Uz compinit
compinit

# User configuration

# AUTOSUGGESTIONS
source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# GIT aliases
alias g='git'                          # Shorten git to g
alias ga='git add'                     # Add files to staging
alias gaa='git add .'                  # Add all files to staging
alias gc='git commit'                  # Commit staged changes
alias gcm='git commit -m'              # Commit with a message
alias gcam='git commit -a -m'	       # Commit all tracked changes with a message
alias gco='git checkout'               # Switch branches or restore files
alias gd='git diff'                    # Show changes between commits, commit and working tree, etc.
alias gst='git status'                 # Show the working tree status
alias gl='git log --oneline --graph --decorate --all' # Pretty git log
alias gld="git log --format='%C(yellow)%h%C(reset) %C(bold blue)%an <%ae>%C(reset) %C(green)(%ar)%C(reset)%n%C(bold)%s%C(reset)%n%w(0,4,4)%b'" # Detailed log with authors, emails and descriptions
alias gb='git branch'                  # List, create, or delete branches
alias gbd='git branch -d'              # Delete a branch
alias gpr='git pull --rebase'          # Pull with rebase
alias gpl='git pull'                   # Pull the latest changes
alias gps='git push'                   # Push changes to the remote repository
alias gpf='git push --force-with-lease' # Safe force push
alias gm='git merge'		       # Simple git merge 
alias gr='git rebase'                  # Rebase commits on top of another base commit
alias grc='git rebase --continue'      # Continue a rebase after resolving conflicts
alias grs='git rebase --skip'          # Skip a commit in the rebase process
alias gsta='git stash'                 # Stash changes
alias gstp='git stash pop'             # Apply and remove the latest stash
alias gsts='git stash show --text'     # Show the contents of the latest stash
alias greset='git reset'               # Reset current HEAD to the specified state
alias grhh='git reset --hard HEAD'     # Hard reset to the latest commit
alias gt='git tag'                     # List, create, or delete tags
alias gcp='git cherry-pick'            # Apply the changes introduced by some existing commits
alias glg='git log --oneline --graph --decorate' # Pretty log graph with details

# COMMAND ALIASES
alias ll="ls -alF"


eval "$(zoxide init --cmd cd zsh)"
