#!/bin/bash

echo "--- STARTUP AT " $(date)
echo ""
# IMPORT NEW USERS LDAP TO GLPI
/usr/bin/php8.5 /var/www/html/bin/console glpi:ldap:synchronize_users  --ldap-server-id=SRV_AUTH_GLPI_ID --ldap-filter="(&(objectClass=user)(!(userAccountControl:1.2.840.113556.1.4.803:=2))(memberOf=xxxxxxxxx))"
/usr/bin/php8.5 /var/www/html/bin/console glpi:ldap:synchronize_users  -u --ldap-server-id=SRV_AUTH_GLPI_ID