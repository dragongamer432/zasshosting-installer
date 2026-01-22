#!/bin/bash

# ===============================
# ZassHosting / DragonCloud Installer
# ===============================

clear

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# ASCII Banner
echo -e "${RED}                                                                                      "
echo -e "███████╗ █████╗ ███████╗███████╗    ██╗  ██╗ ██████╗ ███████╗████████╗██╗███╗   ██╗ ██████╗ "
echo -e "╚══███╔╝██╔══██╗██╔════╝██╔════╝    ██║  ██║██╔═══██╗██╔════╝╚══██╔══╝██║████╗  ██║██╔════╝ "
echo -e "  ███╔╝ ███████║███████╗███████╗    ███████║██║   ██║███████╗   ██║   ██║██╔██╗ ██║██║  ███╗"
echo -e " ███╔╝  ██╔══██║╚════██║╚════██║    ██╔══██║██║   ██║╚════██║   ██║   ██║██║╚██╗██║██║   ██║"
echo -e "███████╗██║  ██║███████║███████║    ██║  ██║╚██████╔╝███████║   ██║   ██║██║ ╚████║╚██████╔╝"
echo -e "╚══════╝╚═╝  ╚═╝╚══════╝╚══════╝    ╚═╝  ╚═╝ ╚═════╝ ╚══════╝   ╚═╝   ╚═╝╚═╝  ╚═══╝ ╚═════╝ "
echo -e "                                                                                            "
echo -e "                                By Dragon, Zerioak${NC}"                                     
echo -e "============================================================================================" 
# ===============================
# MENU
# ===============================
echo -e "${RED}1) Install Pterodactyl Panel"
echo "2) Install Wings"
echo "3) Install Blueprint"
echo "4) Update Pterodactyl Panel"
echo "5) Degrade Pterodactyl Panel"
echo "6) Database Setup for Pterodactyl"
echo "7) Exit${NC}"
echo -e "==========================================================="
read -p "Choose an option [1-7]: " option

case $option in
    1)
        echo -e "${GREEN}Starting Pterodactyl Installation...${NC}"
        bash <(curl -s https://raw.githubusercontent.com/dragongamer432/zerioak-pterodactyl/main/install.sh)
        echo -e "${GREEN}Completed, Press Enter to Continue!${NC}"
        read
        ;;
    2)
        echo -e "${GREEN}Installing Wings...${NC}"
        bash <(curl -s https://raw.githubusercontent.com/dragongamer432/wings-installer/main/install.sh)
        chmod +x wings.sh
        bash wings.sh
        rm -f wings.sh
        echo -e "${GREEN}Completed, Press Enter to Continue!${NC}"
        read
        ;;
    3)
        echo -e "${GREEN}Installing Blueprint...${NC}"
        if [[ -f blueprint-install.sh ]]; then
            bash blueprint-install.sh
            echo -e "${GREEN}Completed, Press Enter to Continue!${NC}"
        else
            echo -e "${RED}blueprint-install.sh not found!${NC}"
        fi
        read
        ;;
    4)
        echo -e "${GREEN}Updating Pterodactyl Panel...${NC}"
        cd /var/www/pterodactyl || { echo -e "${RED}Panel folder not found!${NC}"; exit 1; }
        git fetch --all
        git reset --hard origin/stable
        composer install --no-dev --optimize-autoloader
        php artisan migrate --force
        php artisan view:clear
        php artisan cache:clear
        echo -e "${GREEN}Completed, Press Enter to Continue!${NC}"
        read
        ;;
    5)
        echo -e "${GREEN}Degrading Pterodactyl Panel...${NC}"
        cd /var/www/pterodactyl || { echo -e "${RED}Panel folder not found!${NC}"; exit 1; }
        git reset --hard HEAD~1
        composer install --no-dev --optimize-autoloader
        php artisan migrate --force
        php artisan view:clear
        php artisan cache:clear
        echo -e "${GREEN}Completed, Press Enter to Continue!${NC}"
        read
        ;;
    6)
        echo -e "${GREEN}Setting up Database for Pterodactyl...${NC}"
        read -p "Enter MySQL root password: " rootpass
        read -p "Enter Pterodactyl database name: " dbname
        read -p "Enter Pterodactyl database user: " dbuser
        read -p "Enter password for this user: " dbpass

        mysql -u root -p"$rootpass" -e "CREATE DATABASE IF NOT EXISTS ${dbname};"
        mysql -u root -p"$rootpass" -e "CREATE USER IF NOT EXISTS '${dbuser}'@'localhost' IDENTIFIED BY '${dbpass}';"
        mysql -u root -p"$rootpass" -e "GRANT ALL PRIVILEGES ON ${dbname}.* TO '${dbuser}'@'localhost';"
        mysql -u root -p"$rootpass" -e "FLUSH PRIVILEGES;"

        echo -e "${GREEN}Completed, Press Enter to Continue!${NC}"
        read
        ;;
    7)
        echo -e "${RED}Exiting...${NC}"
        exit 0
        ;;
    *)
        echo -e "${RED}Invalid option!${NC}"
        read
        ;;
esac
