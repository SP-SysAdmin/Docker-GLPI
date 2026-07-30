#!/bin/bash
set -e

echo "Démarrage de cron..."
cat /etc/cron.d/*.cron | crontab -

service cron start

echo "Démarrage de PHP-FPM..."
service php${PHP_VERSION}-fpm start 

if [ "$#" -gt 0 ]; then
    exec "$@"
fi

(
while true; do
    inotifywait -r -e modify,create,delete /etc/cron.d
    cat /etc/cron.d/*.cron | crontab -
    service cron reload
done
) &

echo "Démarrage d'Apache..."
exec apachectl -D FOREGROUND