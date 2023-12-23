#!/bin/bash

apt install figlet -y
mkdir -p /etc/julak
mkdir -p /etc/julak/theme
cat <<EOF>> /etc/julak/theme/red
BG : \E[40;1;41m
TEXT : \033[0;31m
EOF
cat <<EOF>> /etc/julak/theme/green
BG : \E[40;1;42m
TEXT : \033[0;32m
EOF
cat <<EOF>> /etc/julak/theme/yellow
BG : \E[40;1;43m
TEXT : \033[0;33m
EOF
cat <<EOF>> /etc/julak/theme/blue
BG : \E[40;1;44m
TEXT : \033[0;34m
EOF
cat <<EOF>> /etc/julak/theme/magenta
BG : \E[40;1;95m
TEXT : \033[0;95m
EOF
cat <<EOF>> /etc/julak/theme/cyan
BG : \E[40;1;46m
TEXT : \033[0;36m
EOF
cat <<EOF>> /etc/julak/theme/color.conf
magenta
EOF
clear
exit
