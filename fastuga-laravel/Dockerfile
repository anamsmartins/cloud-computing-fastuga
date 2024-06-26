FROM php:8.1-cli
WORKDIR /var/www/html

# Install required PHP dependencies
RUN apt-get update && \
    apt-get install -y \
        sudo \
        zip \
        unzip \
        libcurl4-openssl-dev \
        libonig-dev && \
    docker-php-ext-install \
        curl \
        mysqli \
        mbstring \
        pdo \
        pdo_mysql && \
    rm -rf /var/lib/apt/lists/*

COPY . .

# Update composer and install dependencies
ENV COMPOSER_ALLOW_SUPERUSER=1
COPY --from=composer/composer:latest-bin /composer /usr/bin/composer
RUN composer update -W

# Install laravel passport
RUN composer require laravel/passport

EXPOSE 8081

# Make the entrypoint script executable
RUN chmod +x /var/www/html/entrypoint.sh
ENTRYPOINT ["/var/www/html/entrypoint.sh"]
