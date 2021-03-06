#!/bin/bash
# A script to retrieve OATH-TOTP codes from a Yubikey using dmenu or a dmenu-compatible menu.
# Depends on yubikey-manager.

menu="dmenu"
prompt="yubioath"
nkeys=$(ykman list | wc -l) 

while getopts "m:p:" options; do
	case "${options}" in
		"m")
			menu=$OPTARG;;
		"p")
			prompt=$OPTARG;;
	esac
done
shift "$((OPTIND-1))"

if [ $nkeys == 0 ]
then
	echo "No YubiKey connected!" | $menu -p $prompt
	exit 1
else
	apps=$(ykman oath list | cut -d ':' -f 1)
	selected=$(echo "$apps" | $menu -p $prompt)
	ykman oath code -s $selected 
fi

