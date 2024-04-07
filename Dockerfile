FROM php:8.1-cli
WORKDIR /var/www/html

# Install required PHP dependencies
RUN apt-get update && \
    apt-get install -y \
        default-mysql-client \
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

RUN cp /var/www/html/.env.example /var/www/html/.env

ARG DATABASE_URL
ENV DATABASE_URL $DATABASE_URL

ARG DB_PASSWORD
ENV DB_PASSWORD $DB_PASSWORD

# Update composer and install dependencies
ENV COMPOSER_ALLOW_SUPERUSER=1
COPY --from=composer/composer:latest-bin /composer /usr/bin/composer
RUN composer update -W

# Install laravel passport
RUN composer require laravel/passport

RUN php artisan serve --host=0.0.0.0 --port=8081 &

RUN php artisan migrate
RUN php artisan db:seed
RUN php artisan storage:link
RUN php artisan passport:install

EXPOSE 8081

# Make the entrypoint script executable
# RUN chmod +x /var/www/html/entrypoint.sh
# ENTRYPOINT ["/var/www/html/entrypoint.sh"]
ENTRYPOINT ["php", "artisan", "serve", "--host=0.0.0.0", "--port=8081"]
