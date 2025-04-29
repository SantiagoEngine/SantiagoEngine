#!/bin/sh
# SETUP FOR MAC AND LINUX SYSTEMS!!!
#
# REMINDER THAT YOU NEED HAXE INSTALLED PRIOR TO USING THIS
# https://haxe.org/download/version/4.2.5/

# Function to check if a library is installed and show its version
check_install() {
  version=$(haxelib list | grep -i $1 | sed -n 's/.*\(\([0-9]\+\.\)*[0-9]\+\).*/\1/p')
  if [ -z "$version" ]; then
    echo "Installing $1..."
    haxelib install $1
  else
    echo "$1 is already installed. Version: $version"
  fi
}

# Check and install libraries
check_install lime
check_install openfl
check_install flixel
check_install flixel-addons
check_install flixel-ui
check_install flixel-tools
check_install SScript
check_install hxCodec
check_install tjson
check_install flxanimate
check_install linc_luajit
check_install hxdiscord_rpc
check_install hxWindowColorMode

pause
