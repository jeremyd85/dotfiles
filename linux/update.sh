#! /bin/bash

project_path="$HOME/code/dotfiles"
apt_packages_path="$project_path/linux/apt-packages.txt";
flatpak_packages_path="$project_path/linux/flatpak-packages.txt";

echo "Installing APT packages";
apt-get update -y && apt-get upgrade -y;
cat $apt_packages_path | xargs apt-get install -y;
echo "Installing Flatpak packages";
cat $flatpak_packages_path | xargs flatpak install flathub --system -y;
echo "Installing Snap packages";
echo "Updating: .bashrc";
echo "Updating: .vimrc";