FROM debian:buster

RUN apt update -y
RUN apt upgrade -y
RUN apt-get install mariadb-server -y

# Copy configuration file
COPY conf/50-server.cnf	/etc/mysql/mariadb.conf.d/50-server.cnf

# Copy and set execution permissions for the database initialization script
COPY ./tools/mariadb-config.sh /mariadb-config.sh
RUN chmod +x /mariadb-config.sh

# Set the script as entrypoint
ENTRYPOINT ["/mariadb-config.sh"]
