#!/bin/bash

set -e

find /var/lib/mysql -name "*.pid" -delete

rm -rf /run/mysqld/*

mkdir -p /run/mysqld

chown -R mysql:mysql /run/mysqld

SQL_ROOT_PASSWORD=$(cat /run/secrets/SQL_ROOT_PASSWORD)
SQL_PASSWORD=$(cat /run/secrets/SQL_PASSWORD)

if [ ! -d "/var/lib/mysql/${SQL_DATABASE}" ]; then
	
	#start mariadb
	service mariadb start
	#wait until mariadb docket is ready
	while ! mysqladmin ping -hlocalhost --silent; do
		sleep 1
	done

	mysql  -e "CREATE DATABASE IF NOT EXISTS \`${SQL_DATABASE}\`;"

	mysql  -e "CREATE USER IF NOT EXISTS \`${SQL_USER}\`@'%' IDENTIFIED BY '${SQL_PASSWORD}';"

	mysql  -e "GRANT ALL PRIVILEGES ON \`${SQL_DATABASE}\`.* TO \`${SQL_USER}\`@'%';"

	mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '${SQL_ROOT_PASSWORD}';"

	mysql -u root -p${SQL_ROOT_PASSWORD} -e "FLUSH PRIVILEGES;"

	mysqladmin -u root -p${SQL_ROOT_PASSWORD} shutdown
fi


echo "Mariadb is ready"

exec mysqld 
