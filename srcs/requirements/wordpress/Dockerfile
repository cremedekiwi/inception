FROM debian:buster

RUN apt update -y
RUN apt upgrade -y

# Install required packages
RUN apt-get -y install wget
RUN apt-get install -y php7.3 php-fpm php-mysql mariadb-client

# Download and extract WordPress
RUN wget https://fr.wordpress.org/wordpress-6.0-fr_FR.tar.gz -P /var/www
RUN cd /var/www && tar -xzf wordpress-6.0-fr_FR.tar.gz && rm wordpress-6.0-fr_FR.tar.gz

# Set permissions
RUN chown -R root:root /var/www/wordpress

# Copy PHP configuration file
RUN mkdir -p /etc/php/7.3/fpm/pool.d/
COPY conf/www.conf /etc/php/7.3/fpm/pool.d/www.conf

# Install WP-CLI
RUN wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
RUN chmod +x wp-cli.phar
RUN mv wp-cli.phar /usr/local/bin/wp

# Copy and set permissions for the WordPress configuration script
COPY ./tools/wp-config.sh /wp-config.sh
RUN chmod +x /wp-config.sh

# Set the script as entrypoint
ENTRYPOINT ["/wp-config.sh"]
