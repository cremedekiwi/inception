#!/bin/bash

sleep 10

# Create the PHP run directory if it doesn't exist
if [ ! -d /run/php ]; then
    mkdir -p /run/php
fi

# Wait for MariaDB to be ready with better retry logic
echo "Waiting for MariaDB..."
max_attempts=30
attempt=0
while [ $attempt -lt $max_attempts ]
do
    if mysql -h mariadb -u "$SQL_USER" -p"$SQL_PASSWORD" -e "SELECT 1;" >/dev/null 2>&1; then
        echo "MariaDB is up and running!"
        break
    fi
    attempt=$((attempt+1))
    echo "Attempt $attempt/$max_attempts: MariaDB not ready yet, waiting..."
    sleep 5
done

if [ $attempt -eq $max_attempts ]; then
    echo "Failed to connect to MariaDB after $max_attempts attempts"
    exit 1
fi

# Remove empty wp-config.php if it exists but is empty
if [ -f /var/www/wordpress/wp-config.php ] && [ ! -s /var/www/wordpress/wp-config.php ]; then
    rm -f /var/www/wordpress/wp-config.php
fi

# Configure WordPress if wp-config.php doesn't exist
if [ ! -f /var/www/wordpress/wp-config.php ]; then
    cd /var/www/wordpress
    wp core config  --dbhost=mariadb:3306 \
                    --dbname="$SQL_DATABASE" \
                    --dbuser="$SQL_USER" \
                    --dbpass="$SQL_PASSWORD" \
                    --allow-root

    wp core install --url="$DOMAIN_NAME" \
                    --title="$WP_TITLE" \
                    --admin_user="$WP_ADMIN_USER" \
                    --admin_password="$WP_ADMIN_PASSWORD" \
                    --admin_email="$WP_ADMIN_EMAIL" \
                    --allow-root

	wp user create "$WP_USER" "$WP_USER_EMAIL"  --user_pass="$WP_USER_PASSWORD" \
                                                --role="$WP_USER_ROLE" \
                                                --allow-root

    # Set proper permissions
    chown -R www-data:www-data /var/www/wordpress
    chmod -R 755 /var/www/wordpress
fi

# Start PHP-FPM
/usr/sbin/php-fpm7.3 -F
