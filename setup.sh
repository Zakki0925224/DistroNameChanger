#!/usr/bin/env bash

view="[$0]:"

if [ ! $UID = 0 ]; then
    echo "${view} Error. Please run with sudo."
    exit 0

fi

if [ $1 = "install" ]; then
    cp ./DistroNameChanger /usr/bin/
    chmod 755 /usr/bin/DistroNameChanger
    echo "${view} The installation is complete."

elif [ $1 = "uninstall" ]; then
    rm /usr/bin/DistroNameChanger
    echo "${view} The uninstall is complete."

elif [ $1 = "check" ]; then
    if [ -e "/usr/bin/DistroNameChanger" ]; then
        echo "${view} DistroNameChanger is installed."
    
    else
        echo "${view} DistroNameChanger is not installed."
    
    fi

else
    echo "${view} Error. The command \"${1}\" cannot be recognized."

fi