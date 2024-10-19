export PORT=42076

build:
	docker-compose build --no-cache

run:
	docker-compose up -d --force-recreate
