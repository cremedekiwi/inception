#!/bin/bash

# Start MySQL service
service mysql start
sleep 5

# Create database
mysql -e "CREATE DATABASE IF NOT EXISTS \`${SQL_DATABASE}\`;"

# Create user with proper hostname
mysql -e "CREATE USER IF NOT EXISTS \`${SQL_USER}\`@'%' IDENTIFIED BY '${SQL_PASSWORD}';"

# Grant privileges
mysql -e "GRANT ALL PRIVILEGES ON \`${SQL_DATABASE}\`.* TO \`${SQL_USER}\`@'%';"

# Set root password
mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '${SQL_ROOT_PASSWORD}';"
mysql -e "FLUSH PRIVILEGES;"

# Now shutdown using the newly set root password
mysqladmin -u root -p"${SQL_ROOT_PASSWORD}" shutdown

# Restart MySQL in safe mode
exec mysqld_safe
