# inception

## Overview

Inception is a system administration project that involves virtualizing multiple Docker containers to create a small infrastructure. The project implements a complete web server setup including Nginx, WordPress, and MariaDB, all running in separate containers and managed with Docker Compose.

## Project Objectives

- Learn containerization with Docker
- Set up a multi-container infrastructure
- Configure services to work together within isolated environments
- Implement data persistence using volumes
- Create a secure and efficient web hosting environment

## Architecture

The infrastructure consists of three main services, each in its own container:

1. **Nginx**: Web server
2. **WordPress**: PHP-based content management system
3. **MariaDB**: Database server

All containers are built using custom Dockerfiles and are managed through Docker Compose.

## Requirements

- Docker Engine
- Docker Compose
- Make

## Environment Variables

The project uses a `.env` file to store configuration variables. These include:

- **Domain Name**: Used for the server name in Nginx
- **Database Settings**: Database name, user credentials
- **WordPress Settings**: Admin and user credentials, site title

## Container Details

### Nginx

- Uses Debian as base image
- Handles HTTP requests and routes them to the WordPress container
- SSL enabled with a self-signed certificate
- Only port 443 (HTTPS) is exposed

### WordPress

- Uses Debian as base image
- Runs WordPress using PHP-FPM
- Communicates with the Nginx container through a network
- Connects to the MariaDB container for database operations
- Includes a setup script for initial configuration

### MariaDB

- Uses Debian as base image
- Stores WordPress database
- Configured for performance and security
- Includes a setup script for database initialization
- Data persists through a Docker volume

## Networking

The containers communicate with each other through a custom Docker network:

- Nginx receives external requests on port 443
- Nginx forwards requests to WordPress
- WordPress communicates with MariaDB for data storage and retrieval

## Volumes

The project uses Docker volumes to persist data:

- **WordPress Volume**: Stores WordPress files
- **Database Volume**: Stores MariaDB data

This ensures that data survives container restarts or rebuilds.

## Setup and Installation

1. Clone the repository
   ```bash
   git clone <repository-url>
   cd inception
   ```

2. Create or modify the `.env` file with your desired configuration
   ```
    # Domain name settings
    DOMAIN_NAME=login.42.fr
    
    # MYSQL/MariaDB settings
    SQL_DATABASE=
    SQL_ROOT_PASSWORD=
    SQL_USER=
    SQL_PASSWORD=
    
    # WordPress settings and additional user
    WP_TITLE=
    WP_ADMIN_USER=
    WP_ADMIN_PASSWORD=
    WP_ADMIN_EMAIL=

    WP_USER=
    WP_USER_EMAIL=
    WP_USER_PASSWORD=
    WP_USER_ROLE=
   ```

3. Build and start the containers
   ```bash
   make
   ```

4. Access WordPress
   ```
   https://<DOMAIN_NAME>
   ```

## Usage

Once the containers are running:

1. The WordPress site will be available at `https://<DOMAIN_NAME>` (or your configured domain)
2. You can log in to the WordPress admin panel at `https://<DOMAIN_NAME>/wp-admin` using the credentials from the `.env` file
