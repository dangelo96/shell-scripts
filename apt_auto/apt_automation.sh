#!/bin/bash 
#
#   apt_automation.sh
#       Description:        The Swiss knife of apt automation. Update, upgrade, search for packages etc
#       Author:             Daniel D'Angelo
#       GitHub:             https://github.com/dangelo96
#       Date:               Feb 14, 2021
#
#
#
############################################    DESCRIPTION    ###############################################
#                                                                                                            #
#   This script will make the 'apt' operations easier to do. You'll able to:                                 #
#       * Update the available package list                                                                  #
#       * Install, upgrade and remove packages                                                               #
#       * Upgrade the system                                                                                 #
#       * Search for packages (already installed or not)                                                     #
#                                                                                                            #
#   By the way, the script works in choices through a simple menu. Example:                                  #
#                                                                                                            #
##############################################################################################################
#
#
##############################################    HISTORY    #################################################
#                                                                                                            #
#       v1.0    2021-02-14, Daniel D'Angelo:                                                                 #
#           - added the menu structure                                                                       #
#                                                                                                            #
#                                                                                                            #
##############################################################################################################



# ----------------------------------------------   SCRIPT   ------------------------------------------------ #
# ----------------------------------------   VARIABLE DECLARATION   ---------------------------------------- #

# Script version
VERSION="1.0"

# Loop Flag. The loop ends with "exit" input.
OPTION=1;

# Menu info
MENU="""
    #--------------------MENU----------------------#
        
    1 - Refresh the available package list
    2 - Upgrade all available programs
    3 - Install the package
            
    0 - Exit

    #------------------END MENU--------------------#
"""



# ---------------------------------------------   MAIN LOOP   ----------------------------------------------- #

# Welcome message
clear
echo -e "Welcome to the 'apt' automation!\n"

while [ $OPTION -gt 0 ]
do

    # Printing out the options
    echo -e "$MENU"

    # Collecting input
    printf "\nType an option: "
    read OPTION
    

    case $OPTION in

        # Refresh the available package list
        1)
            # Refreshing
            echo -e "\nUpgrading all..."
            sleep 2
            sudo apt -qq update
            echo -e "\n\nUpdated."
            
            # Showing the list of upgradable packages
            echo -e "\nListing the upgradable packages..."
            sleep 2
            sudo apt list -qq --upgradable
        ;;

        # Upgrade
        2)
            # Upgrading quietly with the '-qq' flag
            echo -e "\nUpgrading..."
            sleep 2
            sudo apt -qq upgrade -y
            echo -e "\nUpgraded.\n\n"
        ;;

    esac




done