#!/bin/bash

ADMIN_PASSWORD=$(cat /run/secrets/ADMIN_PASSWORD)
SQL_PASSWORD=$(cat /run/secrets/SQL_PASSWORD)

sleep 5

cd /var/www/html
chown -R www-data:www-data /var/www/html 
mkdir -p /run/php
if [ ! -f /var/www/html/wp-config.php ]; then 
	echo "Telechargement de Wordpress..."
	wp core download --allow-root --path='/var/www/html'
	echo "Configuration de la connexion a la DB.."
	wp config create \
		--dbname=${SQL_DATABASE} \
		--dbuser=${SQL_USER} \
		--dbpass=${SQL_PASSWORD} \
		--dbhost=mariadb:3306 \
		--allow-root
	echo "Installation de Wordpress (admin).."
	wp core install \
		--url=${DOMAIN_NAME} \
		--title=${SITE_TITLE} \
		--admin_user=${ADMIN_USER} \
		--admin_password=${ADMIN_PASSWORD} \
		--admin_email=${ADMIN_EMAIL} \
		--allow-root

	wp user create \
		${USER_NAME} ${USER_EMAIL} \
		--role=author \
		--user_pass=${ADMIN_PASSWORD} \
		--allow-root
	wp theme install astra --activate --allow-root
else
	echo "Wordpress est deja configure."
fi
exec php-fpm7.4 -F

