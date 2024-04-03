up:
	docker-compose up -d
data: 
	docker exec fastuga-api bash -c "php artisan migrate"
	docker exec fastuga-api bash -c "php artisan db:seed"
	docker exec fastuga-api bash -c "php artisan storage:link"
	docker exec fastuga-api bash -c "php artisan passport:install --force"

down:
	docker exec fastuga-api bash -c "php artisan cache:clear"
	docker exec fastuga-api bash -c "php artisan config:clear"
	docker exec fastuga-api bash -c "composer dump-autoload"
	docker exec fastuga-api bash -c "sudo chmod -R 755 storage"
	docker-compose down -v --rmi "local"