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

# Update composer and install dependencies
ENV COMPOSER_ALLOW_SUPERUSER=1
COPY --from=composer/composer:latest-bin /composer /usr/bin/composer
RUN composer update -W

# Install laravel passport
RUN composer require laravel/passport

# Download and install Cloud SQL Proxy
RUN curl -o /var/www/html/cloud_sql_proxy https://dl.google.com/cloudsql/cloud_sql_proxy.linux.amd64 && \
    chmod +x /var/www/html/cloud_sql_proxy

# Set the GOOGLE_APPLICATION_CREDENTIALS environment variable to point to the service account key file
ENV GOOGLE_APPLICATION_CREDENTIALS="/var/www/html/cloud-computing-prj1-fastuga-dbee5723dca7.json"

# RUN /var/www/html/cloud_sql_proxy -instances=cloud-computing-prj1-fastuga:us-central1:fastuga-database=tcp:3306 &

EXPOSE 8081

# Make the entrypoint script executable
RUN chmod +x /var/www/html/entrypoint.sh
ENTRYPOINT ["/var/www/html/entrypoint.sh"]
