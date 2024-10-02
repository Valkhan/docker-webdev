FROM php:8.1-apache

# Suppress debconf complaints of trying to install apt packages interactively
ARG DEBIAN_FRONTEND=noninteractive

# Update
RUN apt-get -y update --fix-missing && \
    apt-get upgrade -y && \
    apt-get --no-install-recommends install -y apt-utils && \
    rm -rf /var/lib/apt/lists/*

# Install useful tools and install important libraries
RUN apt-get -y update && \
    apt-get -y --no-install-recommends install nano wget dialog \
        libsqlite3-dev libsqlite3-0 default-mysql-client zlib1g-dev libzip-dev libicu-dev \
        apt-utils build-essential git curl libonig-dev iputils-ping zip unzip curl sudo \
        libcurl4 libcurl4-openssl-dev zip openssl libmagickwand-dev && \
    rm -rf /var/lib/apt/lists/* && \
    curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Install xdebug
RUN pecl install xdebug && \
    docker-php-ext-enable xdebug && \
    mkdir /var/log/xdebug

# Install the latest Imagick extension from PECL
RUN pecl channel-update pecl.php.net
RUN pecl install imagick && \
    docker-php-ext-enable imagick

# Other PHP8 Extensions
RUN docker-php-ext-install pdo_mysql && \
    docker-php-ext-install pdo_sqlite && \
    docker-php-ext-install mysqli && \
    docker-php-ext-install curl && \
    docker-php-ext-install zip && \
    docker-php-ext-install -j$(nproc) intl && \
    docker-php-ext-install mbstring && \
    docker-php-ext-install gettext && \
    docker-php-ext-install calendar && \
    docker-php-ext-install gd && \
    docker-php-ext-install intl && \
    docker-php-ext-install bcmath && \
    docker-php-ext-install opcache && \
    docker-php-ext-install bz2 && \
    docker-php-ext-install exif

# Install Freetype
RUN apt-get -y update && \
    apt-get --no-install-recommends install -y libfreetype6-dev libjpeg62-turbo-dev libpng-dev && \
    rm -rf /var/lib/apt/lists/* && \
    docker-php-ext-configure gd --enable-gd --with-freetype --with-jpeg && \
    docker-php-ext-install gd

# Ensure an SSL directory exists
RUN mkdir -p /etc/apache2/ssl

# Enable SSL support
RUN a2enmod ssl && a2enmod rewrite

# Enable apache modules
RUN a2enmod rewrite headers

# MSSQL support https://learn.microsoft.com/pt-br/sql/connect/php/release-notes-php-sql-driver?view=sql-server-ver16#510
RUN apt-get update && apt-get install -y gpg unixodbc unixodbc-dev
RUN pecl install sqlsrv-5.12.0 pdo_sqlsrv-5-12-0

# Adding custom MS repository
RUN curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add - && \
    curl https://packages.microsoft.com/config/debian/9/prod.list > /etc/apt/sources.list.d/mssql-release.list

# Install SQL Server drivers and tools
RUN apt-get update && ACCEPT_EULA=Y apt-get install -y msodbcsql17 && \
    echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> ~/.bashrc && \
    /bin/bash -c "source ~/.bashrc"

# Set locale
RUN apt-get -y install locales && \
    echo "en_US.UTF-8 UTF-8" > /etc/locale.gen && \
    locale-gen

# Cleanup
RUN rm -rf /usr/src/*

EXPOSE 80
