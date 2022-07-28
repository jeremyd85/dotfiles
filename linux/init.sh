#!/usr/bin/env bash

USER_HOME=$(eval echo ~${SUDO_USER})

readonly DOTFILES_DIR="$USER_HOME/code/dotfiles"
readonly LINUX_DIR="$DOTFILES_DIR/linux"
readonly FLATPAK_PATH="$LINUX_DIR/apps/flatpak.txt"
readonly APT_PATH="$LINUX_DIR/apps/apt.txt"
readonly INITIAL_DIR=`pwd`

cleanup() {
    cd "$INITIAL_DIR"
    pyenv deactivate > /dev/null
}

trap cleanup EXIT

update_apt() {
    if [ $(id -u) -eq 0 ] ; then 
        apt-get dist-upgrade -y -q
        apt-get update -y -q && apt-get upgrade -y -q
        cat "$APT_PATH" | xargs apt-get install -y -q
        apt-get autoremove -y -q
        apt-get clean -y -q
    else
        echo "Skipping update to apt software (try to run as root)"
    fi
}

init_flatpak() {
    if [ ! $(which flatpak) ] ; then
        apt-get install -y -q flatpak
    fi
    flatpak remote-add --system --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
    cat "$FLATPAK_PATH" | xargs flatpak install flathub --system -y --or-update --noninteractive
}

install_vscode() {
    if [ ! $(which code) ] ; then
        wget -q https://packages.microsoft.com/keys/microsoft.asc -O- | sudo apt-key add –
        add-apt-repository "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" -y -q
        apt-get update -y -q
        apt-get install -y -q code
    fi
}

setup_bin() {
    if [ ! -d $USER_HOME/bin ] ; then
        echo "Seting up bin dir"
        mkdir $USER_HOME/bin
    fi
    for file in $(find $DOTFILES_DIR/bin -type f) ; do
        local bin_file="$USER_HOME/bin/$(basename $file)"
        if [ ! -L $bin_file ] && [ -x $file ] ; then
            echo "Creating symbolic link for $(basename $file)"
            ln -snf $file $bin_file
        fi
    done
}

link_self() {
    if [ ! -L /usr/local/bin/sysinit ] ; then
        if [ $(id -u) -eq 0 ] ; then
            ln -snf $LINUX_DIR/init.sh /usr/local/bin/sysinit
        else
            echo "Skipping symlink to self (try to run as root)"
        fi
    fi
}

setup_python() {
    local py_version="3.10.5"
    if [ ! -d "$USER_HOME/.pyenv" ] ; then
        git clone --quiet https://github.com/pyenv/pyenv.git "$USER_HOME/.pyenv"
    fi
    export PYENV_ROOT="$USER_HOME/.pyenv"
    export PATH="$PATH:$PYENV_ROOT/bin"
    if command -v pyenv 1>/dev/null 2>&1 ; then
        eval "$(pyenv init -)"
    else
        echo "pyenv installation failed!"
    fi
    if [ ! -d "$(pyenv root)/plugins/pyenv-virtualenv" ] ; then
        git clone --quiet https://github.com/pyenv/pyenv-virtualenv.git $(pyenv root)/plugins/pyenv-virtualenv
        eval "$(pyenv virtualenv-init -)"
    fi
    if [ -d "$(pyenv root)/plugins/pyenv-virtualenv" ] ; then
        eval "$(pyenv virtualenv-init -)"
    fi
    if [ $(which pyenv) ]; then
        pyenv install "$py_version" --skip-existing
        pyenv global "$py_version"
        if [ $(which pip) ] && [ -d "$(pyenv root)/plugins/pyenv-virtualenv" ] ; then
            pyenv virtualenv -f "$py_version" venvbin
            if [ ! -L "$USER_HOME/bin/venv" ]; then
                if [ -d "$(pyenv root)/versions/venvbin" ] ; then
                    ln -snf "$(pyenv root)/versions/venvbin" "$USER_HOME/bin/venv"
                fi
            fi
            pyenv activate venvbin
            python3 -m pip install --upgrade pip --quiet
            pip3 install --upgrade pip-tools > /dev/null
            pip-compile "$DOTFILES_DIR/py-requirements.in" --upgrade --quiet
            pip-sync "$DOTFILES_DIR/py-requirements.txt" --quiet
        fi
    fi
}

setup_bashrc() {
    if [ ! -L $USER_HOME/.bashrc ] ; then
        echo "Creating symlink for .bashrc"
        ln -snf $LINUX_DIR/.bashrc $USER_HOME/.bashrc
    fi
}


setup() {
    setup_bashrc
    update_apt
    init_flatpak
    setup_python
    setup_bin
    install_vscode
    link_self
}
setup
