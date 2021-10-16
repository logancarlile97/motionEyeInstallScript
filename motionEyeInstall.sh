#!/bin/bash

read -p "This script will install MotionEye Are you sure? " -n 1 -r
echo    # (optional) move to a new line
if [[ $REPLY =~ ^[Yy]$ ]]
then
    if [ "$EUID" -ne 0 ]
    then echo "Please run as root!"
        exit
    fi
    
    echo
    echo
    echo "---------------------------------------------"
    echo "Checking for updates"
    echo "---------------------------------------------"
    echo
    
    apt update
    
    echo
    echo
    echo "---------------------------------------------"
    echo "Installing updates"
    echo "---------------------------------------------"
    echo
    
    apt upgrade -y
    
    echo
    echo
    echo "---------------------------------------------"
    echo "Installing ssh, curl, motion, ffmpeg, and v4l-utils"
    echo "---------------------------------------------"
    echo
    
    apt install ssh curl motion ffmpeg v4l-utils -y
    
    echo
    echo
    echo "---------------------------------------------"
    echo "Installing python 2.7 and pip2"
    echo "---------------------------------------------"
    echo
    
    apt install python2 -y
    
    curl https://bootstrap.pypa.io/pip/2.7/get-pip.py --output get-pip.py
    
    python2 get-pip.py
    
    echo
    echo
    echo "---------------------------------------------"
    echo "Installing all prerequisites"
    echo "---------------------------------------------"
    echo
    
    apt install libffi-dev libzbar-dev libzbar0 -y
    
    apt install python2-dev libssl-dev libcurl4-openssl-dev libjpeg-dev -y
    
    apt install python-pil -y
    
    echo
    echo
    echo "---------------------------------------------"
    echo "Installing MotionEye"
    echo "---------------------------------------------"
    echo
    
    pip2 install motioneye
    
    echo
    echo
    echo "---------------------------------------------"
    echo "Preparing the configuration directory"
    echo "---------------------------------------------"
    echo
    
    mkdir -p /etc/motioneye
    cp /usr/local/share/motioneye/extra/motioneye.conf.sample /etc/motioneye/motioneye.conf
    
    echo
    echo
    echo "---------------------------------------------"
    echo "Preparing the media directory"
    echo "---------------------------------------------"
    echo
    
    mkdir -p /var/lib/motioneye
    
    echo
    echo
    echo "------------------------------------------------------"
    echo "Make a MotionEye service to make it run as a service"
    echo "------------------------------------------------------"
    echo
    
    cp /usr/local/share/motioneye/extra/motioneye.systemd-unit-local /etc/systemd/system/motioneye.service
    systemctl daemon-reload
    systemctl enable motioneye
    
    read -p "You must reboot to finish the install. Would you like to reboot now? [y/N] " -n 1 -r
    echo    # (optional) move to a new line
    if [[ $REPLY =~ ^[Yy]$ ]]
    then
        shutdown -r now
    fi
    
    echo
    echo
    echo "---------------------------------------------"
    echo "You chose to reboot later, MotionEye will not work until you reboot."
    echo "---------------------------------------------"
    echo

    exit
    
else
    echo
    echo
    echo "---------------------------------------------"
    echo "Exiting script"
    exit
fi

