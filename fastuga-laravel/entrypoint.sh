#!/bin/bash

# Start the Laravel server
php artisan serve --host=0.0.0.0 --port=8081 &

/var/www/html/cloud_sql_proxy -instances=cloud-computing-prj1-fastuga:us-central1:fastuga-database=tcp:3306 &

# Wait for Cloud SQL Proxy to start
while ! mysqladmin ping -h 127.0.0.1 --silent; do
    echo "Waiting for Cloud SQL Proxy to start..."
    sleep 1
done

if [ ! -f /var/www/html/migration_completed.txt ]; then
    # Run Laravel migrations, seeds, etc.
    php artisan migrate
    php artisan db:seed
    php artisan storage:link
    php artisan passport:install

    # Create a file to indicate migration completion
    touch /var/www/html/migration_completed.txt
else
    echo "Migrations have already been performed, skipping..."
fi

# Keep the container running
tail -f /dev/null
