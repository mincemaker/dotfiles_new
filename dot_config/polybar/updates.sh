#!/bin/bash

echo
#echo 'updates.sh: "yay -Syu"'
echo 'updates.sh: "topgrade --only system"'
echo
#yay -Syu
topgrade --only system

echo
bash ~/.config/polybar/checkupdates.sh

read -p "Press enter to close this window..."
