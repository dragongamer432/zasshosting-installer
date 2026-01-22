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
echo -e "${GREEN}                                                  "
echo -e " ______                 _   _           _   _             "
echo -e "|___  /                | | | |         | | (_)            "
echo -e "  / /   __ _ ___ ___   | |_| | ___  ___| |_ _ _ __   __ _ "
echo -e " / /   / _` / __/ __|  |  _  |/ _ \/ __| __| | '_ \ / _` |"
echo -e "/ /__ | (_| \__ \__ \  | | | | (_) \__ \ |_| | | | | (_| |"
echo -e "\_____/\__,_|___/___/  \_| |_/\___/|___/\__|_|_| |_|\__, |"
echo -e "                                                     __/ |"
echo -e "                                                    |___/ "
echo -e "                  By Dragon, Zerioak${NC}"
echo -e "==========================================================" 

# Menu
echo -e "${YELLOW}1) Install Pterodactyl Panel"
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
        echo -e "${GREEN}Installing Pterodactyl Panel...${NC}"
        curl -sSL https://get.pterodactyl.io/panel.sh | bash
        echo -e "${GREEN}Completed, Press Enter to Continue!${NC}"
        read
        ;;
    2)
        echo -e "${GREEN}Installing Wings...${NC}"
        curl -sSL https://get.pterodactyl.io/wings.sh | bash
        echo -e "${GREEN}Completed, Press Enter to Continue!${NC}"
        read
        ;;
    3)
        echo -e "${GREEN}Installing Blueprint...${NC}"
        bash blueprint-install.sh
        echo -e "${GREEN}Completed, Press Enter to Continue!${NC}"
        read
        ;;
    4)
        echo -e "${GREEN}Updating Pterodactyl Panel...${NC}"
        cd /var/www/pterodactyl || { echo "Panel folder not found!"; exit 1; }
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
        cd /var/www/pterodactyl || { echo "Panel folder not found!"; exit 1; }
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

        mysql -u root -p"$rootpass" -e "CREATE DATABASE ${dbname};"
        mysql -u root -p"$rootpass" -e "CREATE USER '${dbuser}'@'localhost' IDENTIFIED BY '${dbpass}';"
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
