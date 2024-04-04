#!/bin/bash

# Start the Laravel server
php artisan serve --host=0.0.0.0 --port=8081 &

# Run Laravel migrations, seeds, etc.
php artisan migrate
php artisan db:seed
php artisan storage:link
php artisan passport:install

# Keep the container running
tail -f /dev/null
