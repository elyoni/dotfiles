#!/bin/bash
#options=( 'Install Apps vi apt-get' 'Copy Dotfile To The System' 'Backup dotfile From The System' 'Create Favorite Directory' 'Quit')
#yoni=(1 2 3)
DIR=$(dirname "${BASH_SOURCE[0]}")
DIR=$(cd -P $DIR && pwd)

DIR=$(dirname "${BASH_SOURCE[0]}")
DIR=$(cd -P $DIR && pwd)


options=('Intall at MainPC/Laptop' 'Install at Work' 'Install on RPi ' 'Quit')

print_menu(){
	NORMAL=`echo "\033[m"`
	MENU=`echo "\e[97m"` #White
	NUMBER=`echo "\e[93m"` #Light Yellow
	FGRED=`echo "\033[41m"`
	RED_TEXT=`echo "\033[31m"`
	ENTER_LINE=`echo "\033[33m"`
	echo -e "${MENU}*********************************************${NORMAL}"
	for ((i=1;i<${#options[@]}+1;i++))
	do	
		echo -e "${MENU}${NUMBER} ${i})${MENU} ${options[$i-1]}"
	done
	echo -e "${MENU}*********************************************${NORMAL}"
	echo -e "${ENTER_LINE}Please enter a menu option and enter or ${RED_TEXT}enter to exit. ${NORMAL}"
	read opt
}
print_menu
bash $DIR/install_scripts/generalInstall.sh

if [ ${opt} -eq ${#options[@]} ]
then
    echo "exit"
else
    echo "Run general installation"
	case $opt in
	1)
	bash $DIR/install_scripts/mainPCInstall.sh
	;;
    2)
	bash $DIR/install_scripts/workInstall.sh
	;;
    3)
	bash $DIR/install_scripts/RPiInstall.sh
	;;
	esac
fi
