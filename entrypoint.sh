#!/bin/bash
set -e

echo "Démarrage de cron..."
service cron start

echo "Démarrage de PHP-FPM..."
service php8.5-fpm start 

if [ "$#" -gt 0 ]; then
    exec "$@"
fi

echo "Démarrage d'Apache..."
exec apachectl -D FOREGROUND