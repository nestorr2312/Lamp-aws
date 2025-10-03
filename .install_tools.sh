#!/bin/bash
# Archivo: scripts/install_tools.sh

source .env
set -e

sudo apt install goaccess -y
echo "Uso de GoAccess: goaccess -f ${APACHE_LOGS_DIR}/access.log"

ADMINER_URL="https://github.com/vrana/adminer/releases/download/v${ADMINER_VERSION}/adminer-${ADMINER_VERSION}.php"
sudo wget -O ${WWW_DIR}/adminer.php "${ADMINER_URL}"
echo "Adminer instalado en: http://TU_IP/adminer.php"


# Respuestas automáticas para la instalación de phpMyAdmin (sin interacción)
echo "phpmyadmin phpmyadmin/dbconfig-install boolean true" | sudo debconf-set-selections
echo "phpmyadmin phpmyadmin/app-password-confirm password ${DB_PASS}" | sudo debconf-set-selections
echo "phpmyadmin phpmyadmin/mysql/admin-pass password ${DB_ROOT_PASS}" | sudo debconf-set-selections
echo "phpmyadmin phpmyadmin/mysql/app-pass password ${DB_PASS}" | sudo debconf-set-selections
echo "phpmyadmin phpmyadmin/reconfigure-webserver multiselect apache2" | sudo debconf-set-selections

# Instalación de phpMyAdmin.
sudo apt install phpmyadmin -y

# Creación de enlace simbólico.
if [ ! -L ${WWW_DIR}/phpmyadmin ]; then
    sudo ln -s /usr/share/phpmyadmin ${WWW_DIR}/phpmyadmin
fi
echo "phpMyAdmin instalado en: http://TU_IP/phpmyadmin"

sudo systemctl restart apache2
