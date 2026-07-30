#!/bin/bash

# IMPORT NEW USERS LDAP TO GLPI
runuser -u web -- php /var/www/html/bin/console glpi:ldap:synchronize_users -q --ldap-server-id=2 --ldap-filter="(&(objectClass=user)(!(userAccountControl:1.2.840.113556.1.4.803:=2))(memberOf=xxxxxxxxxx))"


# UPDATE USER EXISTING
runuser -u web -- php /var/www/html/bin/console glpi:ldap:synchronize_users -q -u --ldap-server-id=2