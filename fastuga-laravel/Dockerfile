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

# RUN chmod -R 777 /var/www/html/storage
# RUN chown -R www-data:www-data /var/www/html

EXPOSE 8081
ENTRYPOINT ["php", "artisan", "serve", "--host=0.0.0.0", "--port=8081"]
