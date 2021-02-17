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
    3 - Install a package
    4 - Reinstall a package
    5 - Remove package

    9 - Clear console        
    0 - Exit

    #------------------END MENU--------------------#

"""

PACKAGE=""
PACKAGE_FOUND=""
INSTALL=""


# ---------------------------------------------   MAIN LOOP   ----------------------------------------------- #

# Welcome message
clear
echo -e "Welcome to the 'apt' automation!"

while [ $OPTION -gt 0 ]
do

    # Printing out the options
    echo -e "$MENU"

    # Collecting input
    printf "    Type an option: "
    read OPTION
    

    case $OPTION in

        # Refresh the available package list
        1)

            echo -e "\n\n\n============  REFRESH PACKAGE LIST  ============"

            # Refreshing
            echo -e "\nUpdating all..."
            sleep 2
            sudo apt -qq update
            echo -e "\nUpdated."
            
            # Showing the list of upgradable packages
            echo -e "\nListing the upgradable packages..."
            sleep 2
            sudo apt list -qq --upgradable

            echo -e "\n==========  END REFRESH PACKAGE LIST  ==========\n\n\n"
            sleep 1
        ;;


        # Upgrade
        2)
            echo -e "\n\n\n==============  UPGRADE PACKAGES  ==============\n"

            # Upgrading quietly with the '-qq' flag
            echo -e "Upgrading..."
            sleep 2
            sudo apt -qq upgrade -y
            echo -e "Upgraded.\n"

            echo -e "============  END UPGRADE PACKAGES  ============\n\n\n"
            sleep 1
        ;;

        # Installing a package
        3)

            echo -e "\n\n\n==============  INSTALL PACKAGES  ==============\n"
            
            # Collecting the name of the package
            printf "\nType the package that you're looking for: "
            read PACKAGE
            
            # Searching for the specific package
            echo -e "\nSearching..."
            sleep 1
            PACKAGE_FOUND="$( sudo apt -qq search ^${PACKAGE}$ )"


            # Verifying if the given package is already installed
            ALREADY_INSTALLED="$( sudo apt list --installed | grep ${PACKAGE} )"


            # Verifying the search result
            if ([ "$PACKAGE_FOUND" != "" ]) && ([ "$ALREADY_INSTALLED" == "" ])
            then

                # The package was found and the script will show some info about
                echo -e "Package ${PACKAGE} found! Listing info about ${PACKAGE}:"
                sleep 2
                sudo apt -qq show $PACKAGE_FOUND


                # Confirming the installation
                printf "\nDo you want to install ${PACKAGE}? [y/n] "
                read INSTALL

                case "$INSTALL" in
                    "y"|"Y")
                        sudo apt -qq install $PACKAGE_FOUND
                    ;;

                    *)
                        echo -e "\nInstallation cancelled."
                    ;;
                esac

            # The package was found, but is already installed
            elif [ "$ALREADY_INSTALLED" != "" ]
            then
                echo -e "\nWARNING: '${PACKAGE}' is already installed.\nPlease verify if you want to reinstall (option 4) the package."

            # The package was not found.
            else
                echo -e "\nPackage not found!"
            fi

            echo -e "\n============  END INSTALL PACKAGES  ============\n\n\n"
            sleep 1
        ;;

        # Reinstall packages
        4)
            echo -e "\n\n\n=============  REINSTALL PACKAGES  =============\n"

            # Collecting the package
            printf "Type the package you want to reinstall: "
            read PACKAGE

            # Verifying if the package is already installed
            if [ "$( apt list --installed | grep ${PACKAGE} )" == "" ]
            then
                echo -e "\nWARNING: '${PACKAGE}' is not installed."
            fi

            sudo apt -qq reinstall "${PACKAGE}" 

            echo -e "\n===========  END REINSTALL PACKAGES  ===========\n\n\n"
        ;;

        # Removing packages
        5)
            echo -e "\n\n\n=============  REMOVING PACKAGES  =============\n"  

            # Collecting the package
            printf "Type the package you want to remove: "
            read PACKAGE
            sleep 1

            # Verifying if the package is installed
            if [ "$( apt list --installed | grep ${PACKAGE} )" == "" ]
            then

                # Printing out that the package given was not found
                echo -e "\nThe package you're looking for is not installed."
                echo -e "Please check the package and try again".

            else

                echo -e "\nRemoving..."
                sleep 1

                # Removing the package and cleaning the unnecessary packages
                sudo apt remove "$PACKAGE"
                sudo apt autoremove
            fi
            
            echo -e "\n\n\n===========  END REMOVING PACKAGES  ===========\n"  
        ;;

        9)
            clear
        ;;

        0)
            exit 0
        ;;

        *)
            echo -e "\nInvalid option!"
        ;;
        

    esac




done