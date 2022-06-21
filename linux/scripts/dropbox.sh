#!/bin/bash

dropbox_base="$HOME/Dropbox"
dropbox_paths=("Documents", "Videos", "Pictures")

is_empty() {
    [[]];
}

for path in ${dropbox_paths[@]}; do
    actual_path="$dropbox_base/$path"
    symlink_path="$HOME/$path"
    if [[ -d "$full_path" ]]; then
        if [[ -L "$full_path" ]]; then
            rmdir "$full_path" || 
        fi
    fi
    if [[ ! -d "$actual_path" ]]; then
        mkdir -p "$actual_path"
    fi
    if [[ ! -d "$symlink_path" ]]; then
        ln -s "$actual_path" "$actual_path"
    else
        echo "$symlink_path already exists. Remove folder before running again."
    fi
done