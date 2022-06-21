#! /bin/bash

project_path=`pwd`
apt_packages_path="$project_path/apt-packages.txt";
flatpak_packages_path="$project_path/flatpak-packages.txt";

echo "Installing APT packages";
apt-get update -y && apt-get upgrade -y;
cat $apt_packages_path | xargs apt-get install -y;
echo "Installing Flatpak packages";
cat $flatpak_packages_path | xargs flatpak install flathub --system -y;
echo "Installing Snap packages";
echo "Updating: .bashrc";
echo "Updating: .vimrc";
echo "Cleaning up!"
apt autoremove