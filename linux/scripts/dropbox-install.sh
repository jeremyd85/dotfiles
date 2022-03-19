#!/usr/bin/env bash

daemon_path="$HOME/.dropbox-dist/dropboxd"

cd ~ && wget -O - "https://www.dropbox.com/download?plat=lnx.x86" | tar xzf -

if [[ -d "$HOME/.dropbox-dist" ]] ; then
  if [[ -f "$HOME/.dropbox-dist/dropboxd" && -x "$HOME/.dropbox-dist/dropboxd" ]] ; then
    "$HOME/.dropbox-dist/dropboxd"
  fi
fi

