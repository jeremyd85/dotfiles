#!/usr/bin/env bash

echo "Before shell reset"
USER_HOME=$(eval echo ~${SUDO_USER})
echo ${USER_HOME}
echo "After shell reset"