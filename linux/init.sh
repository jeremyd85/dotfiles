#!/usr/bin/env bash

readonly DOTFILES_DIR="$HOME/code/dotfiles"
readonly LINUX_DIR="$DOTFILES_DIR/linux"
readonly FLATPAK_PATH="$LINUX_DIR/apps/flatpak.txt"
readonly APT_PATH="$LINUX_DIR/apps/apt.txt"

update_apt() {
    apt-get update -y && apt-get upgrade -y;
    cat $APT_PATH | xargs apt-get install -y;
    apt autoremove
}

init_flatpak() {
    if [ $(which flatpak) ] ; then
        apt-get install flatpak
    fi
    flatpak remote-add --system --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
    cat $FLATPAK_PATH | xargs flatpak install flathub --system -y;
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
            ln -shf $file $bin_file
        fi
    done
}

link_self() {
    if [ ! -L $HOME/bin/sysinit ] ; then
        ln -shf $LINUX_DIR/init.sh $HOME/bin/sysinit
    fi
}

setup_python() {
    local py_version="3.10.5"
    if [ ! -d "$HOME/.pyenv" ] ; then
        git clone https://github.com/pyenv/pyenv.git "$HOME/.pyenv"
        export PYENV_ROOT="$HOME/.pyenv"
        export PATH="$PATH:$PYENV_ROOT/bin"
        if command -v pyenv 1>/dev/null 2>&1 ; then
            eval "$(pyenv init -)"
        else
            echo "pyenv installation failed!"
        fi
    fi
    if [ $(which pyenv) ] ; then
        pyenv update
        pyenv install "$py_version" --skip-existing
        pyenv global "$py_version"
    fi
    # if [ ! -d "$HOME/bin/venv" ] ; then
    #     python3 -m venv "$HOME/bin/venv"
    # fi
    # source "$HOME/bin/venv/bin/activate"
    # trap deactivate EXIT
    # pip install --upgrade pip-tools
    # pip-compile "$DOTFILES_DIR/py-requirements.in" --upgrade
    # pip-sync "$DOTFILES_DIR/py-requirements.txt"
}

setup_bashrc() {
    if [ ! -L $HOME/.bashrc ] ; then
        echo "Creating symlink for .bashrc"
        ln -shf $LINUX_DIR/.bashrc $HOME/.bashrc
    fi
}


setup() {
    setup_bashrc
    update_apt
    init_flatpak
    setup_python
    link_self
}
setup