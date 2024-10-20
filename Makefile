export PORT=42076

run:
	docker-compose down
	docker-compose rm -f
	docker-compose pull
	docker-compose up --build -d
