#!/bin/bash
set -e

echo "Démarrage de cron..."
service cron start

echo "Démarrage de PHP-FPM..."
php-fpm -D

echo "Démarrage d'Apache..."
exec apachectl -D FOREGROUND