#!/bin/bash

dotfiles_dir=$HOME/code/dotfiles
mac_dir=$dotfiles_dir/mac
brew_path=$mac_dir/brew.txt
brew_casks_path=$mac_dir/brew-casks.txt

/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
cat $brew_path | xargs brew install
cat $brew_casks_path | xargs brew install --cask