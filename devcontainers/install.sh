#!/bin/bash

# Detect Linux distro
distro=$(cat /etc/os-release | grep -e '^ID=' | cut -d '=' -f2)

case $distro in
    "debian")
        ./debian/install.sh
    ;;

    *)
        echo "Auto-config not yet available for \"$distro\""
    ;;
esac    
