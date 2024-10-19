export PORT=42076

run:
	docker-compose pull
	docker-compose up -d --force-recreate
