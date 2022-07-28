#!/bin/bash

readonly DOTFILES_DIR=$HOME/code/dotfiles
readonly MAC_DIR=$DOTFILES_DIR/mac
readonly BREW_PATH=$MAC_DIR/brew.txt
readonly BREW_CASKS_PATH=$MAC_DIR/brew-casks.txt

set -e

setup_pyenv() {
    default_version="$1"
    pyenv install --skip-existing $default_version
    pyenv global $default_version
}

setup_xcode() {
    if [ ! $(xcode-select -p) ] ; then
        echo "Installing xcode CLI"
        xcode-select --install
    fi
}

setup_brew() {
    if [ ! $(which brew) ] ; then
        echo "Installing Homebrew"
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> /Users/jeremy/.zprofile
        eval "$(/opt/homebrew/bin/brew shellenv)"
    fi
}

update_brew() {
    if [ $(which brew) ] ; then
        brew update -q
        brew upgrade -q
    fi
}

install_packages() {
    cat $BREW_PATH | xargs brew install --quiet
    cat $BREW_CASKS_PATH | xargs brew install --cask --quiet
}

setup_zshrc() {
    if [ ! -L $HOME/.zshrc ] ; then
        echo "Creating symlink for .zshrc"
        ln -snf $MAC_DIR/.zshrc.symlink $HOME/.zshrc
    fi
}

setup_bin() {
    if [ ! -d $HOME/bin ] ; then
        echo "Seting up bin dir"
        mkdir $HOME/bin
    fi
    for file in $(find $DOTFILES_DIR/bin -type f) ; do
        local bin_file="$HOME/bin/$(basename $file)"
        if [ ! -L $bin_file ] && [ -x $file ] ; then
            echo "Creating symbolic link for $(basename $file)"
            ln -snf $file $bin_file
        fi
    done
}

setup_dropbox_movies() {
    if [ -d $HOME/Movies ] ; then
        rm -rf $HOME/Movies
    fi
    if [ ! -d $HOME/Dropbox/Videos ] ; then
        mkdir $HOME/Dropbox/Videos
    fi
    if [ ! -L $HOME/Movies ] ; then
        ln -snf $HOME/Dropbox/Videos $HOME/Movies
    fi
}

link_self() {
    if [ ! -L $HOME/bin/sysinit ] ; then
        ln -snf $MAC_DIR/init.sh $HOME/bin/sysinit
    fi
}

setup_java() {
    local openjdk_file="openjdk.jdk"
    local install_dir="/opt/homebrew/opt/openjdk/libexec"
    local mac_java="/Library/Java/JavaVirtualMachines"
    if [ ! -L "$mac_java/$openjdk_file" ] ; then
        echo "Setting up java"
        sudo ln -snf "$install_dir/$openjdk_file" "$mac_java/$openjdk_file"
    fi
}

setup_python_bin_venv() {
    if [ ! -d "$HOME/bin/venv" ] ; then
        python3 -m venv "$HOME/bin/venv"
    fi
    source "$HOME/bin/venv/bin/activate"
    trap deactivate EXIT
    pip install --upgrade -q psycopg2-binary requests
}

setup() {
    echo "Updating and initializing system..."
    setup_xcode
    setup_brew
    update_brew
    install_packages
    setup_bin
    setup_zshrc
    setup_dropbox_movies
    setup_pyenv "3.10.4"
    setup_java
    link_self
    setup_python_bin_venv
}

setup
