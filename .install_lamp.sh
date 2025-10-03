#!/bin/bash
# Archivo: scripts/install_lamp.sh

source .env
set -e

sudo apt update -y
sudo apt upgrade -y

sudo apt install apache2 -y
sudo systemctl enable apache2
sudo systemctl start apache2

sudo apt install php libapache2-mod-php php-mysql php-cli php-curl php-json php-mbstring php-xml php-zip -y

sudo apt install mysql-server -y
sudo systemctl enable mysql
sudo systemctl start mysql

SQL_COMMANDS=$(cat <<EOF
ALTER USER 'root'@'localhost' IDENTIFIED BY '${DB_ROOT_PASS}';
CREATE DATABASE IF NOT EXISTS ${DB_NAME} CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE USER IF NOT EXISTS '${DB_USER}'@'localhost' IDENTIFIED BY '${DB_PASS}';
GRANT ALL PRIVILEGES ON ${DB_NAME}.* TO '${DB_USER}'@'localhost';
FLUSH PRIVILEGES;
EOF
)
# Ejecuta los comandos SQL
sudo mysql -u root -p"${DB_ROOT_PASS}" -e "$SQL_COMMANDS"

sudo a2enmod rewrite
sudo systemctl restart apache2
