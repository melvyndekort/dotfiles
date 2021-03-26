#!/bin/sh

set -e

yay -Syu --sudoloop --answerclean A --nodiffmenu --noupgrademenu
pip freeze --user | xargs pip uninstall -y
pip install --upgrade --user -r $HOME/src/arch-setup/pkglist-pip.txt

